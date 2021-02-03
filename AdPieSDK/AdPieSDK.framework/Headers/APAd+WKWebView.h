//
//  APAd+WKWebView.h
//  AdPieSDK
//
//  Created by sunny on 2016. 12. 1..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APAdWebView.h"
#import <WebKit/WebKit.h>

@interface APAd_WKWebView : APAdWebView <WKNavigationDelegate, UIGestureRecognizerDelegate>

@property(weak, nonatomic) WKWebView *currentWebView;
@property(nonatomic) NSTimer *timer;
@property(strong, nonatomic) EventBlock eventBlock;

- (void)loadData:(NSString *)htmlStr
 timeoutInterval:(NSTimeInterval)ti
      completion:(EventBlock)eventBlock;
- (void)reload;
- (void)stopLoading;
- (void)monitoring:(int) act;
@end
