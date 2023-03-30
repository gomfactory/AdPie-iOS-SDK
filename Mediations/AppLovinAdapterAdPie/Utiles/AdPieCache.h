#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdPieCache : NSObject

+ (instancetype)sharedCache;

- (BOOL)cachedDataExistsForKey:(NSString *)key;
- (NSData *)retrieveDataForKey:(NSString *)key;
- (void)storeData:(NSData *)data forKey:(NSString *)key;
- (void)removeAllDataFromCache;
- (void)setInMemoryCacheEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END

