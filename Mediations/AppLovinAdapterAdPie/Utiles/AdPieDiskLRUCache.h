#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdPieDiskLRUCache : NSObject

+ (AdPieDiskLRUCache *)sharedDiskCache;

- (BOOL)cachedDataExistsForKey:(NSString *)key;
- (NSData *)retrieveDataForKey:(NSString *)key;
- (void)storeData:(NSData *)data forKey:(NSString *)key;
- (void)removeAllCachedFiles;

@end

NS_ASSUME_NONNULL_END
