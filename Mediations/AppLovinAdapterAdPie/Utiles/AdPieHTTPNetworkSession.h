#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *AdPieHTTPMethod NS_STRING_ENUM;
extern AdPieHTTPMethod const AdPieHTTPMethodGet;
extern AdPieHTTPMethod const AdPieHTTPMethodPost;

@interface AdPieHTTPNetworkSession : NSObject
/**
 Singleton instance of @c AdPieHTTPNetworkSession.
 */
+ (instancetype)sharedInstance;


/**
 Initializes a HTTP network request.
 @param request Request to send.
 @param responseHandler Optional response handler that will be invoked on the current thread.
 @param errorHandler Optional error handler that will be invoked on the current thread.
 @param shouldRedirectWithNewRequest Optional logic control block to determine if a redirection should occur. This is invoked on the current thread.
 @returns The HTTP networking task.
 */
+ (NSURLSessionTask *)taskWithHttpRequest:(NSURLRequest *)request
                          responseHandler:(void (^ _Nullable)(NSData *data, NSHTTPURLResponse *response))responseHandler
                             errorHandler:(void (^ _Nullable)(NSError *error))errorHandler
             shouldRedirectWithNewRequest:(BOOL (^ _Nullable)(NSURLSessionTask *task, NSURLRequest *newRequest))shouldRedirectWithNewRequest;

/**
 Initializes a HTTP network request and immediately sends it.
 @param request Request to send.
 @returns The HTTP networking task.
 */
+ (NSURLSessionTask *)startTaskWithHttpRequest:(NSURLRequest *)request;

/**
 Initializes a HTTP network request and immediately sends it.
 @param request Request to send.
 @param responseHandler Optional response handler that will be invoked on the main thread.
 @param errorHandler Optional error handler that will be invoked on the main thread.
 @returns The HTTP networking task.
 */
+ (NSURLSessionTask *)startTaskWithHttpRequest:(NSURLRequest *)request
                               responseHandler:(void (^ _Nullable)(NSData *data, NSHTTPURLResponse *response))responseHandler
                                  errorHandler:(void (^ _Nullable)(NSError *error))errorHandler;

/**
 Initializes a HTTP network request and immediately sends it.
 @param request Request to send.
 @param responseHandler Optional response handler that will be invoked on the main thread.
 @param errorHandler Optional error handler that will be invoked on the main thread.
 @param shouldRedirectWithNewRequest Optional logic control block to determine if a redirection should occur. This is invoked on the current thread.
 @returns The HTTP networking task.
 */
+ (NSURLSessionTask *)startTaskWithHttpRequest:(NSURLRequest *)request
                               responseHandler:(void (^ _Nullable)(NSData *data, NSHTTPURLResponse *response))responseHandler
                                  errorHandler:(void (^ _Nullable)(NSError *error))errorHandler
                  shouldRedirectWithNewRequest:(BOOL (^ _Nullable)(NSURLSessionTask *task, NSURLRequest *newRequest))shouldRedirectWithNewRequest;


+ (NSURLSessionTask *)taskWithHTTPRequestURLString:(NSString *)URLString
                                            method:(AdPieHTTPMethod)method
                                        parameters:(NSDictionary *_Nullable)parameters
                                   responseHandler:(void (^ _Nullable)(NSData *data, NSHTTPURLResponse *response))responseHandler
                                      errorHandler:(void (^ _Nullable)(NSError * error))errorHandler
                      shouldRedirectWithNewRequest:(BOOL (^ _Nullable)(NSURLSessionTask *task, NSURLRequest * newRequest))shouldRedirectWithNewRequest;

// GET
+ (NSURLSessionTask *)GETStartTaskWithRequestURLString:(NSString *)URLString;

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString parameters:(NSDictionary *_Nullable)parameters;

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler;

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                                parameters:(NSDictionary *_Nullable)parameters
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler;

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler
                                              errorHandler:(void (^ _Nullable)(NSError * error))errorHandler;

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                                parameters:(NSDictionary *_Nullable)parameters
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler
                                              errorHandler:(void (^ _Nullable)(NSError * error))errorHandler;

+ (NSURLSessionTask *)GETStartTaskWithHTTPRequestURLString:(NSString *)URLString
                                                parameters:(NSDictionary *_Nullable)parameters
                                           responseHandler:(void (^ _Nullable)(NSData *data, NSDictionary *dict, NSHTTPURLResponse *response))responseHandler
                                              errorHandler:(void (^ _Nullable)(NSError * error))errorHandler
                              shouldRedirectWithNewRequest:(BOOL (^ _Nullable)(NSURLSessionTask * task, NSURLRequest * newRequest))shouldRedirectWithNewRequest;

@end

NS_ASSUME_NONNULL_END
