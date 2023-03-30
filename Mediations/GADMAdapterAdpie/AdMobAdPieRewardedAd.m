#include <stdatomic.h>
#import "AdMobAdPieRewardedAd.h"
#import "AdmobAdPieUtils.h"
#import "AdMobAdPieAdError.h"

@interface AdMobAdPieRewardedAd () <GADMediationRewardedAd, APRewardedAdDelegate> {
    GADMediationRewardedLoadCompletionHandler _adLoadCompletionHandler;
    __weak id<GADMediationRewardedAdEventDelegate> _delegate;
}

@property (strong) APRewardedAd *rewardedAd;

@end

@implementation AdMobAdPieRewardedAd

#pragma mark - GADMediationBannerAd

+ (GADVersionNumber)adSDKVersion {
    return [AdmobAdPieUtils adSDKVersion];
}

+ (GADVersionNumber)adapterVersion {
    return [AdmobAdPieUtils adapterVersion];
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return nil;
}

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration
             completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler
{
    [AdmobAdPieUtils setUpWithConfiguration:configuration completionHandler:completionHandler];
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler
{
    // Store the completion handler for later use.
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
    _adLoadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(_Nullable id<GADMediationRewardedAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }
        id<GADMediationRewardedAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
        }
        originalCompletionHandler = nil;
        return delegate;
    };
    
    NSString *parameter = adConfiguration.credentials.settings[@"parameter"];
    NSDictionary *info = [AdmobAdPieUtils dictionaryWithJsonString:parameter];
    NSString *slotId = [info objectForKey:@"slot_id"];
    
    if (slotId == nil || slotId.length == 0) {
        NSError *error = [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorInvalidRequest description:@"AdPie SDK slot ID cannot be nil."];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf->_adLoadCompletionHandler(nil, error);
        });
        return;
    }
    
    self.rewardedAd = [[APRewardedAd alloc] initWithSlotId:slotId];
    self.rewardedAd.delegate = self;
    
    NSString *floorPrice = [info objectForKey:@"floor_price"];
    if (floorPrice != nil) {
        [self.rewardedAd setExtraParameterForKey:@"floorPrice" value:floorPrice];
    }
    
    [self.rewardedAd load];
}

- (void)presentFromViewController:(UIViewController *)viewController {
    [self.rewardedAd presentFromRootViewController:viewController];
}


#pragma mark - APRewardedAdDelegate

- (void)rewardedAdDidLoadAd:(APRewardedAd *)rewardedAd {
    _delegate = _adLoadCompletionHandler(self, nil);
}

- (void)rewardedAdDidFailToLoadAd:(APRewardedAd *)rewardedAd withError:(NSError *)error {
    _adLoadCompletionHandler(nil, [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorNoFill]);
}

- (void)rewardedAdWillPresentScreen:(APRewardedAd *)rewardedAd {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate willPresentFullScreenView];
    [strongDelegate reportImpression];
}

- (void)rewardedAdDidDismissScreen:(APRewardedAd *)rewardedAd {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate didDismissFullScreenView];
}

- (void)rewardedAdWillLeaveApplication:(APRewardedAd *)rewardedAd {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate reportClick];
}

- (void)rewardedAdDidEarnReward:(APRewardedAd *)rewardedAd {
    [_delegate didRewardUser];
}

@end
