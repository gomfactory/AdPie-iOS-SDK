#import "AdPieHTTPNetworkSession.h"
#import "AdPieHTTPNetworkTaskData.h"
#import "AdPieWebBrowserUserAgent.h"
#import "AppLovinAdPieAdError.h"

// Macros for dispatching asynchronously to the main queue
#define safe_block(block, ...) block ? block(__VA_ARGS__) : nil
#define async_queue_block(queue, block, ...) dispatch_async(queue, ^ \
{ \
safe_block(block, __VA_ARGS__); \
})
#define main_queue_block(block, ...) async_queue_block(dispatch_get_main_queue(), block, __VA_ARGS__);

AdPieHTTPMethod const AdPieHTTPMethodGet = @"GET";
AdPieHTTPMethod const AdPieHTTPMethodPost = @"POST";

@interface AdPieHTTPNetworkSession() <NSURLSessionDataDelegate>
@property (strong) NSURLSession *sharedSession;
@property (strong) NSDictionary<NSURLSessionTask *, AdPieHTTPNetworkTaskData *> *sessions;
@property (strong) dispatch_queue_t sessionsQueue;

@end

@implementation AdPieHTTPNetworkSession

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id _sharedInstance;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        // Shared `NSURLSession` to be used for all `AdPieHTTPNetworkTask` objects. All tasks should use this single
        // session so that the DNS lookup and SSL handshakes do not need to be redone.
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 2.0;
        sessionConfig.timeoutIntervalForResource = 4.0;
        
        _sharedSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        
        // Dictionary of all sessions currently in flight.
        _sessions = [NSMutableDictionary dictionary];
        _sessionsQueue = dispatch_queue_create("com.adpie.sdk.httpnetworksession.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

#pragma mark - Session Access

- (void)setSessionData:(AdPieHTTPNetworkTaskData *)data forTask:(NSURLSessionTask *)task {
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_sync(self.sessionsQueue, ^{
        __typeof__(self) strongSelf = weakSelf;
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:strongSelf.sessions];
        mutableDict[task] = data;
        strongSelf.sessions = [NSDictionary dictionaryWithDictionary:mutableDict];
    });
}

/**
 Retrieves the task data for the specified task. Accessing the data is thread
 safe, but mutating the data is not thread safe.
 @param task Task which needs a data retrieval.
 @return The task data or @c nil
 */
- (AdPieHTTPNetworkTaskData *)sessionDataForTask:(NSURLSessionTask *)task {
    __weak typeof(self) weakSelf = self;
    __block AdPieHTTPNetworkTaskData * data = nil;
    dispatch_sync(self.sessionsQueue, ^{
        __typeof__(self) strongSelf = weakSelf;
        data = strongSelf.sessions[task];
    });
    
    return data;
}

/**
 Appends additional data to the @c responseData field of @c AdPieHTTPNetworkTaskData in
 a thread safe manner.
 @param data New data to append.
 @param task Task to append the data to.
 */
- (void)appendData:(NSData *)data toSessionDataForTask:(NSURLSessionTask *)task {
    // No data to append or task.
    if (data == nil || task == nil) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_sync(self.sessionsQueue, ^{
        __typeof__(self) strongSelf = weakSelf;
        // Do nothing if there is no task data entry.
        AdPieHTTPNetworkTaskData *taskData = strongSelf.sessions[task];
        if (taskData == nil) {
            return;
        }
        
        // Append the new data to the task.
        if (taskData.responseData == nil) {
            taskData.responseData = [NSMutableData data];
        }
        
        [taskData.responseData appendData:data];
    });
}

#pragma mark - Manual Start Tasks

+ (NSURLSessionTask *)taskWithHttpRequest:(NSURLRequest *)request
                          responseHandler:(void (^ _Nullable)(NSData * data, NSHTTPURLResponse * response))responseHandler
                             errorHandler:(void (^ _Nullable)(NSError * error))errorHandler
             shouldRedirectWithNewRequest:(BOOL (^ _Nullable)(NSURLSessionTask * task, NSURLRequest * newRequest))shouldRedirectWithNewRequest {
    // Networking task
    NSURLSessionDataTask *task = [AdPieHTTPNetworkSession.sharedInstance.sharedSession dataTaskWithRequest:request];
    
    // Initialize the task data
    AdPieHTTPNetworkTaskData *taskData = [[AdPieHTTPNetworkTaskData alloc] initWithResponseHandler:responseHandler errorHandler:errorHandler shouldRedirectWithNewRequest:shouldRedirectWithNewRequest];
    
    // Update the sessions.
    [AdPieHTTPNetworkSession.sharedInstance setSessionData:taskData forTask:task];
    
    return task;
}

+ (NSURLSessionTask *)taskWithHTTPRequestURLString:(NSString *)URLString
                                            method:(AdPieHTTPMethod)method
                                        parameters:(NSDictionary *)parameters
                                   responseHandler:(void (^ _Nullable)(NSData *data, NSHTTPURLResponse *response))responseHandler
                                      errorHandler:(void (^ _Nullable)(NSError * error))errorHandler
                      shouldRedirectWithNewRequest:(BOOL (^ _Nullable)(NSURLSessionTask *task, NSURLRequest * newRequest))shouldRedirectWithNewRequest {
    NSURL *URL;
    if (URLString != nil && URLString.length > 0) {
        URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        URL = [NSURL URLWithString:URLString];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:AdPieWebBrowserUserAgent.userAgent forHTTPHeaderField:@"User-Agent"];
    [request setHTTPShouldHandleCookies:NO];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:2.0];
    [request setHTTPMethod:method];
    
    if (parameters != nil) {
        if (method == AdPieHTTPMethodPost) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
            request.HTTPBody = data;
            
        } else {
            NSURLComponents *components = [NSURLComponents componentsWithString:URL.absoluteString];
            NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
            
            for (NSString *key in parameters) {
                NSString *value = [[parameters objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
                NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:value];
                
                [queryItems addObject:item];
            }
            components.queryItems = queryItems;
            [request setURL:components.URL];
        }
    }
    
    if (![URLString containsString:@"api.mediation.adxcorp.kr/v1/metrics/log"]) {
        NSMutableString *message = [NSMutableString stringWithString:@"\n\t------- <REQUEST> --------\n"];
        [message appendFormat:@"\t%-10s: %@\n", "URL", [request.URL description]];
        [message appendFormat:@"\t%-10s: %@\n", "METHOD", [request HTTPMethod]];
        
        for (NSString *header in [request allHTTPHeaderFields]) {
            [message appendFormat:@"\t%-10s: %@\n", header.UTF8String, [request valueForHTTPHeaderField:header]];
        }
        
        if ([request.HTTPMethod isEqualToString:@"POST"]) {
            [message appendFormat:@"\t%-10s: %@\n", "BODY", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]];
        }
        [message appendString:@"\t--------------------------"];
    }
    
    return [AdPieHTTPNetworkSession taskWithHttpRequest:request responseHandler:responseHandler errorHandler:errorHandler shouldRedirectWithNewRequest:shouldRedirectWithNewRequest];
}

#pragma mark - Automatic Start Tasks

+ (NSURLSessionTask *)startTaskWithHttpRequest:(NSURLRequest *)request {
    return [AdPieHTTPNetworkSession startTaskWithHttpRequest:request responseHandler:nil errorHandler:nil shouldRedirectWithNewRequest:nil];
}

+ (NSURLSessionTask *)startTaskWithHttpRequest:(NSURLRequest *)request
                               responseHandler:(void (^ _Nullable)(NSData * data, NSHTTPURLResponse * response))responseHandler
                                  errorHandler:(void (^ _Nullable)(NSError * error))errorHandler {
    return [AdPieHTTPNetworkSession startTaskWithHttpRequest:request responseHandler:responseHandler errorHandler:errorHandler shouldRedirectWithNewRequest:nil];
}

+ (NSURLSessionTask *)startTaskWithHttpRequest:(NSURLRequest *)request
                               responseHandler:(void (^ _Nullable)(NSData * data, NSHTTPURLResponse * response))responseHandler
                                  errorHandler:(void (^ _Nullable)(NSError * error))errorHandler
                  shouldRedirectWithNewRequest:(BOOL (^ _Nullable)(NSURLSessionTask * task, NSURLRequest * newRequest))shouldRedirectWithNewRequest {
    // Generate a manual start task.
    NSURLSessionTask *task = [AdPieHTTPNetworkSession taskWithHttpRequest:request responseHandler:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        main_queue_block(responseHandler, data, response);
    } errorHandler:^(NSError * _Nonnull error) {
        main_queue_block(errorHandler, error);
    } shouldRedirectWithNewRequest:shouldRedirectWithNewRequest];
    
    // Immediately start the task.
    [task resume];
    
    return task;
}

+ (NSURLSessionTask *)GETStartTaskWithRequestURLString:(NSString *)URLString {
    return [AdPieHTTPNetworkSession GETStartTaskWithHTTPRequestURLString:URLString parameters:nil responseHandler:nil errorHandler:nil shouldRedirectWithNewRequest:nil];
}

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString parameters:(NSDictionary *_Nullable)parameters {
    return [AdPieHTTPNetworkSession GETStartTaskWithHTTPRequestURLString:URLString parameters:parameters responseHandler:nil errorHandler:nil shouldRedirectWithNewRequest:nil];
}

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler {
    return [AdPieHTTPNetworkSession GETStartTaskWithHTTPRequestURLString:URLString parameters:nil responseHandler:responseHandler errorHandler:nil shouldRedirectWithNewRequest:nil];
}

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                                parameters:(NSDictionary *_Nullable)parameters
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler {
    return [AdPieHTTPNetworkSession GETStartTaskWithHTTPRequestURLString:URLString parameters:parameters responseHandler:responseHandler errorHandler:nil shouldRedirectWithNewRequest:nil];
}

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler
                                              errorHandler:(void (^ _Nullable)(NSError * error))errorHandler {
    return [AdPieHTTPNetworkSession GETStartTaskWithHTTPRequestURLString:URLString parameters:nil responseHandler:responseHandler errorHandler:errorHandler shouldRedirectWithNewRequest:nil];
}

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                                parameters:(NSDictionary *_Nullable)parameters
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler
                                              errorHandler:(void (^ _Nullable)(NSError * error))errorHandler {
    return [AdPieHTTPNetworkSession GETStartTaskWithHTTPRequestURLString:URLString parameters:parameters responseHandler:responseHandler errorHandler:errorHandler shouldRedirectWithNewRequest:nil];
}

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                                parameters:(NSDictionary *_Nullable)parameters
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler
                                              errorHandler:(void (^ _Nullable)(NSError * error))errorHandler
                              shouldRedirectWithNewRequest:(BOOL (^ _Nullable)(NSURLSessionTask * task, NSURLRequest * newRequest))shouldRedirectWithNewRequest {
    NSURLSessionTask *task = [AdPieHTTPNetworkSession taskWithHTTPRequestURLString:URLString
                                                                          method:AdPieHTTPMethodGet
                                                                      parameters:parameters
                                                                 responseHandler:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        if (responseHandler) {
            NSError *jsonError;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if (jsonError) {
                main_queue_block(errorHandler, jsonError);
            } else {
                main_queue_block(responseHandler, data, dict, response);
            }
        }
        
    } errorHandler:^(NSError * _Nonnull error) {
        main_queue_block(errorHandler, error);
        
    } shouldRedirectWithNewRequest:shouldRedirectWithNewRequest];
    
    [task resume];
    
    return task;
}


#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    // Allow all responses.
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    // Append the new data to the task.
    [self appendData:data toSessionDataForTask:dataTask];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    // Retrieve the task data.
    AdPieHTTPNetworkTaskData *taskData = [self sessionDataForTask:task];
    if (taskData == nil) {
        completionHandler(request);
        return;
    }
    
    // If there is a redirection handler block registered with the HTTP task, we should
    // query for it's response. By default, we will allow the redirection.
    NSURLRequest *newRequest = request;
    if (taskData.shouldRedirectWithNewRequest != nil && !taskData.shouldRedirectWithNewRequest(task, request)) {
        // Reject the redirection.
        newRequest = nil;
    }
    
    completionHandler(newRequest);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    // Retrieve the task data.
    AdPieHTTPNetworkTaskData *taskData = [self sessionDataForTask:task];
    if (taskData == nil) {
        return;
    }
    
    // Remove the task data from the currently in flight sessions.
    [self setSessionData:nil forTask:task];
    
    // Validate that response is not an error.
    if (error != nil) {
        safe_block(taskData.errorHandler, error);
        return;
    }
    
    // Validate response is a HTTP response.
    NSHTTPURLResponse *httpResponse = [task.response isKindOfClass:[NSHTTPURLResponse class]] ? (NSHTTPURLResponse *)task.response : nil;
    if (httpResponse == nil) {
        NSError *networkError = [AppLovinAdPieAdError errorWithCode:AppLovinAdPieAdErrorNetwork];
        safe_block(taskData.errorHandler, networkError);
        return;
    }
    
    if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
        NSError *networkError = [AppLovinAdPieAdError errorWithCode:AppLovinAdPieAdErrorNetwork];
        safe_block(taskData.errorHandler, networkError);
        
        return;
    }
    
    // By this point all of the fields have been validated.
    safe_block(taskData.responseHandler, taskData.responseData, httpResponse);
}

@end

