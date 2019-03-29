//
//  AdPieBannerCustomEvent.m
//  AdPieSDK
//
//  Created by sunny on 19/03/2019.
//  Copyright © 2019 GomFactory. All rights reserved.
//

#import "AdPieBannerCustomEvent.h"
#import "AdPieAdapterConfiguration.h"
#import "AdPieConfig.h"
#import <AdPieSDK/APAdView.h>

static NSString * const kAdPieMediaId = @"mediaId";
static NSString * const kAdPieSlotId = @"slotId";
static NSString * const kAdPieAdWidth = @"adWidth";
static NSString * const kAdPieAdHeight = @"adHeight";

@interface AdPieBannerCustomEvent () <APAdViewDelegate>

@property(nonatomic, strong) APAdView *adView;
@property (nonatomic, copy) NSString *mediaId;
@property (nonatomic, copy) NSString *slotId;

@end

@implementation AdPieBannerCustomEvent

- (id)init {
    self = [super init];
    if (self) {
        self.adView = [[APAdView alloc] initWithFrame:CGRectZero];
        self.adView.delegate = self;
    }
    return self;
}

- (void)dealloc {
    self.adView.delegate = nil;
    self.adView = nil;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    self.mediaId = [info objectForKey:kAdPieMediaId];
    self.slotId = [info objectForKey:kAdPieSlotId];
    
    if (!self.mediaId || !self.slotId) {
        NSString *failureReason = [NSString stringWithFormat:@"Make sure that the AdPie mediaId or slotId parameter is not nil"];
        
        NSError *error = [self createErrorWith:failureReason
                                     andReason:@""
                                 andSuggestion:@""];
        
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        return;
    } else {
        MPLogInfo(@"Server info fetched from MoPub for AdPie. meidaId : %@, slotId : %@", self.mediaId, self.slotId);
    }
    
    self.adView.frame = [self frameForCustomEventInfo:info];
    self.adView.slotId = self.slotId;
    self.adView.rootViewController = [self.delegate viewControllerForPresentingModalView];
    
    // Cache the network initialization parameters
    [AdPieAdapterConfiguration updateInitializationParameters:info];
    
    [AdPieConfig initialize:self.mediaId];
    
    [self.adView load];
    
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], [self getAdNetworkId]);
}

- (CGRect)frameForCustomEventInfo:(NSDictionary *)info {
    CGFloat width = [[info objectForKey:kAdPieAdWidth] floatValue];
    CGFloat height = [[info objectForKey:kAdPieAdHeight] floatValue];
    
    if(width < 320 && height < 50){
        width = 320;
        height = 50;
    }
    
    return CGRectMake(0, 0, width, height);
}

- (NSString *) getAdNetworkId {
    return (self.slotId) ? self.slotId : @"";
}

- (NSError *)createErrorWith:(NSString *)description andReason:(NSString *)reaason andSuggestion:(NSString *)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reaason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:userInfo];
}

#pragma mark -
#pragma mark APAdView delegates

- (void)adViewDidLoadAd:(APAdView *)view {
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    
    [self.delegate bannerCustomEvent:self didLoadAd:self.adView];
}

- (void)adViewDidFailToLoadAd:(APAdView *)view withError:(NSError *)error {
    NSString *failureReason = [NSString stringWithFormat: @"AdPie Banner failed to load with error: %@", error.localizedDescription];
    NSError *mopubError = [NSError errorWithCode:MOPUBErrorAdapterInvalid localizedDescription:failureReason];
    
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:mopubError], [self getAdNetworkId]);
}

- (void)adViewWillLeaveApplication:(APAdView *)view {
    [self.delegate bannerCustomEventWillLeaveApplication:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
}

@end
