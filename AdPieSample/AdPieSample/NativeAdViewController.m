//
//  NativeAdViewController.m
//  AdPieSample
//
//  Created by sunny on 2016. 10. 17..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "NativeAdViewController.h"

@interface NativeAdViewController () <APNativeDelegate>

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nativeAd = [[APNativeAd alloc] initWithSlotId:@"580491a37174ea5279c5d09b"];
    // 델리게이트 등록
    self.nativeAd.delegate = self;
    
    // 광고 요청
    [self.nativeAd load];
    
    if (@available(iOS 13, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark APNativeAd delegates

- (void)nativeDidLoadAd:(APNativeAd *)nativeAd {
    // 네이티브 성공
    NSLog(@"%s", __func__);
    
    APNativeAdView *nativeAdView = [[[NSBundle mainBundle] loadNibNamed:@"AdPieNativeAdView"
                                                       owner:nil
                                                     options:nil] firstObject];
    
    [self.view addSubview:nativeAdView];
    nativeAdView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [nativeAdView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [nativeAdView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [nativeAdView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [nativeAdView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];

    if ([nativeAdView fillAd:nativeAd.nativeAdData]) {
      // 클릭 이벤트를 받기 위해 등록
      [nativeAd registerViewForInteraction:nativeAdView];
    }else{
        [nativeAdView removeFromSuperview];
        
        NSString *message = @"Failed to fill native ads data. Check your xib file.";
        
        [self alertMessage:message];
    }
}

- (void)nativeDidFailToLoadAd:(APNativeAd *)nativeAd
                          withError:(NSError *)error {
    // 광고 요청 실패 후 이벤트 발생
    NSString *message = [NSString
                         stringWithFormat:
                         @"Failed to load native ads. \n (code : %d, message : %@)",
                         (int)[error code], [error localizedDescription]];
    
    [self alertMessage:message];
}

- (void)nativeWillLeaveApplication:(APNativeAd *)nativeAd {
    // 광고 클릭 후 이벤트 발생
}

- (void) alertMessage:(NSString *)message{
    NSString *title = @"Error";
    
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

@end
