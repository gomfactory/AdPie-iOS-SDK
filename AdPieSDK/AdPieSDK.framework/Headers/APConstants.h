//
//  APConstants.h
//  AdPieSDK
//
//  Created by sunny on 2016. 3. 3..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNetworkErrorArray                                                     \
    [NSArray arrayWithObjects:[NSNumber numberWithLong:20000],                 \
                              [NSNumber numberWithLong:40000],                 \
                              [NSNumber numberWithLong:90000],                 \
                              [NSNumber numberWithLong:150000], nil]

extern NSTimeInterval const kAdPieTimeoutIntervalForRequest;
extern NSTimeInterval const kAdPieTimeoutIntervalForResource;
extern NSTimeInterval const kAdPieRequestTimeoutInterval;

#define kBannerImageAdType 11
#define kInterstitialImageAdType 21
#define kInterstitialIVideoAdType 22
#define kNativeImageAdType 31
#define kNativeVideoAdType 32
#define kPrerollVideoAdType 42

#define kConnectionTypeNo 0
#define kConnectionTypeEthernet 1 // 사용안함
#define kConnectionTypeWifi 2
#define kConnectionTypeMobile 3
#define kConnectionTypeMobile2G 4
#define kConnectionTypeMobile3G 5
#define kConnectionTypeMobile4G 6

#define kRequestMinimumInterval 10000  // 최소 10초
#define kRequestMaximumInterval 300000 // 최대 5분

#define kRequestLimitInterval 3000 // 3초
