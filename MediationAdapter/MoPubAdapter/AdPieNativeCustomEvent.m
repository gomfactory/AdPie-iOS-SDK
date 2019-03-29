//
//  AdPieNativeCustomEvent.m
//  AdPieSDK
//
//  Created by sunny on 19/03/2019.
//  Copyright © 2019 GomFactory. All rights reserved.
//

#import "AdPieNativeCustomEvent.h"
#import "AdPieAdapterConfiguration.h"
#import "AdPieConfig.h"
#import "AdPieNativeAdAdapter.h"
#import <AdPieSDK/APNativeAd.h>

static NSString * const kAdPieMediaId = @"mediaId";
static NSString * const kAdPieSlotId = @"slotId";

@interface AdPieNativeCustomEvent () <APNativeDelegate>

@property (nonatomic, retain) APNativeAd *nativeAd;
@property (nonatomic, copy) NSString *mediaId;
@property (nonatomic, copy) NSString *slotId;

@end

@implementation AdPieNativeCustomEvent

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    self.mediaId = [info objectForKey:kAdPieMediaId];
    self.slotId = [info objectForKey:kAdPieSlotId];
    
    if (!self.mediaId || !self.slotId) {
        NSString *failureReason = [NSString stringWithFormat:@"Make sure that the AdPie mediaId or slotId parameter is not nil"];
        
        NSError *error = [self createErrorWith:failureReason
                                     andReason:@""
                                 andSuggestion:@""];
        
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        
        return;
    } else {
        MPLogInfo(@"Server info fetched from MoPub for AdPie. meidaId : %@, slotId : %@", self.mediaId, self.slotId);
    }
    
    // Cache the initialization parameters
    [AdPieAdapterConfiguration updateInitializationParameters:info];
    
    [[AdPieSDK sharedInstance] logging];
    [AdPieConfig initialize:self.mediaId];
    
    self.nativeAd = [[APNativeAd alloc] initWithSlotId:self.slotId];
    self.nativeAd.delegate = self;
    [self.nativeAd load];
    
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], [self getAdNetworkId]);
}

- (void)dealloc
{
    self.nativeAd.delegate = nil;
}

- (NSError *)createErrorWith:(NSString *)description andReason:(NSString *)reaason andSuggestion:(NSString *)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reaason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:userInfo];
}

- (NSString *) getAdNetworkId {
    return (self.slotId) ? self.slotId : @"";
}

#pragma mark -
#pragma mark APNativeDelegate delegates

- (void)nativeDidLoadAd:(APNativeAd *)nativeAd {
    
    AdPieNativeAdAdapter *adAdapter = [[AdPieNativeAdAdapter alloc] initWithAdPieAdNative:nativeAd];
    MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adAdapter];

    [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
}

- (void)nativeDidFailToLoadAd:(APNativeAd *)nativeAd
                    withError:(NSError *)error {
    
    NSString *failureReason = [NSString stringWithFormat: @"AdPie native ad failed to load with error: %@", error.localizedDescription];
    NSError *mopubError = [NSError errorWithCode:MOPUBErrorAdapterInvalid localizedDescription:failureReason];
    
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:mopubError], [self getAdNetworkId]);
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)nativeWillLeaveApplication:(APNativeAd *)nativeAd {
}

@end
