//
//  RewardedAdViewController.h
//  AdPieObjCApp
//
//  Created by sunny on 2022/01/11.
//  Copyright © 2022 GomFactory. All rights reserved.
//

#import <AdPieSDK/AdPieSDK.h>
#import <UIKit/UIKit.h>

@interface RewardedAdViewController : UIViewController

@property(strong, nonatomic) APRewardedAd *rewardedAd;

- (IBAction)requestRewardedAd:(id)sender;

@end
