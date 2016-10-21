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

@property(weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property(weak, nonatomic) IBOutlet APMainAdView *mainAdView;
//@property(weak, nonatomic) IBOutlet UIButton *ctaButton;

@property(nonatomic, readonly) bool isValidLayout;

@property(nonatomic) IBOutlet NSLayoutConstraint *mainAdViewAspectRatioConstraint;

@property(weak, nonatomic) id<APNativeAdViewDelegate> delegate;

- (void)fillAd:(APNativeAdData *)adData;

@end

@protocol APNativeAdViewDelegate <NSObject>

@optional
- (void)viewClicked;
@end
