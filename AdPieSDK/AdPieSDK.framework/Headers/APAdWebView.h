//
//  APAdWebView.h
//  AdPieSDK
//
//  Created by sunny on 2016. 2. 22..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AP_EVENT_ERROR = 0,
    AP_EVENT_IMPRESSION = 1,
    AP_EVENT_CLICK = 2
} kEventType;

typedef void (^EventBlock)(kEventType eventType, NSString *);

@interface APAdWebView : UIView

- (void)loadData:(NSString *)htmlStr
 timeoutInterval:(NSTimeInterval)ti
      completion:(EventBlock)eventBlock;
- (void)reload;
- (void)stopLoading;
- (void)monitoring:(int) act;
@end

@protocol APAdWebViewDelegate <NSObject>

@optional
- (void)adLoaded:(APAdWebView *)adWebview;
- (void)adFailedToLoad:(APAdWebView *)adWebview;
- (void)adClicked:(NSURL *)url;
@end
