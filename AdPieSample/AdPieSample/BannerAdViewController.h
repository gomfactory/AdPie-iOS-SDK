//
//  BannerAdViewController.h
//  AdPieSample
//
//  Created by sunny on 2016. 10. 17..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <AdPieSDK/AdPieSDK.h>
#import <UIKit/UIKit.h>

@interface BannerAdViewController : UIViewController

@property(weak, nonatomic) IBOutlet APAdView *adView;

@property (weak, nonatomic) IBOutlet UILabel *adViewResultLabel;

@end
