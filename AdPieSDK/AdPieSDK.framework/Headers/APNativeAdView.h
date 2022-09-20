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

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet APMainAdView *mainAdView;
@property (nonatomic, weak) IBOutlet UIButton *callToActionButton;

@property (nonatomic, readonly) bool isValidLayout;

@property (nonatomic, weak) id<APNativeAdViewDelegate> delegate;

- (BOOL)fillAd:(APNativeAdData *)adData;

@end

@protocol APNativeAdViewDelegate <NSObject>

@optional
- (void)viewClicked;
@end
