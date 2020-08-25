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

@property(nonatomic, readonly, copy) NSString *title;
@property(nonatomic, readonly, copy) NSString *desc;
@property(nonatomic, readonly, copy) NSString *iconImageUrl;
@property(nonatomic, readonly, copy) NSString *mainImageUrl;
@property(nonatomic, readonly, assign) int mainWidth;
@property(nonatomic, readonly, assign) int mainHeight;
@property(nonatomic, readonly, copy) NSString *callToAction;
@property(nonatomic, readonly, assign) double rating;
@property(nonatomic, readonly, copy) NSString *sponsored;

@property(nonatomic, readonly, copy) NSString *link;

@property(nonatomic, readonly, copy) NSArray *assetType;

@property(nonatomic, readonly, copy) NSString *optoutImageUrl;
@property(nonatomic, readonly, copy) NSString *optoutLink;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
