#import "UIViewController+Toast.h"

@implementation UIViewController (Toast)

- (UIViewController * _Nullable)topMostViewController {
    UIWindowScene *activeScene = nil;
    
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                activeScene = (UIWindowScene *)scene;
                break;
            }
        }
    }
    
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindow *window in activeScene.windows) {
            if (window.isKeyWindow) {
                keyWindow = window;
                break;
            }
        }
    } else {
        keyWindow = UIApplication.sharedApplication.keyWindow;
    }
    
    if (!keyWindow) {
        return nil;
    }
    
    UIViewController *topController = keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (void)showToastWithMessage:(NSString *)message {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    containerView.layer.cornerRadius = 16.0;
    containerView.clipsToBounds = YES;
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    containerView.alpha = 0.0;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    label.text = message;
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [containerView addSubview:label];
    
    UIViewController *topVC = [self topMostViewController];
    UIView *targetView = topVC ? topVC.view : self.view;
    
    if (!targetView) {
        return;
    }
    
    [targetView addSubview:containerView];
    
    [NSLayoutConstraint activateConstraints:@[
        [containerView.centerXAnchor constraintEqualToAnchor:targetView.centerXAnchor],
        [containerView.bottomAnchor constraintEqualToAnchor:targetView.safeAreaLayoutGuide.bottomAnchor constant:-100],
        [containerView.leadingAnchor constraintGreaterThanOrEqualToAnchor:targetView.leadingAnchor constant:20],
        [containerView.trailingAnchor constraintLessThanOrEqualToAnchor:targetView.trailingAnchor constant:-20],
        
        [label.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:10],
        [label.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-10],
        [label.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:16],
        [label.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-16]
    ]];
    
    [UIView animateWithDuration:0.3 animations:^{
        containerView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            containerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [containerView removeFromSuperview];
        }];
    }];
}

@end
