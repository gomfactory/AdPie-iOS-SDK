//
//  APAdView.h
//  AdPieSDK
//
//  Created by sunny on 2016. 2. 22..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APAdViewDelegate;

@interface APAdView : UIView

@property (weak) id<APAdViewDelegate> delegate;

@property (copy) NSString *slotId;

@property (weak) IBOutlet UIViewController *rootViewController;

- (void)setExtraParameterForKey:(NSString *)key value:(NSString *)value;

- (void)load;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol APAdViewDelegate <NSObject>

@required
// 성공 알림
- (void)adViewDidLoadAd:(APAdView *)view;
// 실패 알림
- (void)adViewDidFailToLoadAd:(APAdView *)view withError:(NSError *)error;

@optional
// 클릭 이후 앱이 백그라운드 상태로 전환
- (void)adViewWillLeaveApplication:(APAdView *)view;

@end
