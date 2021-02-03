//
//  APNetwork.h
//  AdPieSDK
//
//  Created by sunny on 2016. 3. 3..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "APConstants.h"
#import <Foundation/Foundation.h>

typedef void (^ResponseBlock)(NSData *data, NSError *error);

typedef NS_ENUM(NSInteger, ADPIE_HTTP_METHOD) {
    ADPIE_HTTP_GET_METHOD = 1,
    ADPIE_HTTP_POST_METHOD = 2
};

@interface APNetwork : NSObject
// GET
- (void)startRequest:(NSURL *)url completion:(ResponseBlock)responseBlock;
// GET or POST
- (void)startRequest:(NSURL *)url
            withData:(NSDictionary *)bodyData
              method:(ADPIE_HTTP_METHOD)method
          completion:(ResponseBlock)responseBlock;
- (NSString *)queryString:(NSDictionary *)data;
- (NSString *)formatURLRequest:(NSURLRequest *)request;
- (NSString *)formatURLResponse:(NSURLResponse *)response
                       withData:(NSData *)data;
@end