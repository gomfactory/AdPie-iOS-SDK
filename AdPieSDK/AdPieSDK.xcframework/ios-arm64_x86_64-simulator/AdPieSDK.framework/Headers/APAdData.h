//
//  APAdData.h
//  AdPieSDK
//
//  Created by sunny on 2016. 4. 1..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAdData : NSObject

@property (readonly, strong) NSDictionary *dictionary;

@property (readonly, assign) int icType;
@property (readonly, strong) NSString *adm;
@property (readonly, strong) NSString *admImageTag;
@property (readonly, assign) int width;
@property (readonly, assign) int height;
@property (readonly, strong) NSArray *impTrackers;
@property (readonly, strong) NSArray *clickTrackers;
@property (readonly, strong) NSString *bgColor;
@property (readonly, assign) BOOL isScalable;
@property (readonly, assign) int position;
@property (readonly, assign) int animationType;
@property (readonly, assign) int act;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)setImpTrackers:(NSArray *)impTrackers andClickTrackers:(NSArray *)clickTrackers;

@end
