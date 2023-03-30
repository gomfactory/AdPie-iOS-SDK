#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdMobAdPieInterstitialAd : NSObject <GADMediationAdapter>
//@interface AdMobAdPieInterstitialAd : NSObject <GADMediationInterstitialAd>

/// Asks the receiver to render the ad configuration.
- (void)loadInterstitialForAdConfiguration:(nonnull GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:(nonnull GADMediationInterstitialLoadCompletionHandler)completionHandler;

@end
