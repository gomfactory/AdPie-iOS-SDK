//
//  AdPieNativeAdRenderer.h
//  AdPieSDK
//
//  Created by sunny on 19/03/2019.
//  Copyright © 2019 GomFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#else
#import "MPNativeAdRenderer.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface AdPieNativeAdRenderer : NSObject <MPNativeAdRenderer>

@property (nonatomic, readonly) MPNativeViewSizeHandler viewSizeHandler;

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings;

@end

NS_ASSUME_NONNULL_END
