//
//  RewardedAdViewController.m
//  AdPieObjCApp
//
//  Created by sunny on 2022/01/11.
//  Copyright © 2022 GomFactory. All rights reserved.
//

#import "RewardedAdViewController.h"

@interface RewardedAdViewController () <APRewardedAdDelegate>

@end

@implementation RewardedAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rewardedAd = [[APRewardedAd alloc] initWithSlotId:@"61de726d65a17f71c7896827"];
    self.rewardedAd.delegate = self;
    
    if (@available(iOS 13, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    }
}

- (IBAction)requestRewardedAd:(id)sender {
    // 리워드광고 요청
    [self.rewardedAd load];
}

#pragma mark APRewardedAd delegates

- (void)rewardedAdDidLoadAd:(APRewardedAd *)rewardedAd {
    // 리워드광고 성공
    NSLog(@"%s", __func__);

    if ([self.rewardedAd isReady]) {
        [self.rewardedAd presentFromRootViewController:self];
    }
}

- (void)rewardedAdDidFailToLoadAd:(APRewardedAd *)rewardedAd
                          withError:(NSError *)error {
    // 리워드광고 실패
    NSLog(@"%s code : %d, message : %@", __func__, (int)[error code],
          [error localizedDescription]);

    NSString *title = @"Error";
    NSString *message = [NSString
        stringWithFormat:
            @"Failed to load reawarded ads. \n (code : %d, message : %@)",
            (int)[error code], [error localizedDescription]];

    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:title
                         message:message
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){

                                   // do something when click button
                               }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate]
        window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

- (void)rewardedAdWillPresentScreen:(APRewardedAd *)rewardedAd {
    // 리워드광고 표출 알림
    NSLog(@"%s", __func__);
}

- (void)rewardedAdWillDismissScreen:(APRewardedAd *)rewardedAd {
    // 리워드광고 종료 예정 알림
    NSLog(@"%s", __func__);
}

- (void)rewardedAdDidDismissScreen:(APRewardedAd *)rewardedAd {
    // 리워드광고 종료 완료 알림
    NSLog(@"%s", __func__);
}

- (void)rewardedAdDidEarnReward:(APRewardedAd *)rewardedAd {
    // 리워드광고 보상 알림
    NSLog(@"%s", __func__);
}

- (void)rewardedAdWillLeaveApplication:(APRewardedAd *)rewardedAd {
    // 리워드광고 클릭 알림
    NSLog(@"%s", __func__);
}

- (void)rewardedVideoFinished:(APRewardedAd *)rewardedAd videoFinishState:(APVideoFinishState)finishState {
    // 동영상 광고 종료 알림
    NSLog(@"%s", __func__);
}

@end
