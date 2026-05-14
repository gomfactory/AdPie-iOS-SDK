#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIViewController * _Nullable (^AdMenuItemActionBlock)(void);

@interface AdMenuItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, copy, nullable) AdMenuItemActionBlock actionBlock;

+ (instancetype)itemWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  actionBlock:(nullable AdMenuItemActionBlock)actionBlock;

@end

NS_ASSUME_NONNULL_END
