#import <WebKit/WebKit.h>
#import "AdPieWebBrowserUserAgent.h"

/**
 Global variable for holding the user agent string.
 */
static NSString *AdPieUserAgent = nil;

/**
 Global variable for keeping `WKWebView` alive until the async call for user agent finishes.
 Note: JavaScript evaluation will fail if the `WKWebView` is deallocated before completion.
 */
static WKWebView *AdPieWkWebView = nil;

/**
 The `UserDefaults` key for accessing the cached user agent value.
 */
static NSString *const AdPieUserDefaultsUserAgentKey = @"com.adpie.sdk.user-agent";

@implementation AdPieWebBrowserUserAgent

+ (void)load {
    // No need for "dispatch once" since `load` is called only once during app launch.
    @try {
        [self obtainUserAgentFromWebView];
    } @catch (NSException *exception) {
        // do nothing
    }
    
}

+ (void)obtainUserAgentFromWebView {
    
    NSString *cachedUserAgent = [[NSUserDefaults standardUserDefaults] stringForKey:AdPieUserDefaultsUserAgentKey];
    if (cachedUserAgent.length > 0) {
        AdPieUserAgent = cachedUserAgent;
    } else {
        NSString *systemVersion = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        NSString *deviceType = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone";
        AdPieUserAgent = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU %@ OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",deviceType, deviceType, systemVersion];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // `WKWebView` must be created in main thread
        AdPieWkWebView = [WKWebView new];
        [AdPieWkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (error != nil) {
                
            } else if (result != nil && [result isKindOfClass:[NSString class]]) {
                AdPieUserAgent = result;
                [[NSUserDefaults standardUserDefaults] setValue:result forKeyPath:AdPieUserDefaultsUserAgentKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            AdPieWkWebView = nil;
        }];
    });
}

+ (NSString *)userAgent {
    return AdPieUserAgent;
}

@end
