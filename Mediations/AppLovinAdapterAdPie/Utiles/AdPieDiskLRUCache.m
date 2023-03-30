#import "AdPieDiskLRUCache.h"
#import <CommonCrypto/CommonDigest.h>

// cached files that have not been access since kCacheFileMaxAge ago will be evicted
#define kCacheFileMaxAge (7 * 24 * 60 * 60) // 1 week

// once the cache hits this size AND we've added at least kCacheBytesStoredBeforeSizeCheck bytes,
// cached files will be evicted (LRU) until the total size drops below this limit
#define kCacheSoftMaxSize (100 * 1024 * 1024) // 100 MB

#define kCacheBytesStoredBeforeSizeCheck (kCacheSoftMaxSize / 10) // 10% of kCacheSoftMaxSize

@interface AdPieDiskLRUCacheFile : NSObject

@property (copy) NSString *filePath;
@property (assign) NSTimeInterval lastModTimestamp;
@property (assign) uint64_t fileSize;

@end

@implementation AdPieDiskLRUCacheFile
@end // this data object should have empty implementation

@interface AdPieDiskLRUCache ()

/**
 Note: Only use this @c diskIOQueue for direct operations to fileManager, and avoid nested access
 to @c diskIOQueue to avoid crash.
 */
@property (strong) dispatch_queue_t diskIOQueue;
@property (strong) NSFileManager *fileManager;
@property (copy) NSString *diskCachePath;
@property (atomic, assign) uint64_t numBytesStoredForSizeCheck;

@end

@implementation AdPieDiskLRUCache

+ (AdPieDiskLRUCache *)sharedDiskCache {
    static dispatch_once_t once;
    static AdPieDiskLRUCache *sharedDiskCache;
    dispatch_once(&once, ^{
        sharedDiskCache = [self new];
    });
    return sharedDiskCache;
}

- (id)init {
    if (self = [super init]) {
        _diskIOQueue = dispatch_queue_create("com.adpie.sdk.diskCacheIOQueue", DISPATCH_QUEUE_SERIAL);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if (paths.count > 0) {
            _diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"com.adpie.sdk.diskCache"];
            
            _fileManager = [NSFileManager defaultManager];
            if (![_fileManager fileExistsAtPath:_diskCachePath]) {
                [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        
        [self ensureCacheSizeLimit];
    }
    
    return self;
}


- (BOOL)cachedDataExistsForKey:(NSString *)key {
    __block BOOL result = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_sync(self.diskIOQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        result = [strongSelf.fileManager fileExistsAtPath:[strongSelf cacheFilePathForKey:key]];
    });
    
    return result;
}

- (NSData *)retrieveDataForKey:(NSString *)key {
    __block NSData *data = nil;
    
    if ([self cachedDataExistsForKey:key]) {
        NSString *cacheFilePath = [self cacheFilePathForKey:key];
        data = [NSData dataWithContentsOfFile:cacheFilePath];
        [self touchCacheFileAtPath:cacheFilePath];
    }
    
    return data;
}

- (void)storeData:(NSData *)data forKey:(NSString *)key {
    NSString *cacheFilePath = [self cacheFilePathForKey:key];
    
    __weak typeof(self) weakSelf = self;
    dispatch_sync(self.diskIOQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (![strongSelf.fileManager fileExistsAtPath:cacheFilePath]) {
            [strongSelf.fileManager createFileAtPath:cacheFilePath contents:data attributes:nil];
        } else {
            // overwrite existing file
            [data writeToFile:cacheFilePath atomically:YES];
        }
    });
    
    self.numBytesStoredForSizeCheck += data.length;
    
    if (self.numBytesStoredForSizeCheck >= kCacheBytesStoredBeforeSizeCheck) {
        [self ensureCacheSizeLimit];
        self.numBytesStoredForSizeCheck = 0;
    }
}

- (void)removeAllCachedFiles {
    __weak typeof(self) weakSelf = self;
    dispatch_sync(self.diskIOQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        NSArray *allFiles = [strongSelf cacheFilesSortedByModDate];
        for (AdPieDiskLRUCacheFile *file in allFiles) {
            [strongSelf.fileManager removeItemAtPath:file.filePath error:nil];
        }
    });
}

#pragma mark - Private

- (void)ensureCacheSizeLimit {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableArray *cacheFilesSortedByModDate = [weakSelf cacheFilesSortedByModDate];
        dispatch_async(self.diskIOQueue, ^{
            @autoreleasepool {
                __strong typeof(self) strongSelf = weakSelf;
                // verify age
                NSArray *expiredFiles = [strongSelf expiredCachedFilesInArray:cacheFilesSortedByModDate];
                for (AdPieDiskLRUCacheFile *file in expiredFiles) {
                    [strongSelf.fileManager removeItemAtPath:file.filePath error:nil];
                    [cacheFilesSortedByModDate removeObject:file];
                }
                
                // verify size
                while ([strongSelf sizeOfCacheFilesInArray:cacheFilesSortedByModDate] >= kCacheSoftMaxSize && cacheFilesSortedByModDate.count > 0) {
                    NSString *oldestFilePath = ((AdPieDiskLRUCacheFile *)[cacheFilesSortedByModDate objectAtIndex:0]).filePath;
                    [strongSelf.fileManager removeItemAtPath:oldestFilePath error:nil];
                    [cacheFilesSortedByModDate removeObjectAtIndex:0];
                }
            }
        });
    });
}

- (NSArray *)expiredCachedFilesInArray:(NSArray *)cachedFiles {
    NSMutableArray *result = [NSMutableArray array];
    
    NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
    
    for (AdPieDiskLRUCacheFile *file in cachedFiles) {
        if (now - file.lastModTimestamp >= kCacheFileMaxAge) {
            [result addObject:file];
        }
    }
    
    return result;
}

- (NSMutableArray *)cacheFilesSortedByModDate {
    NSArray *cachedFiles = [self.fileManager contentsOfDirectoryAtPath:self.diskCachePath error:nil];
    NSArray *sortedFiles = [cachedFiles sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *fileName1 = [self.diskCachePath stringByAppendingPathComponent:(NSString *)obj1];
        NSString *fileName2 = [self.diskCachePath stringByAppendingPathComponent:(NSString *)obj2];
        
        NSDictionary *fileAttrs1 = [self.fileManager attributesOfItemAtPath:fileName1 error:nil];
        NSDictionary *fileAttrs2 = [self.fileManager attributesOfItemAtPath:fileName2 error:nil];
        
        NSDate *lastModDate1 = [fileAttrs1 fileModificationDate];
        NSDate *lastModDate2 = [fileAttrs2 fileModificationDate];
        
        return [lastModDate1 compare:lastModDate2];
    }];
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *fileName in sortedFiles) {
        if ([fileName hasPrefix:@"."]) {
            continue;
        }
        
        AdPieDiskLRUCacheFile *cacheFile = [[AdPieDiskLRUCacheFile alloc] init];
        cacheFile.filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
        
        NSDictionary *fileAttrs = [self.fileManager attributesOfItemAtPath:cacheFile.filePath error:nil];
        cacheFile.fileSize = [fileAttrs fileSize];
        cacheFile.lastModTimestamp = [[fileAttrs fileModificationDate] timeIntervalSinceReferenceDate];
        
        [result addObject:cacheFile];
    }
    
    return result;
}

- (uint64_t)sizeOfCacheFilesInArray:(NSArray *)files {
    uint64_t currentSize = 0;
    
    for (AdPieDiskLRUCacheFile *file in files) {
        currentSize += file.fileSize;
    }
    return currentSize;
}

- (NSString *)cacheFilePathForKey:(NSString *)key {
    NSString *hashedKey = [self hashWithSHA1:key];
    NSString *cachedFilePath = [self.diskCachePath stringByAppendingPathComponent:hashedKey];
    return cachedFilePath;
}

- (void)touchCacheFileAtPath:(NSString *)cachedFilePath {
    __weak typeof(self) weakSelf = self;
    dispatch_sync(self.diskIOQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.fileManager setAttributes:@{NSFileModificationDate: [NSDate date]} ofItemAtPath:cachedFilePath error:nil];
    });
}

- (NSString *)hashWithSHA1:(NSString *)string {
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    CC_SHA1([data bytes], (CC_LONG)[data length], digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
