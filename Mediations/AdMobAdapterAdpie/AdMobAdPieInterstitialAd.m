#include <stdatomic.h>
#import "AdMobAdPieInterstitialAd.h"
#import "AdmobAdPieUtils.h"
#import "AdMobAdPieAdError.h"

@interface AdMobAdPieInterstitialAd () <GADMediationInterstitialAd, APInterstitialDelegate> {
    GADMediationInterstitialLoadCompletionHandler _adLoadCompletionHandler;
    __weak id<GADMediationInterstitialAdEventDelegate> _delegate;
}

@property (strong) APInterstitial *interstitialAd;

@end

@implementation AdMobAdPieInterstitialAd

#pragma mark - GADMediationInterstitialAd

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

- (void)loadInterstitialAdForAdConfiguration:(nonnull GADMediationInterstitialAdConfiguration *)adConfiguration
                           completionHandler:(nonnull GADMediationInterstitialLoadCompletionHandler)completionHandler
{
    [self loadInterstitialAd:adConfiguration completionHandler:completionHandler];
}

- (void)loadInterstitialForAdConfiguration:(nonnull GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:(nonnull GADMediationInterstitialLoadCompletionHandler)completionHandler
{
    [self loadInterstitialAd:adConfiguration completionHandler:completionHandler];
}

- (void)loadInterstitialAd:(nonnull GADMediationInterstitialAdConfiguration *)adConfiguration
         completionHandler:(nonnull GADMediationInterstitialLoadCompletionHandler)completionHandler
{
    // Store the completion handler for later use.
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationInterstitialLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
    _adLoadCompletionHandler = ^id<GADMediationInterstitialAdEventDelegate>(_Nullable id<GADMediationInterstitialAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }
        id<GADMediationInterstitialAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
        }
        originalCompletionHandler = nil;
        return delegate;
    };
    
    NSString *parameter = adConfiguration.credentials.settings[@"parameter"];
    NSDictionary *info = [AdmobAdPieUtils dictionaryWithJsonString:parameter];
    NSString *appId = [info objectForKey:@"app_id"];
    NSString *slotId = [info objectForKey:@"slot_id"];
    
    __weak typeof(self) weakSelf = self;
    [AdmobAdPieUtils adPieSdkInitialize:appId completionHandler:^(BOOL result) {
        __strong typeof(self) strongSelf = weakSelf;
        if(!result) {
            NSError *error = [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorSdkNotInitialize
                                                  description:@"AdPie SDK must be initialized before ads loading."];
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if(strongSelf) {
                    strongSelf->_adLoadCompletionHandler(nil, error);
                }
            });
            return;
        }
        
        if (![slotId length]) {
            NSError *error = [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorInvalidRequest
                                                  description:@"AdPie SDK slot ID cannot be nil."];
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if(strongSelf) {
                    strongSelf->_adLoadCompletionHandler(nil, error);
                }
            });
            return;
        }
        
        if(strongSelf) {
            strongSelf.interstitialAd = [[APInterstitial alloc] initWithSlotId:slotId];
            strongSelf.interstitialAd.delegate = strongSelf;
            NSString *floorPrice = [info objectForKey:@"floor_price"];
            if (floorPrice != nil) {
                [strongSelf.interstitialAd setExtraParameterForKey:@"floorPrice" value:floorPrice];
            }
            [strongSelf.interstitialAd load];
        }
    }];
}

- (void)presentFromViewController:(UIViewController *)viewController {
    if (self.interstitialAd.isReady) {
        [self.interstitialAd presentFromRootViewController:viewController];
    }
}


#pragma mark - APInterstitialDelegate

- (void)interstitialDidLoadAd:(APInterstitial *)interstitial {
    _delegate = _adLoadCompletionHandler(self, nil);
}

- (void)interstitialDidFailToLoadAd:(APInterstitial *)interstitial withError:(NSError *)error {
    _adLoadCompletionHandler(nil, [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorNoFill]);
}

- (void)interstitialWillPresentScreen:(APInterstitial *)interstitial {
    id<GADMediationInterstitialAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate willPresentFullScreenView];
    [strongDelegate reportImpression];
}

- (void)interstitialWillDismissScreen:(APInterstitial *)interstitial {
    id<GADMediationInterstitialAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate willDismissFullScreenView];
}

- (void)interstitialDidDismissScreen:(APInterstitial *)interstitial {
    id<GADMediationInterstitialAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate didDismissFullScreenView];
}

- (void)interstitialWillLeaveApplication:(APInterstitial *)interstitial {
    [_delegate reportClick];
}

@end
