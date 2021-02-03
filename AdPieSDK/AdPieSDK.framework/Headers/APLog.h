//
//  APLog.h
//  AdPieSDK
//
//  Created by sunny on 2016. 5. 3..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "AdPieSDK.h"
#import <Foundation/Foundation.h>

@interface APLog : NSObject

+ (void)debug:(NSString *)format, ...;
+ (void)setEnable:(BOOL)flag;
+ (void)setSDKLogEnable:(BOOL)flag;
+ (void)log:(NSString *)format, ...;

@end
