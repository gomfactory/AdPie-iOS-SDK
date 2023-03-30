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
    
    // load
    NSString *parameter = adConfiguration.credentials.settings[@"parameter"];
    NSDictionary *info = [AdMobAdPieBannerAd dictionaryWithJsonString:parameter];
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
    
    UIViewController *rootViewController = adConfiguration.topViewController;
    if (!rootViewController) {
        NSError *error = [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorInvalidRequest description:@"Root view controller cannot be nil."];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf->_adLoadCompletionHandler(nil, error);
        });
        return;
    }
    
    CGSize bannerSize = adConfiguration.adSize.size;
    self.adView = [[APAdView alloc] initWithFrame:CGRectMake(0, 0, bannerSize.width, bannerSize.height)];
    self.adView.slotId = slotId;
    self.adView.delegate = self;
    self.adView.rootViewController = rootViewController;
    
    NSString *floorPrice = [info objectForKey:@"floor_price"];
    if (floorPrice != nil) {
        [self.adView setExtraParameterForKey:@"floorPrice" value:floorPrice];
    }
    
    [self.adView load];
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
