#import "AdMenuItem.h"

@implementation AdMenuItem
+ (instancetype)itemWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  actionBlock:(AdMenuItemActionBlock)actionBlock
{
    AdMenuItem *item = [[AdMenuItem alloc] init];
    item.title = title;
    item.subtitle = subtitle;
    item.actionBlock = actionBlock;
    return item;
}
@end
