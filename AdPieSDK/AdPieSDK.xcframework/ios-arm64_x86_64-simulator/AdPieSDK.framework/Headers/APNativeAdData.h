//
//  APNativeAdData.h
//  AdPieSDK
//
//  Created by sunny on 2016. 9. 26..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "APAdData.h"
#import <Foundation/Foundation.h>

@interface APNativeAdData : APAdData

typedef enum
{
    NATIVE_ASSET_TITLE = 1,
    NATIVE_ASSET_ICON = 2,
    NATIVE_ASSET_MAIN = 3,
    NATIVE_ASSET_DESC = 4,
    NATIVE_ASSET_RATING = 5,
    NATIVE_ASSET_CTA = 6
} kNativeAssetType;

@property (readonly, copy) NSString *title;
@property (readonly, copy) NSString *desc;
@property (readonly, copy) NSString *iconImageUrl;
@property (readonly, copy) NSString *mainImageUrl;
@property (readonly, assign) int mainWidth;
@property (readonly, assign) int mainHeight;
@property (readonly, copy) NSString *callToAction;
@property (readonly, assign) double rating;
@property (readonly, copy) NSString *sponsored;
@property (readonly, copy) NSString *link;
@property (readonly, strong) NSArray *assetType;
@property (readonly, copy) NSString *optoutImageUrl;
@property (readonly, copy) NSString *optoutLink;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
