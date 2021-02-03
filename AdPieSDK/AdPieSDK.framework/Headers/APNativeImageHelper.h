//
//  APNativeImageHelper.h
//  AdPieSDK
//
//  Created by sunny on 2017. 11. 7..
//  Copyright © 2017년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APNativeAdData.h"

typedef void(^CompletionBlock)(BOOL isLoaded);

@interface APNativeImageHelper : NSObject

- (void)downloadResource:(APNativeAdData *)adData completion:(CompletionBlock) completionBlock;

@end
