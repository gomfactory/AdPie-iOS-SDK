//
//  AdPieConfig.m
//  AdPieSDK
//
//  Created by sunny on 19/03/2019.
//  Copyright © 2019 GomFactory. All rights reserved.
//

#import "AdPieConfig.h"

@implementation AdPieConfig

+ (void)initialize:(NSString *)mediaId
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AdPieSDK sharedInstance] initWithMediaId:mediaId];
    });
}

@end
