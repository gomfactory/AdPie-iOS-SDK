//
//  APInterstitialViewController.h
//  AdPieSDK
//
//  Created by sunny on 2016. 4. 5..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "APAdData.h"
#import "APInterstitial.h"
#import <UIKit/UIKit.h>

typedef void (^PreloadHandler)(BOOL result);

@interface APInterstitialViewController : UIViewController

@property(nonatomic) APInterstitial *interstitial;

- (id)initWithData:(APAdData *)adData interstitial:interstitial;
- (void)preload:(PreloadHandler)handler;
- (void)show;
- (void)close;
@end
