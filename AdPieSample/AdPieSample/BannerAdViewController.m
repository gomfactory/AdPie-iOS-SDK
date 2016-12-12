//
//  BannerAdViewController.m
//  AdPieSample
//
//  Created by sunny on 2016. 10. 17..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "BannerAdViewController.h"

@interface BannerAdViewController () <APAdViewDelegate>

@end

@implementation BannerAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adViewResultLabel.numberOfLines = 5;
    
    // Slot ID 입력
    self.adView.slotId = @"57342fdd7174ea39844cac15";
    // 광고뷰의 RootViewController 등록 (Refresh를 위해 필요)
    self.adView.rootViewController = self;
    // 델리게이트 등록
    self.adView.delegate = self;
    
    // 광고 요청
    [self.adView load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark APAdView delegates

- (void)adViewDidLoadAd:(APAdView *)view {
    // 광고 표출 성공 후 이벤트 발생
    
    self.adViewResultLabel.text = [NSString stringWithFormat:@"Ad View Result : %@ (date : %@)", @"Success", [[NSDate date] descriptionWithLocale:[NSLocale systemLocale]]];
}

- (void)adViewDidFailToLoadAd:(APAdView *)view withError:(NSError *)error {
    // 광고 요청 또는 표출 실패 후 이벤트 발생
    // error code : [error code]
    // error message : [error localizedDescription]
    
    self.adViewResultLabel.text = [NSString stringWithFormat:@"Ad View Result : Error (code : %d, message : %@, date : %@)", (int)[error code], [error localizedDescription], [[NSDate date] descriptionWithLocale:[NSLocale systemLocale]]];
}

- (void)adViewWillLeaveApplication:(APAdView *)view {
    // 광고 클릭 후 이벤트 발생
}

@end
