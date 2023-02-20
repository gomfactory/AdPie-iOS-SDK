//
//  APInterstitial.h
//  AdPieSDK
//
//  Created by sunny on 2016. 3. 2..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol APInterstitialDelegate;

@interface APInterstitial : NSObject

@property(weak) id<APInterstitialDelegate> delegate;

@property(copy) NSString *slotId;

- (id)initWithSlotId:(NSString *)slotId;

- (void)setExtraParameterForKey:(NSString *)key value:(NSString *)value;

- (void)load;

- (void)presentFromRootViewController:(UIViewController *)controller;

- (BOOL)isReady;

@end

@protocol APInterstitialDelegate <NSObject>

@required

// 전면배너 성공
- (void)interstitialDidLoadAd:(APInterstitial *)interstitial;
// 전면배너 실패
- (void)interstitialDidFailToLoadAd:(APInterstitial *)interstitial
                          withError:(NSError *)error;

@optional
// 전면배너 표출 알림
- (void)interstitialWillPresentScreen:(APInterstitial *)interstitial;
// 전면배너 종료 예정 알림
- (void)interstitialWillDismissScreen:(APInterstitial *)interstitial;
// 전면배너 종료 완료 알림
- (void)interstitialDidDismissScreen:(APInterstitial *)interstitial;
// 전면배너 클릭 알림
- (void)interstitialWillLeaveApplication:(APInterstitial *)interstitial;

@end
