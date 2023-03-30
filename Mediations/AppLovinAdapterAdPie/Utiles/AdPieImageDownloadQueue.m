#import "AdPieImageDownloadQueue.h"
#import "AdPieHTTPNetworkSession.h"
#import "AdPieWebBrowserUserAgent.h"
#import "AppLovinAdPieAdError.h"
#import "AdPieCache.h"
#import "AdPieImageCreatorObjC.h"

@interface AdPieImageDownloadQueue ()

@property (atomic, strong) NSOperationQueue *imageDownloadQueue;
@property (atomic, assign) BOOL isCanceled;

@end

@implementation AdPieImageDownloadQueue

- (id)init {
    self = [super init];
    if (self != nil) {
        _imageDownloadQueue = [[NSOperationQueue alloc] init];
        [_imageDownloadQueue setMaxConcurrentOperationCount:1]; // serial queue
    }
    return self;
}

- (void)dealloc {
    [_imageDownloadQueue cancelAllOperations];
}

- (void)addDownloadImageURLs:(NSArray<NSURL *> *)imageURLs
             completionBlock:(AdPieImageDownloadQueueCompletionBlock)completionBlock {
    [self addDownloadImageURLs:imageURLs useCachedImage:YES completionBlock:completionBlock];
}

- (void)addDownloadImageURLs:(NSArray<NSURL *> *)imageURLs
              useCachedImage:(BOOL)useCachedImage
             completionBlock:(AdPieImageDownloadQueueCompletionBlock)completionBlock
{
    __block NSMutableDictionary *result = [NSMutableDictionary new];
    __block NSMutableArray *errors = nil;
    
    for (NSURL *imageURL in imageURLs) {
        [self.imageDownloadQueue addOperationWithBlock:^{
            @autoreleasepool {
                if ([[AdPieCache sharedCache] cachedDataExistsForKey:imageURL.absoluteString] && useCachedImage) {
                    NSData *imageData = [[AdPieCache sharedCache] retrieveDataForKey:imageURL.absoluteString];
                    UIImage *image = [AdPieImageCreatorObjC image:imageData];
                    result[imageURL] = image;
                    
                } else if (![[AdPieCache sharedCache] cachedDataExistsForKey:imageURL.absoluteString] || !useCachedImage) {
                    __block NSError *error = nil;
                    __block NSData *data = nil;
                    
                    // Synchronous attempt to fetch the image.
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageURL];
                    [request setValue:AdPieWebBrowserUserAgent.userAgent forHTTPHeaderField:@"User-Agent"];
                    [request setHTTPShouldHandleCookies:NO];
                    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
                    [request setTimeoutInterval:2.0];
                    [request setHTTPMethod:@"GET"];
                    
                    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                    [AdPieHTTPNetworkSession startTaskWithHttpRequest:request responseHandler:^(NSData * _Nonnull responseData, NSHTTPURLResponse * _Nonnull response) {
                        data = responseData;
                        dispatch_semaphore_signal(semaphore);
                    } errorHandler:^(NSError * _Nonnull networkError) {
                        error = networkError;
                        dispatch_semaphore_signal(semaphore);
                    }];
                    
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                    
                    BOOL validImageDownloaded = data != nil;
                    if (validImageDownloaded) {
                        UIImage *downloadedImage = [AdPieImageCreatorObjC image:data];
                        if (downloadedImage != nil) {
                            [[AdPieCache sharedCache] storeData:data forKey:imageURL.absoluteString];
                            result[imageURL] = downloadedImage;
                        } else {
                            validImageDownloaded = NO;
                        }
                    }
                    
                    if (!validImageDownloaded) {
                        if (error == nil) {
                            error =  [AppLovinAdPieAdError errorWithCode:AppLovinAdPieAdErrorServerData];
                        }
                        if (errors == nil) {
                            errors = [NSMutableArray array];
                        }
                        [errors addObject:error];
                    }
                }
            }
        }];
    }
    
    // after all images have been downloaded, invoke callback on main thread
    __weak typeof(self) weakSelf = self;
    [self.imageDownloadQueue addOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (!strongSelf.isCanceled) {
                completionBlock(result, errors);
            }
        });
    }];
}

- (void)cancelAllDownloads {
    self.isCanceled = YES;
    [self.imageDownloadQueue cancelAllOperations];
}


@end

