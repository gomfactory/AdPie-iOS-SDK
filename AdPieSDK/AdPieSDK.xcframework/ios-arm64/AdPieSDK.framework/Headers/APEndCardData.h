
#import <Foundation/Foundation.h>

@interface APEndCardData : NSObject

@property (assign) NSInteger width;
@property (assign) NSInteger height;
@property (strong) NSString * staticResource;
@property (strong) NSString * htmlResource;
@property (strong) NSString * iframeResource;
@property (strong) NSString * clickThrough;
@property (strong) NSArray<NSString *> * clickTracking;
@property (strong) NSArray<NSString *> * creativeView;

- (APEndCardData * )initWithDictionary:(NSDictionary *)dict;

@end
