//
//  ViewController.h
//  AdPieSample
//
//  Created by sunny on 2016. 5. 27..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdPieSDK/AdPieSDK.h>

@interface ViewController : UIViewController <APAdViewDelegate, APInterstitialDelegate>

@property (weak, nonatomic) IBOutlet APAdView *adView;

@property (nonatomic) APInterstitial *interstitial;

@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;

- (IBAction)requestInterstitialAd:(id)sender;

@end

