//
//  AdController.h
//  AdPieSDK
//
//  Created by sunny on 2016. 2. 22..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "APResponse.h"
#import <Foundation/Foundation.h>

@protocol APAdControllerDelegate;

@interface APAdController : NSObject

@property (nonatomic) id<APAdControllerDelegate> delegate;

- (void)load:(NSString *)slotId transport:(BOOL)isSecure retry:(BOOL)isRetry;
- (void)stop;

@end

@protocol APAdControllerDelegate <NSObject>

@optional

// 데이터 수신 알림
- (void)receivedResponse:(APResponse *)response;
// 실패 알림
- (void)receivedError:(NSError *)error;
@end
