//
//  NativeAdTableViewController.h
//  AdPieSample
//
//  Created by sunny on 2016. 10. 17..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <AdPieSDK/AdPieSDK.h>
#import "AdPieTableViewCell.h"
#import <UIKit/UIKit.h>

@interface NativeAdTableViewController : UITableViewController <APNativeDelegate>

@property(strong, nonatomic) APNativeAd *nativeAd;

@property(strong, nonatomic) NSMutableArray *itemsArray;
@property(strong, nonatomic) NSMutableDictionary *adViewDictionary;
@property(nonatomic) int adRowIndex;

@end
