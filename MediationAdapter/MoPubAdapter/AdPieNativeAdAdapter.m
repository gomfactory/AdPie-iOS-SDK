//
//  AdPieNativeAdAdapter.m
//  AdPieSDK
//
//  Created by sunny on 19/03/2019.
//  Copyright © 2019 GomFactory. All rights reserved.
//

#import "AdPieNativeAdAdapter.h"

@interface AdPieNativeAdAdapter() <MPAdImpressionTimerDelegate>

@property (nonatomic) MPAdImpressionTimer *impressionTimer;
@property (nonatomic, strong) APNativeAd *adpieNativeAd;
@property (nonatomic, readonly) UIImageView *mainImageView;
@property (nonatomic, readonly) UIImageView *iconImageView;

@end

@implementation AdPieNativeAdAdapter

@synthesize properties = _properties;

- (instancetype)initWithAdPieAdNative:(APNativeAd *)ad {
    if (self = [super init]) {
        
        self.adpieNativeAd = ad;
        
        NSMutableDictionary<NSString *, id> *properties = [NSMutableDictionary dictionary];
        
        if(ad.nativeAdData.title){
            properties[kAdTitleKey] = ad.nativeAdData.title;
        }
        
        if(ad.nativeAdData.desc){
            properties[kAdTextKey] = ad.nativeAdData.desc;
        }
        
        if(ad.nativeAdData.callToAction){
            properties[kAdCTATextKey] = ad.nativeAdData.callToAction;
        }
        
        if(ad.nativeAdData.rating){
            properties[kAdStarRatingKey] = [NSNumber numberWithDouble:ad.nativeAdData.rating];
        }
        
        if(ad.nativeAdData.mainImageUrl){
            properties[kAdMainImageKey] = ad.nativeAdData.mainImageUrl;
        }
        
        if(ad.nativeAdData.iconImageUrl){
            properties[kAdIconImageKey] = ad.nativeAdData.iconImageUrl;
        }
        
        if(ad.nativeAdData.optoutImageUrl){
            properties[kAdPrivacyIconImageUrlKey] = ad.nativeAdData.optoutImageUrl;
        }

        if (ad.nativeAdData.optoutLink) {
            properties[kAdPrivacyIconClickUrlKey] = ad.nativeAdData.optoutLink;
        }
        
        _properties = properties;
        
        self.impressionTimer = [[MPAdImpressionTimer alloc] initWithRequiredSecondsForImpression:0.0 requiredViewVisibilityPercentage:0.5];
        self.impressionTimer.delegate = self;
    }
    return self;
}

#pragma mark - <MPNativeAdAdapter>

- (NSURL *)defaultActionURL {
    return nil;
}

#pragma mark - Click Tracking

- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller {
    [self.adpieNativeAd invokeDefaultAction];
    [self.delegate nativeAdDidClick:self];
    
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], nil);
}

#pragma mark - Impression tracking

- (void)willAttachToView:(UIView *)view {
    [self.impressionTimer startTrackingView:view];
}

- (void)adViewWillLogImpression:(UIView *)adView {
    [self.delegate nativeAdWillLogImpression:self];
    
    [self.adpieNativeAd fireImpression];
    [self.delegate nativeAdWillLogImpression:self];
    
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], nil);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], nil);
}
@end
