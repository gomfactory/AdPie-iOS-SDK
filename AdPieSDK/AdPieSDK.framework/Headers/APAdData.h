//
//  APAdData.h
//  AdPieSDK
//
//  Created by sunny on 2016. 4. 1..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAdData : NSObject

@property (nonatomic, readonly, strong) NSDictionary *dictionary;

@property (nonatomic, readonly, assign) int icType;
@property (nonatomic, readonly, strong) NSString *adm;
@property (nonatomic, readonly, strong) NSString *admImageTag;
@property (nonatomic, readonly, assign) int width;
@property (nonatomic, readonly, assign) int height;
@property (nonatomic, readonly, strong) NSArray *impTrackers;
@property (nonatomic, readonly, strong) NSArray *clickTrackers;
@property (nonatomic, readonly, strong) NSString *bgColor;
@property (nonatomic, readonly, assign) BOOL isScalable;
@property (nonatomic, readonly, assign) int position;
@property (nonatomic, readonly, assign) int animationType;
@property (nonatomic, readonly, assign) int act;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)setImpTrackers:(NSArray *)impTrackers andClickTrackers:(NSArray *)clickTrackers;

@end
