//
//  AdPieNativeAdRenderer.m
//  AdPieSDK
//
//  Created by sunny on 19/03/2019.
//  Copyright © 2019 GomFactory. All rights reserved.
//

#import "AdPieNativeAdRenderer.h"
#import "AdPieNativeAdAdapter.h"
#import <AdPieSDK/AdPieSDK.h>

@interface AdPieNativeAdRenderer () <MPNativeAdRendererImageHandlerDelegate>

@property (nonatomic, strong) UIView<MPNativeAdRendering> *adView;
@property (nonatomic, strong) AdPieNativeAdAdapter<MPNativeAdAdapter> *adapter;
@property (nonatomic, assign) BOOL adViewInViewHierarchy;
@property (nonatomic, strong) Class renderingViewClass;
@property (nonatomic, strong) MPNativeAdRendererImageHandler *rendererImageHandler;
@property (nonatomic, strong) APNativeAdView *adpieNativeAdView;

@end

@implementation AdPieNativeAdRenderer

@synthesize viewSizeHandler;

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:
(id<MPNativeAdRendererSettings>)rendererSettings {
    MPNativeAdRendererConfiguration *config = [[MPNativeAdRendererConfiguration alloc] init];
    config.rendererClass = [self class];
    config.rendererSettings = rendererSettings;
    config.supportedCustomEvents = @[ @"AdPieNativeCustomEvent" ];
    
    return config;
}

- (instancetype)initWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings {
    if (self = [super init]) {
        MPStaticNativeAdRendererSettings *settings =
        (MPStaticNativeAdRendererSettings *)rendererSettings;
        _renderingViewClass = settings.renderingViewClass;
        viewSizeHandler = [settings.viewSizeHandler copy];
        _rendererImageHandler = [MPNativeAdRendererImageHandler new];
        _rendererImageHandler.delegate = self;
    }
    
    return self;
}

- (UIView *)retrieveViewWithAdapter:(id<MPNativeAdAdapter>)adapter error:(NSError *__autoreleasing *)error {
    if (!adapter || ![adapter isKindOfClass:[AdPieNativeAdAdapter class]]) {
        if (error) {
            *error = MPNativeAdNSErrorForRenderValueTypeError();
        }
        return nil;
    }
    
    self.adapter = (AdPieNativeAdAdapter *) adapter;
    
    if ([self.renderingViewClass respondsToSelector:@selector(nibForAd)]) {
        self.adView = (UIView<MPNativeAdRendering> *)[[[self.renderingViewClass nibForAd]
                                                       instantiateWithOwner:nil
                                                       options:nil] firstObject];
    } else {
        self.adView = [[self.renderingViewClass alloc] init];
    }
    
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], nil);
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], nil);
    [self renderUnifiedAdViewWithAdapter:self.adapter];
    return self.adView;
}

- (void)renderUnifiedAdViewWithAdapter:(id<MPNativeAdAdapter>)adapter {
    
    if ([self.adView respondsToSelector:@selector(nativeTitleTextLabel)]) {
        self.adView.nativeTitleTextLabel.text = adapter.properties[kAdTitleKey];
    }
    
    if ([self.adView respondsToSelector:@selector(nativeMainTextLabel)]) {
        self.adView.nativeMainTextLabel.text = adapter.properties[kAdTextKey];
    }
    
    if ([self.adView respondsToSelector:@selector(nativeCallToActionTextLabel)] &&
        self.adView.nativeCallToActionTextLabel) {
        self.adView.nativeCallToActionTextLabel.text = adapter.properties[kAdCTATextKey];
    }
    
    if ([self.adView respondsToSelector:@selector(layoutStarRating:)]) {
        NSNumber *starRatingNum = adapter.properties[kAdStarRatingKey];
        if ([starRatingNum isKindOfClass:[NSNumber class]] &&
            starRatingNum.floatValue >= kStarRatingMinValue &&
            starRatingNum.floatValue <= kStarRatingMaxValue) {
            [self.adView layoutStarRating:starRatingNum];
        }
    }
}

- (BOOL)shouldLoadMediaView {
    return [self.adapter respondsToSelector:@selector(mainMediaView)] &&
    [self.adapter mainMediaView] &&
    [self.adView respondsToSelector:@selector(nativeVideoView)];
}

- (void)adViewWillMoveToSuperview:(UIView *)superview {
    self.adViewInViewHierarchy = (superview != nil);
    
    if (superview) {
        if (self.adapter.properties[kAdIconImageKey] &&
            [self.adView respondsToSelector:@selector(nativeIconImageView)]) {
            [self.rendererImageHandler
             loadImageForURL:[NSURL URLWithString:self.adapter.properties[kAdIconImageKey]]
             intoImageView:self.adView.nativeIconImageView];
        }
        
        if (!([self.adapter respondsToSelector:@selector(mainMediaView)] && [self.adapter mainMediaView])) {
            if ([self.adapter.properties objectForKey:kAdMainImageKey] && [self.adView respondsToSelector:@selector(nativeMainImageView)]) {
                [self.rendererImageHandler loadImageForURL:[NSURL URLWithString:[self.adapter.properties objectForKey:kAdMainImageKey]] intoImageView:self.adView.nativeMainImageView];
            }
        }
        
        if (self.adapter.properties[kAdPrivacyIconImageUrlKey] &&
            [self.adView respondsToSelector:@selector(nativePrivacyInformationIconImageView)]) {
            [self.rendererImageHandler
             loadImageForURL:[NSURL URLWithString:self.adapter.properties[kAdPrivacyIconImageUrlKey]]
             intoImageView:self.adView.nativePrivacyInformationIconImageView];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPrivacyIconTapped)];
            self.adView.nativePrivacyInformationIconImageView.userInteractionEnabled = YES;
            [self.adView.nativePrivacyInformationIconImageView addGestureRecognizer:tapRecognizer];
        }
        
        if ([self.adView respondsToSelector:@selector(layoutCustomAssetsWithProperties:imageLoader:)]) {
            MPNativeAdRenderingImageLoader *imageLoader =
            [[MPNativeAdRenderingImageLoader alloc] initWithImageHandler:self.rendererImageHandler];
            [self.adView layoutCustomAssetsWithProperties:self.adapter.properties
                                              imageLoader:imageLoader];
        }
    }
}
- (void)onPrivacyIconTapped {
    if(self.adapter.properties[kAdPrivacyIconClickUrlKey]){
        [[AdPieSDK sharedInstance] openURLwithString:self.adapter.properties[kAdPrivacyIconClickUrlKey]];
    }
}

#pragma mark - MPNativeAdRendererImageHandlerDelegate

- (BOOL)nativeAdViewInViewHierarchy
{
    return self.adViewInViewHierarchy;
}

@end
