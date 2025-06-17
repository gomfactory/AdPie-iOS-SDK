//
//  AdPieSDK.h
//  AdPieSDK
//
//  Created by sunny on 2016. 2. 22..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

// Header files.
#import <AdPieSDK/APAdView.h>
#import <AdPieSDK/APInterstitial.h>
#import <AdPieSDK/APNativeAd.h>
#import <AdPieSDK/APNativeAdView.h>
#import <AdPieSDK/APRewardedAd.h>
#import <AdPieSDK/APTargetingData.h>

#define ADPIE_SDK_VERSION @"1.6.8"

typedef void (^ResultBlock)(BOOL isInitialized);

@interface AdPieSDK : NSObject

@property (copy) NSString *mediaId;
@property (readonly) BOOL isInitialized;
@property BOOL isOneOfMediation;

+ (instancetype)sharedInstance;

+ (NSString *)sdkVersion;

- (void)initWithMediaId:(NSString *)mediaId;
- (void)initWithMediaId:(NSString *)mediaId withData:(NSData *)data;
- (void)initWithMediaId:(NSString *)mediaId completion:(ResultBlock)result;
- (void)logging;
- (void)openURLwithString:(NSString *)url;

@end
