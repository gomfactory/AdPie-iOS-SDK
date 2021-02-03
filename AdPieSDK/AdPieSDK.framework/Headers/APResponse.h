//
//  APResponse.h
//  AdPieSDK
//
//  Created by sunny on 2016. 4. 1..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "APAdData.h"
#import <Foundation/Foundation.h>

@interface APResponse : NSObject

@property(nonatomic, readonly, assign) int result;
@property(nonatomic, readonly, copy) NSString *message;

@property(nonatomic, readonly, assign) long interval;
@property(nonatomic, readonly, assign) long limit;
@property(nonatomic, readonly, assign) int count;

@property(nonatomic, readonly, copy) APAdData *adData;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
