//
//  NativeAdTableViewController.m
//  AdPieSample
//
//  Created by sunny on 2016. 10. 17..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import "NativeAdTableViewController.h"
#import "AdPieTableViewCell.h"

@implementation NativeAdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 동적으로 셀의 크기 지정
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // ios 8+
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 300;
    }
    
    // 샘플 컨텐츠를 위한 xib 등록
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SimpleTableViewCell"];
    
    // 데이터 저장을 위한 배열 생성
    self.itemsArray = [[NSMutableArray alloc] init];
    for(int i = 0;i<20;i++){
        [self.itemsArray addObject:[NSString stringWithFormat:@"Item %d", (i + 1)]];
    }
    
    // 광고가 존재하는 테이블뷰 셀을 저장하기 위해 생성
    self.adViewDictionary = [[NSMutableDictionary alloc] init];
    
    // 광고의 테이블 인덱스
    self.adRowIndex = 10;
    
    // 광고를 위한 xib 파일 등록
    [self.tableView registerNib:[UINib nibWithNibName:@"AdPieTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdPieTableViewCell"];

    // 광고 객체 생성 (Slot ID 입력)
    self.nativeAd = [[APNativeAd alloc] initWithSlotId:@"580491a37174ea5279c5d09b"];
    
    // 델리게이트 등록
    self.nativeAd.delegate = self;
    
    if (@available(iOS 13, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
        self.tableView.backgroundColor = UIColor.systemBackgroundColor;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 광고 요청
    [self.nativeAd load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[self.itemsArray objectAtIndex:indexPath.row] isKindOfClass:[APNativeAdData class]] == YES){
        NSString *cellIdentifier = @"AdPieTableViewCell";
        AdPieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        [self.adViewDictionary setObject:cell forKey:[NSString stringWithFormat:@"%@_%d", cellIdentifier, (int)indexPath.row]];
        
        APNativeAdData *nativeAdData = [self.itemsArray objectAtIndex:indexPath.row];
        
        if ([cell.nativeAdView fillAd:nativeAdData]) {
            // 클릭 이벤트를 받기 위해 등록
            [self.nativeAd registerViewForInteraction:cell.nativeAdView];
        }

        return cell;
    }else{
        NSString *cellIdentifier = @"SimpleTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = (NSString *)[self.itemsArray objectAtIndex:indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[self.itemsArray objectAtIndex:indexPath.row] isKindOfClass:[APNativeAdData class]] == YES){
        return 405.0;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark APNativeAd delegates

- (void)nativeDidLoadAd:(APNativeAd *)nativeAd {
    // 네이티브 성공
    NSLog(@"%s", __func__);
    if(nativeAd.nativeAdData){
        if([[self.itemsArray objectAtIndex:self.adRowIndex] isKindOfClass:[APNativeAdData class]] == YES){
            [self.itemsArray replaceObjectAtIndex:self.adRowIndex withObject:nativeAd.nativeAdData];
        }else{
            [self.itemsArray insertObject:nativeAd.nativeAdData atIndex:self.adRowIndex];
        }
    }
    [self.tableView reloadData];
}

- (void)nativeDidFailToLoadAd:(APNativeAd *)nativeAd
                    withError:(NSError *)error {
    // 네이티브 실패
    NSLog(@"%s code : %d, message : %@", __func__, (int)[error code],
          [error localizedDescription]);
    
    NSString *title = @"Error";
    NSString *message = [NSString
                         stringWithFormat:
                         @"Failed to load native ads. \n (code : %d, message : %@)",
                         (int)[error code], [error localizedDescription]];
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action){
                               
                               // do something when click button
                           }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate]
                             window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

- (void)nativeWillLeaveApplication:(APNativeAd *)nativeAd {
    // 네이티브 클릭 알림
    NSLog(@"%s", __func__);
}

@end

