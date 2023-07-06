#include <stdatomic.h>
#import "AdMobAdPieBannerAd.h"
#import "AdmobAdPieUtils.h"
#import "AdMobAdPieAdError.h"

@interface AdMobAdPieBannerAd () <GADMediationBannerAd, APAdViewDelegate> {
    GADMediationBannerLoadCompletionHandler _adLoadCompletionHandler;
    __weak id<GADMediationBannerAdEventDelegate> _delegate;
}
@property (strong) APAdView *adView;
@end

@implementation AdMobAdPieBannerAd

- (void)loadBannerForAdConfiguration:(nonnull GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(nonnull GADMediationBannerLoadCompletionHandler)completionHandler
{
    [self loadBannerFor:adConfiguration completionHandler:completionHandler];
}

- (void)loadBannerFor:(nonnull GADMediationBannerAdConfiguration *)adConfiguration
    completionHandler:(nonnull GADMediationBannerLoadCompletionHandler)completionHandler
{
    // Store the completion handler for later use.
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationBannerLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
    _adLoadCompletionHandler = ^id<GADMediationBannerAdEventDelegate>(_Nullable id<GADMediationBannerAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }
        id<GADMediationBannerAdEventDelegate> delegate = nil;
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
        
        UIViewController *rootViewController = adConfiguration.topViewController;
        if (!rootViewController) {
            NSError *error = [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorInvalidRequest description:@"Root view controller cannot be nil."];
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if(strongSelf) {
                    strongSelf->_adLoadCompletionHandler(nil, error);
                }
            });
            return;
        }
        
        if(strongSelf) {
            CGSize bannerSize = adConfiguration.adSize.size;
            strongSelf.adView = [[APAdView alloc] initWithFrame:CGRectMake(0, 0, bannerSize.width, bannerSize.height)];
            strongSelf.adView.slotId = slotId;
            strongSelf.adView.delegate = strongSelf;
            strongSelf.adView.rootViewController = rootViewController;
            NSString *floorPrice = [info objectForKey:@"floor_price"];
            if (floorPrice != nil) {
                [strongSelf.adView setExtraParameterForKey:@"floorPrice" value:floorPrice];
            }
            [strongSelf.adView load];
        }
    }];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    return [AdmobAdPieUtils dictionaryWithJsonString:jsonString];
}

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

#pragma mark - APAdViewDelegate

- (void)adViewDidLoadAd:(APAdView *)view {
    _delegate = _adLoadCompletionHandler(self, nil);
}

- (void)adViewDidFailToLoadAd:(APAdView *)view withError:(NSError *)error {
    _adLoadCompletionHandler(nil, [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorNoFill]);
}

- (void)adViewWillLeaveApplication:(APAdView *)view {
    [_delegate reportClick];
}


#pragma mark - GADMediationBannerAd

- (UIView *)view {
    return _adView;
}

@end
