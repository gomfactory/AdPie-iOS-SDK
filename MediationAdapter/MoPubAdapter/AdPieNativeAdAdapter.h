//
//  AdPieNativeAdAdapter.h
//  AdPieSDK
//
//  Created by sunny on 19/03/2019.
//  Copyright © 2019 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#else
#import "MPNativeAdAdapter.h"
#endif

#import <AdPieSDK/AdPieSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdPieNativeAdAdapter : NSObject <MPNativeAdAdapter>

@property (nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;

- (instancetype)initWithAdPieAdNative:(APNativeAd *)ad;

@end

NS_ASSUME_NONNULL_END
