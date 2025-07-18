//
//  APRewaredAd.h
//  AdPieSDK
//
//  Created by sunny on 2022/01/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APVideoAdData.h"

@protocol APRewardedAdDelegate;

@interface APRewardedAd : NSObject

@property(weak) id<APRewardedAdDelegate> delegate;

@property(copy) NSString *slotId;

- (id)initWithSlotId:(NSString *)slotId;

- (void)setExtraParameterForKey:(NSString *)key value:(NSString *)value;

- (void)load;

- (void)presentFromRootViewController:(UIViewController *)controller;

- (BOOL)isReady;

- (void)setUserIdForSSV:(NSString *)userId NS_SWIFT_NAME(setUserIdForSSV(userId:));

- (void)setCustomDataForSSV:(NSString *)customData NS_SWIFT_NAME(setCustomDataForSSV(customData:));

@end

@protocol APRewardedAdDelegate <NSObject>

@required

// 리워드 성공
- (void)rewardedAdDidLoadAd:(APRewardedAd *)rewardedAd;
// 리워드 실패
- (void)rewardedAdDidFailToLoadAd:(APRewardedAd *)rewardedAd
                          withError:(NSError *)error;

@optional
// 리워드 표출 알림
- (void)rewardedAdWillPresentScreen:(APRewardedAd *)rewardedAd;
// 리워드 종료 예정 알림
- (void)rewardedAdWillDismissScreen:(APRewardedAd *)rewardedAd;
// 리워드 종료 완료 알림
- (void)rewardedAdDidDismissScreen:(APRewardedAd *)rewardedAd;
// 리워드 클릭 알림
- (void)rewardedAdWillLeaveApplication:(APRewardedAd *)rewardedAd;
// 리워드 보상 알림
- (void)rewardedAdDidEarnReward:(APRewardedAd *)rewardedAd;
// 동영상 광고 종료 알림
- (void)rewardedVideoFinished:(APVideoFinishState)finishState;
@end
