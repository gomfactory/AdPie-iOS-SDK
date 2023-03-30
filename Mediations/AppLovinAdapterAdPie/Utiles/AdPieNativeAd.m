#import "AdPieNativeAd.h"
#import "AdPieNativeAdData.h"
#import "AdPieHTTPNetworkSession.h"
#import "AppLovinAdPieAdError.h"

@interface AdPieNativeAd ()

@property (assign, getter=isReportedImpression) BOOL reportedImpression;

@end

@implementation AdPieNativeAd

- (void)loadWithAdData:(AdPieNativeAdData *)adData {
    _adData = adData;
    
    if (adData == nil) {
        if ([self.delegate respondsToSelector:@selector(nativeAd:didFailToLoadWithError:)]) {
            [self.delegate nativeAd:self didFailToLoadWithError:[AppLovinAdPieAdError errorWithCode:AppLovinAdPieAdErrorInvalidRequest]];
        }
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(nativeAdDidLoad:)]) {
        [self.delegate nativeAdDidLoad:self];
    }
}

- (void)fireImpression {
    if (self.adData && self.adData.trackImpressionURLs) {
        // impression 중복 호출되지 않도록 플래그 추가
        if (!self.isReportedImpression) {
            self.reportedImpression = YES;
            for (NSString *string in self.adData.trackImpressionURLs) {
                [AdPieHTTPNetworkSession GETStartTaskWithRequestURLString:string];
            }
            
            if ([self.delegate respondsToSelector:@selector(nativeAdTrackImpression:)]) {
                [self.delegate nativeAdTrackImpression:self];
            }
        }
    }
}

- (void)invokeDefaultAction {
    if (self.adData && self.adData.trackClickURLs) {
        for (NSString *string in self.adData.trackClickURLs) {
            [AdPieHTTPNetworkSession GETStartTaskWithRequestURLString:string];
        }
    }
    NSURL *url = [NSURL URLWithString:self.adData.link];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    }
}

- (void)invokePrivacyIconAction {
    if (self.adData && self.adData.optoutLink) {
        NSURL *url = [NSURL URLWithString:self.adData.optoutLink];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end

