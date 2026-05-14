#import "AppDelegate.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdPieSDK/AdPieSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self requestTrackingPermission:^(BOOL granted) {
        [self initializeAdPieSDK];
    }];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)initializeAdPieSDK {
   if ([[AdPieSDK sharedInstance] isInitialized]) { return; }
   [[AdPieSDK sharedInstance] logging];
   [[AdPieSDK sharedInstance] initWithMediaId:@"57342d787174ea39844cac11"];
}

- (void)requestTrackingPermission:(void (^)(BOOL granted))completion {
   if (@available(iOS 14, *)) { } else {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (completion) completion(YES);
       });
       return;
   }

   ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
   if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (completion) completion(YES);
       });
       return;
   } else if (status == ATTrackingManagerAuthorizationStatusDenied ||
              status == ATTrackingManagerAuthorizationStatusRestricted) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (completion) completion(NO);
       });
       return;
   }

   void (^requestBlock)(void) = ^{
       [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
           dispatch_async(dispatch_get_main_queue(), ^{
               if (completion) completion(status == ATTrackingManagerAuthorizationStatusAuthorized);
           });
       }];
   };

   if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
       requestBlock();
       return;
   }

   __block id observer = nil;
   observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                                object:nil
                                                                 queue:[NSOperationQueue mainQueue]
                                                            usingBlock:^(NSNotification * _Nonnull note) {
       if (observer) {
           [[NSNotificationCenter defaultCenter] removeObserver:observer];
           observer = nil;
       }
       requestBlock();
   }];
}

@end
