//
//  APVideoAdData.h
//  AdPieSDK
//
//  Created by sunny on 2022/01/12.
//

#import "APAdData.h"
#import <Foundation/Foundation.h>

@interface APVideoAdData : APAdData

@property(nonatomic, readonly, copy) NSString *title;
@property(nonatomic, readonly, copy) NSString *desc;
@property(nonatomic, readonly, assign) int skipOffset;
@property(nonatomic, readonly, assign) int autoplay;
@property(nonatomic, readonly, assign) int duration;
@property(nonatomic, readonly, copy) NSString *link;
@property(nonatomic, readonly, copy) NSString *linkText;
@property(nonatomic, readonly, copy) NSString *content;
@property(nonatomic, readonly, copy) NSString *contentType;
@property(nonatomic, readonly, assign) int delivery;
@property(nonatomic, readonly, assign) int contentWidth;
@property(nonatomic, readonly, assign) int contentHeight;

@property(nonatomic, readonly, copy) NSArray *trackingStartUrls;
@property(nonatomic, readonly, copy) NSArray *trackingFirstQuartileUrls;
@property(nonatomic, readonly, copy) NSArray *trackingMidpointUrls;
@property(nonatomic, readonly, copy) NSArray *trackingThirdQuartileUrls;
@property(nonatomic, readonly, copy) NSArray *trackingCompleteUrls;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

