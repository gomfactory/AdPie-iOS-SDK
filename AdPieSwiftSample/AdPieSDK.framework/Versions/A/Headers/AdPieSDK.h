//
//  AdPieSDK.h
//  AdPieSDK
//
//  Created by KimYongSun on 2016. 2. 22..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

// Header files.
#import <AdPieSDK/APAdView.h>
#import <AdPieSDK/APInterstitial.h>
#import <AdPieSDK/APTargetingData.h>

#define ADPIE_SDK_VERSION @"1.0.3"

@interface AdPieSDK : NSObject

@property(nonatomic, copy) NSString *mediaId;
@property(nonatomic, readonly) BOOL isInitialized;

+ (instancetype)sharedInstance;

+ (NSString *)sdkVersion;

- (void)initWithMediaId:(NSString *)mediaId;
- (void)initWithMediaId:(NSString *)mediaId withData:(NSData *)data;
- (void)logging;

@end
