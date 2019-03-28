//
//  AdPieAdapterConfiguration.m
//  AdPieSDK
//
//  Created by sunny on 19/03/2019.
//  Copyright © 2019 GomFactory. All rights reserved.
//

#import "AdPieAdapterConfiguration.h"
#import <AdPieSDK/AdPieSDK.h>
#import "AdPieConfig.h"

static NSString * const kAdPieMediaId = @"media_id";
static NSString * const kAdapterErrorDomain = @"com.mopub.mopub-ios-sdk.mopub-adpie-adapters";

typedef NS_ENUM(NSInteger, AdPieAdapterErrorCode) {
    AdPieAdpaterErrorCodeMissingMediaId
};

@implementation AdPieAdapterConfiguration

#pragma mark - Caching

+ (void)updateInitializationParameters:(NSDictionary *)parameters {
    // These should correspond to the required parameters checked in
    // `initializeNetworkWithConfiguration:complete:`
    NSString * mediaId = parameters[kAdPieMediaId];

    if (mediaId != nil) {
        NSDictionary * configuration = @{ kAdPieMediaId: mediaId };
        [AdPieAdapterConfiguration setCachedInitializationParameters:configuration];
    }
}

#pragma mark - MPAdapterConfiguration

- (NSString *)adapterVersion {
    return @"1.0.0";
}

- (NSString *)biddingToken {
    return nil;
}

- (NSString *)moPubNetworkName {
    return @"adpie";
}

- (NSString *)networkSdkVersion {
    return [AdPieSDK sdkVersion];
}

- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> *)configuration
                                  complete:(void(^)(NSError *))complete {
    
    NSString * mediaId = configuration[kAdPieMediaId];
    
    if (mediaId == nil) {
        NSError * error = [NSError errorWithDomain:kAdapterErrorDomain code:AdPieAdpaterErrorCodeMissingMediaId userInfo:@{ NSLocalizedDescriptionKey: @"AdPie's initialization skipped. The mediaId is empty. Ensure it is properly configured on the MoPub dashboard." }];
        MPLogEvent([MPLogEvent error:error message:nil]);
        
        if (complete != nil) {
            complete(error);
        }
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [AdPieConfig initialize:mediaId];
    });
    
    if (complete != nil) {
        complete(nil);
    }
}


@end
