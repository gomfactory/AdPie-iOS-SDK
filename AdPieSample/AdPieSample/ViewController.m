//
//  ViewController.m
//  AdPieSample
//
//  Created by sunny on 2016. 5. 27..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.sdkVersionLabel.text = [self.sdkVersionLabel.text stringByAppendingString:[AdPieSDK sdkVersion]];
    
    // Slot ID 입력 (Banner)
    self.adView.slotId = @"57342fdd7174ea39844cac15";
    // 광고뷰의 RootViewController 등록
    self.adView.rootViewController = self;
    // 델리게이트 등록 (Banner)
    self.adView.delegate = self;
    
    // 광고요청 (Banner)
    [self.adView load];
    
    // Slot ID 입력 (Interstitial)
    self.interstitial = [[APInterstitial alloc] initWithSlotId:@"573430057174ea39844cac16"];
    // 델리게이트 등록 (Interstitial)
    self.interstitial.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestInterstitialAd:(id)sender {
    // 광고 요청 (Interstitial)
    [self.interstitial load];
}

#pragma mark APAdView delegates

- (void)adViewDidLoadAd:(APAdView *)view {
    // 광고 표출 성공 후 이벤트 발생
}

- (void)adViewDidFailToLoadAd:(APAdView *)view withError:(NSError *)error {
    // 광고 요청 또는 표출 실패 후 이벤트 발생
    // error code : [error code]
    // error message : [error localizedDescription]
}

- (void)adViewWillLeaveApplication:(APAdView *)view {
    // 광고 클릭 후 이벤트 발생
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
}

- (void)interstitialWillDismissScreen:(APInterstitial *)interstitial {
    // 광고가 표출한 뒤 종료하기 전에 이벤트 발생
}

- (void)interstitialDidDismissScreen:(APInterstitial *)interstitial {
    // 광고가 표출한 뒤 종료한 후 이벤트 발생
}

- (void)interstitialWillLeaveApplication:(APInterstitial *)interstitial {
    // 광고 클릭 후 이벤트 발생
}
@end
