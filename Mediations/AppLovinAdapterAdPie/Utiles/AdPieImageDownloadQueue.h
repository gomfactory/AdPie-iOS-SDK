#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AdPieImageDownloadQueueCompletionBlock)(NSDictionary <NSURL *, UIImage *> *result, NSArray *errors);

@interface AdPieImageDownloadQueue : NSObject

- (void)addDownloadImageURLs:(NSArray<NSURL *> *)imageURLs
             completionBlock:(AdPieImageDownloadQueueCompletionBlock)completionBlock;

- (void)cancelAllDownloads;

@end

NS_ASSUME_NONNULL_END
