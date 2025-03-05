//
//  APVideoAdData.h
//  AdPieSDK
//
//  Created by sunny on 2022/01/12.
//

#import "APAdData.h"
#import "APEndCardData.h"
#import <Foundation/Foundation.h>

@interface APVideoAdData : APAdData

@property (readonly, copy) NSString *title;
@property (readonly, copy) NSString *desc;
@property (readonly, copy) NSString *optoutImageURL;
@property (readonly, copy) NSString *optoutLinkURL;
@property (readonly, assign) int skipOffset;
@property (readonly, assign) int autoplay;
@property (readonly, assign) int duration;
@property (readonly, copy) NSString *link;
@property (readonly, copy) NSString *linkText;
@property (readonly, copy) NSString *content;
@property (readonly, copy) NSString *contentType;
@property (readonly, assign) int delivery;
@property (readonly, assign) int contentWidth;
@property (readonly, assign) int contentHeight;

@property (readonly, strong) NSArray *trackingStartUrls;
@property (readonly, strong) NSArray *trackingFirstQuartileUrls;
@property (readonly, strong) NSArray *trackingMidpointUrls;
@property (readonly, strong) NSArray *trackingThirdQuartileUrls;
@property (readonly, strong) NSArray *trackingCompleteUrls;

@property (readonly, copy) NSString *ssvURL;
@property (copy) NSString *ssvUserId;
@property (copy) NSString *ssvCustomData;

@property (readonly, strong) APEndCardData * endCard;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


