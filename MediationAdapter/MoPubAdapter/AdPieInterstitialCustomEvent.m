//
//  AdPieInterstitialCustomEvent.m
//  AdPieSDK
//
//  Created by sunny on 19/03/2019.
//  Copyright © 2019 GomFactory. All rights reserved.
//

#import "AdPieInterstitialCustomEvent.h"
#import "AdPieAdapterConfiguration.h"
#import "AdPieConfig.h"
#import <AdPieSDK/APInterstitial.h>

static NSString * const kAdPieMediaId = @"media_id";
static NSString * const kAdPieSlotId = @"slot_id";

@interface  AdPieInterstitialCustomEvent() <APInterstitialDelegate>

@property (nonatomic, strong) APInterstitial* adInterstitial;
@property (nonatomic, copy) NSString *mediaId;
@property (nonatomic, copy) NSString *slotId;

@end

@implementation AdPieInterstitialCustomEvent

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    self.mediaId = [info objectForKey:kAdPieMediaId];
    self.slotId = [info objectForKey:kAdPieSlotId];
    
    if (!self.mediaId || !self.slotId) {
        NSString *failureReason = [NSString stringWithFormat:@"Make sure that the AdPie mediaId or slotId parameter is not nil"];
        
        NSError *error = [self createErrorWith:failureReason
                                     andReason:@""
                                 andSuggestion:@""];
        
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        
        return;
    } else {
        MPLogInfo(@"Server info fetched from MoPub for AdPie. meidaId : %@, slotId : %@", self.mediaId, self.slotId);
    }
    
    // Cache the initialization parameters
    [AdPieAdapterConfiguration updateInitializationParameters:info];
    
    [[AdPieSDK sharedInstance] logging];
    [AdPieConfig initialize:self.mediaId];
    
    self.adInterstitial = [[APInterstitial alloc] initWithSlotId:self.slotId];
    self.adInterstitial.delegate = self;
    [self.adInterstitial load];
    
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], [self getAdNetworkId]);
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    
    if (self.adInterstitial.isReady) {
        [self.adInterstitial presentFromRootViewController:rootViewController];
    } else {
        NSError *error = [self createErrorWith:@"Trying to show a AdPie interstitial ad when it's not ready."
                                     andReason:@""
                                 andSuggestion:@""];
        
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)dealloc
{
    self.adInterstitial.delegate = nil;
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
#pragma mark APInterstitialDelegate delegates

- (void)interstitialDidLoadAd:(APInterstitial *)interstitial {
    [self.delegate interstitialCustomEvent:self didLoadAd:interstitial];
    
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
}

- (void)interstitialDidFailToLoadAd:(APInterstitial *)interstitial withError:(NSError *)error {
    NSString *failureReason = [NSString stringWithFormat: @"AdPie Interstitial failed to load with error: %@", error.localizedDescription];
    NSError *mopubError = [NSError errorWithCode:MOPUBErrorAdapterInvalid localizedDescription:failureReason];
    
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:mopubError], [self getAdNetworkId]);
}

- (void)interstitialWillPresentScreen:(APInterstitial *)interstitial {
    MPLogAdEvent(MPLogEvent.adShowSuccess, self.slotId);
    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidAppear:self];
    
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
}

- (void)interstitialWillDismissScreen:(APInterstitial *)interstitial {
    [self.delegate interstitialCustomEventWillDisappear:self];
    MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
}

- (void)interstitialDidDismissScreen:(APInterstitial *)interstitial {
    [self.delegate interstitialCustomEventDidDisappear:self];
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
}

- (void)interstitialWillLeaveApplication:(APInterstitial *)interstitial {
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
    
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
}

@end
