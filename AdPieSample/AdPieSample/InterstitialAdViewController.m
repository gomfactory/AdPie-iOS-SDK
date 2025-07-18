//
//  InterstitialAdViewController.m
//  AdPieSample
//
//  Created by sunny on 2016. 10. 17..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "InterstitialAdViewController.h"

@interface InterstitialAdViewController () <APInterstitialDelegate>

@end

@implementation InterstitialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Slot ID 입력
    self.interstitial = [[APInterstitial alloc] initWithSlotId:@"573430057174ea39844cac16"];
    // 델리게이트 등록
    self.interstitial.delegate = self;
    
    if (@available(iOS 13, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    }
}

- (IBAction)requestInterstitialAd:(id)sender {
    // 광고 요청
    [self.interstitial load];
}

#pragma mark APInterstitial delegates

- (void)interstitialDidLoadAd:(APInterstitial *)interstitial {
    // 광고 로딩 완료 후 이벤트 발생
    
    // 광고 요청 후 즉시 노출하고자 할 경우 아래의 코드를 추가한다.
    if ([self.interstitial isReady]) {
        // 광고 표출
        [self.interstitial presentFromRootViewController:self];
    }
}

- (void)interstitialDidFailToLoadAd:(APInterstitial *)interstitial withError:(NSError *)error {
    // 광고 요청 또는 표출 실패 후 이벤트 발생
    // error code : [error code]
    // error message : [error localizedDescription]
    
    NSString *title = @"Error";
    NSString *message = [NSString stringWithFormat:@"Failed to load interstitial ads. \n (code : %d, message : %@)", (int)[error code], [error localizedDescription]];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
    }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

- (void)interstitialWillPresentScreen:(APInterstitial *)interstitial {
    // 광고 표출 후 이벤트 발생
    NSLog(@"%s", __func__);
}

- (void)interstitialWillDismissScreen:(APInterstitial *)interstitial {
    // 광고가 표출한 뒤 종료하기 전에 이벤트 발생
    NSLog(@"%s", __func__);
}

- (void)interstitialDidDismissScreen:(APInterstitial *)interstitial {
    // 광고가 표출한 뒤 종료한 후 이벤트 발생
    NSLog(@"%s", __func__);
}

- (void)interstitialWillLeaveApplication:(APInterstitial *)interstitial {
    // 광고 클릭 후 이벤트 발생
    NSLog(@"%s", __func__);
}

- (void)videoFinished:(APVideoFinishState)finishState {
    // 동영상 광고 종료 알림
    NSLog(@"%s", __func__);
}

@end
