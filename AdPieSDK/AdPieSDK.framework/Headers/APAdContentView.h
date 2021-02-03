//
//  APAdContentView.h
//  AdPieSDK
//
//  Created by sunny on 2016. 4. 4..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "APAdData.h"
#import <UIKit/UIKit.h>

@interface APAdContentView : UIView

- (void)interstitialData:(APAdData *)adData delegate:(id)delegate;
- (void)bannerData:(APAdData *)adData delegate:(id)delegate;
- (void)showContent;
- (void)stop;

@end

@protocol APAdContentViewDelegate <NSObject>

@optional
- (void)viewLoaded:(APAdContentView *)adContentView;
- (void)viewFailedToLoad:(APAdContentView *)adContentView
               withError:(NSError *)error;
- (void)viewClicked;
@end
