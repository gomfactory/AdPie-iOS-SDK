//
//  InterstitialAdViewController.h
//  AdPieSample
//
//  Created by sunny on 2016. 10. 17..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <AdPieSDK/AdPieSDK.h>
#import <UIKit/UIKit.h>

@interface InterstitialAdViewController : UIViewController

@property(strong, nonatomic) APInterstitial *interstitial;

- (IBAction)requestInterstitialAd:(id)sender;

@end
