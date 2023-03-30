#import <Foundation/Foundation.h>
#import <AppLovinSDK/AppLovinSDK.h>
#import <AdPieSDK/AdPieSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppLovinAdPieAdapter : ALMediationAdapter <MAAdViewAdapter, MAInterstitialAdapter, MARewardedAdapter, MANativeAdAdapter>

@end

NS_ASSUME_NONNULL_END
