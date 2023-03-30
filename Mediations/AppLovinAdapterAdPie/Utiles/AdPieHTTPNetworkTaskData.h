#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdPieHTTPNetworkTaskData : NSObject

@property (strong, nullable) NSMutableData *responseData;
@property (copy, nullable) void (^responseHandler)(NSData *data, NSHTTPURLResponse *response);
@property (copy, nullable) void (^errorHandler)(NSError *error);
@property (copy, nullable) BOOL (^shouldRedirectWithNewRequest)(NSURLSessionTask *task, NSURLRequest *newRequest);

/**
 Initializes the task data with the given handlers.
 @param responseHandler Optional response handler that will be invoked on the current thread.
 @param errorHandler Optional error handler that will be invoked on the current thread.
 @param shouldRedirectWithNewRequest Optional logic control block to determine if a redirection should occur. This is invoked on the current thread.
 @returns The HTTP networking task data.
 */
- (instancetype)initWithResponseHandler:(void (^ _Nullable)(NSData *data, NSHTTPURLResponse *response))responseHandler
                           errorHandler:(void (^ _Nullable)(NSError *error))errorHandler
           shouldRedirectWithNewRequest:(BOOL (^ _Nullable)(NSURLSessionTask *task, NSURLRequest *newRequest))shouldRedirectWithNewRequest NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
