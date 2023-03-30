#import <UIKit/UIKit.h>
#import "AdPieCache.h"
#import "AdPieDiskLRUCache.h"

typedef NS_OPTIONS(NSUInteger, AdPieCacheMethod) {
    AdPieCacheMethodDisk = 0,
    AdPieCacheMethodDiskAndMemory = 1 << 0
};

@interface AdPieCache () <NSCacheDelegate>

@property (strong) NSCache *memoryCache;
@property (strong) AdPieDiskLRUCache *diskCache;
@property (assign) AdPieCacheMethod cacheMethod;

- (BOOL)cachedDataExistsForKey:(NSString *)key withCacheMethod:(AdPieCacheMethod)cacheMethod;
- (NSData *)retrieveDataForKey:(NSString *)key withCacheMethod:(AdPieCacheMethod)cacheMethod;
- (void)storeData:(id)data forKey:(NSString *)key withCacheMethod:(AdPieCacheMethod)cacheMethod;
- (void)removeAllDataFromMemory;
- (void)removeAllDataFromDisk;

@end

@implementation AdPieCache

+ (instancetype)sharedCache {
    static dispatch_once_t once;
    static AdPieCache *sharedCache;
    dispatch_once(&once, ^{
        sharedCache = [[self alloc] init];
    });
    return sharedCache;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.delegate = self;
        _diskCache = [[AdPieDiskLRUCache alloc] init];
        _cacheMethod = AdPieCacheMethodDiskAndMemory;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:[UIApplication sharedApplication]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidReceiveMemoryWarningNotification
                                                  object:nil];
}


#pragma mark - Public Cache Interactions

- (void)setInMemoryCacheEnabled:(BOOL)enabled {
    if (enabled) {
        self.cacheMethod = AdPieCacheMethodDiskAndMemory;
    } else {
        self.cacheMethod = AdPieCacheMethodDisk;
        [self.memoryCache removeAllObjects];
    }
}

- (BOOL)cachedDataExistsForKey:(NSString *)key {
    return [self cachedDataExistsForKey:key withCacheMethod:self.cacheMethod];
}

- (NSData *)retrieveDataForKey:(NSString *)key {
    return [self retrieveDataForKey:key withCacheMethod:self.cacheMethod];
}

- (void)storeData:(NSData *)data forKey:(NSString *)key {
    [self storeData:data forKey:key withCacheMethod:self.cacheMethod];
}

- (void)removeAllDataFromCache {
    [self removeAllDataFromMemory];
    [self removeAllDataFromDisk];
}


#pragma mark - Private Cache Implementation

- (BOOL)cachedDataExistsForKey:(NSString *)key withCacheMethod:(AdPieCacheMethod)cacheMethod {
    BOOL dataExists = NO;
    if (cacheMethod & AdPieCacheMethodDiskAndMemory) {
        dataExists = [self.memoryCache objectForKey:key] != nil;
    }
    
    if (!dataExists) {
        dataExists = [self.diskCache cachedDataExistsForKey:key];
    }
    
    return dataExists;
}

- (id)retrieveDataForKey:(NSString *)key withCacheMethod:(AdPieCacheMethod)cacheMethod {
    id data = nil;
    
    if (cacheMethod & AdPieCacheMethodDiskAndMemory) {
        data = [self.memoryCache objectForKey:key];
    }
    if (data == nil) {
        data = [self.diskCache retrieveDataForKey:key];
        
        if (data && cacheMethod & AdPieCacheMethodDiskAndMemory) {
            [self.memoryCache setObject:data forKey:key];
        }
    }
    return data;
}

- (void)storeData:(id)data forKey:(NSString *)key withCacheMethod:(AdPieCacheMethod)cacheMethod {
    if (data == nil) {
        return;
    }
    if (cacheMethod & AdPieCacheMethodDiskAndMemory) {
        [self.memoryCache setObject:data forKey:key];
    }
    [self.diskCache storeData:data forKey:key];
}

- (void)removeAllDataFromMemory {
    [self.memoryCache removeAllObjects];
}

- (void)removeAllDataFromDisk {
    [self.diskCache removeAllCachedFiles];
}


#pragma mark - Notifications

- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    [self.memoryCache removeAllObjects];
}


#pragma mark - NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    
}

@end
