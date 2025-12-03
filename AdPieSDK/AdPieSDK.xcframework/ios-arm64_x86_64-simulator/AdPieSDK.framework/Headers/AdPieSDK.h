//
//  AdPieSDK.h
//  AdPieSDK
//
//  Created by sunny on 2016. 2. 22..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APAdView.h"
#import "APNativeAd.h"
#import "APInterstitial.h"
#import "APRewardedAd.h"
#import "APTargetingData.h"

typedef void (^ResultBlock)(BOOL isInitialized);

@interface AdPieSDK : NSObject

@property (copy) NSString *mediaId;
@property (readonly) BOOL isInitialized;
@property BOOL isOneOfMediation;

+ (instancetype)sharedInstance;

+ (NSString *)sdkVersion;

- (void)initWithMediaId:(NSString *)mediaId;

- (void)initWithMediaId:(NSString *)mediaId
               withData:(NSData *)data;

- (void)initWithMediaId:(NSString *)mediaId
               withData:(NSData *)data
             completion:(ResultBlock)completion;

- (void)initWithMediaId:(NSString *)mediaId completion:(ResultBlock)result;

- (void)logging;
- (void)openURLwithString:(NSString *)url;

@end
