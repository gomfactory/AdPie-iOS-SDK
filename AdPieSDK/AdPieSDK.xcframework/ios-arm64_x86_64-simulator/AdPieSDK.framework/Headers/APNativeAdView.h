//
//  APNativeAdView.h
//  AdPieSDK
//
//  Created by sunny on 2016. 8. 31..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "APMainAdView.h"
#import "APNativeAdData.h"
#import <UIKit/UIKit.h>

@protocol APNativeAdViewDelegate;

@interface APNativeAdView : UIView

@property (weak) IBOutlet UIImageView *iconImageView;
@property (weak) IBOutlet UILabel *titleLabel;
@property (weak) IBOutlet UILabel *descriptionLabel;
@property (weak) IBOutlet APMainAdView *mainAdView;
@property (weak) IBOutlet UIButton *callToActionButton;
@property (weak) IBOutlet UIImageView *optoutImageView;

@property (readonly) bool isValidLayout;

@property (weak) id<APNativeAdViewDelegate> delegate;

- (BOOL)fillAd:(APNativeAdData *)adData;

@end

@protocol APNativeAdViewDelegate <NSObject>

@optional
- (void)viewClicked;
@end
