#import <Foundation/Foundation.h>
#import <AdPieSDK/APAdData.h>

#import "AdPieAdData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdPieNativeAdData : AdPieAdData

@property (readonly, copy) NSString *link;
@property (readonly, copy) NSString *optoutLink;

@end

NS_ASSUME_NONNULL_END

