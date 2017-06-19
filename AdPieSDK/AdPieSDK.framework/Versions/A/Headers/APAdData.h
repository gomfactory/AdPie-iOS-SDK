//
//  APAdData.h
//  AdPieSDK
//
//  Created by sunny on 2016. 4. 1..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAdData : NSObject

@property(nonatomic, readonly, copy) NSDictionary *dictionary;

@property (nonatomic, assign, readonly) int icType;
@property (nonatomic, strong, readonly) NSString *adm;
@property (nonatomic, strong, readonly) NSString *admImageTag;
@property (nonatomic, assign, readonly) int width;
@property (nonatomic, assign, readonly) int height;

@property (nonatomic, strong, readonly) NSString *impUrl;
@property (nonatomic, strong, readonly) NSString *clkUrl;

@property (nonatomic, strong, readonly) NSString *bgColor;

@property (nonatomic, assign, readonly) BOOL isScalable;
@property (nonatomic, assign, readonly) int position;
@property (nonatomic, assign, readonly) int animationType;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
