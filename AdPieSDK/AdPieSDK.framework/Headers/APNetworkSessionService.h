//
//  APNetworkSessionService.h
//  /
//
//  Created by sunny on 2016. 3. 3..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "APNetwork.h"
#import <Foundation/Foundation.h>

@interface APNetworkSessionService : APNetwork
// GET
- (void)startRequest:(NSURL *)url completion:(ResponseBlock)responseBlock;
// GET or POST
- (void)startRequest:(NSURL *)url
            withData:(NSDictionary *)bodyData
              method:(ADPIE_HTTP_METHOD)method
          completion:(ResponseBlock)responseBlock;
@end
