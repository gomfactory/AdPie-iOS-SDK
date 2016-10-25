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
    
    self.adViewDictionary = [[NSMutableDictionary alloc] init];
    
    // 광고의 테이블 인덱스
    self.adRowIndex = 10;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SimpleTableViewCell"];
    
    // 광고를 위한 XIB 파일 등록
    [self.tableView registerNib:[UINib nibWithNibName:@"AdPieTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdPieTableViewCell"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // ios 8+
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 300;
    }
    
    self.itemsArray = [[NSMutableArray alloc] init];
    for(int i = 0;i<20;i++){
        [self.itemsArray addObject:[NSString stringWithFormat:@"Item %d", (i + 1)]];
    }
    
    // Slot ID 입력
    self.nativeAd = [[APNativeAd alloc] initWithSlotId:@"580491a37174ea5279c5d09b"];
    // 델리게이트 등록
    self.nativeAd.delegate = self;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[self.itemsArray objectAtIndex:indexPath.row] isKindOfClass:[APNativeAdData class]] == YES){
        
        BOOL isValidLayout = NO;
        
        NSString *cellIdentifier = @"AdPieTableViewCell";
        
        if(self.adViewDictionary){
            id cell = [self.adViewDictionary objectForKey:[NSString stringWithFormat:@"%@_%d", cellIdentifier, (int)indexPath.row]];
            
            if(cell && [cell isKindOfClass:[AdPieTableViewCell class]]){
                if(((AdPieTableViewCell *)cell).nativeAdView){
                    isValidLayout = ((AdPieTableViewCell *)cell).nativeAdView.isValidLayout;
                }
            }
        }
        
        if(isValidLayout){
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                // ios 8+
                return UITableViewAutomaticDimension;
            }else{
                return 300;
            }
        }else{
            return 0;
        }
    }else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                // ios 8+
                return UITableViewAutomaticDimension;
        }else{
                return self.tableView.rowHeight;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[self.itemsArray objectAtIndex:indexPath.row] isKindOfClass:[APNativeAdData class]] == YES){
        NSString *cellIdentifier = @"AdPieTableViewCell";
        AdPieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        [self.adViewDictionary setObject:cell forKey:[NSString stringWithFormat:@"%@_%d", cellIdentifier, (int)indexPath.row]];
        
        APNativeAdData *nativeAdData = [self.itemsArray objectAtIndex:indexPath.row];
        
        // 광고뷰에 데이터 표출
        if ([cell.nativeAdView fillAd:nativeAdData]) {
            // 광고 클릭 이벤트 수신을 위해 등록
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark APNativeAd delegates

- (void)nativeDidLoadAd:(APNativeAd *)nativeAd {
    // 광고 로딩 완료 후 이벤트 발생
    if(nativeAd.getNativeAdData){
        if([[self.itemsArray objectAtIndex:self.adRowIndex] isKindOfClass:[APNativeAdData class]] == YES){
            [self.itemsArray replaceObjectAtIndex:self.adRowIndex withObject:nativeAd.getNativeAdData];
        }else{
            [self.itemsArray insertObject:nativeAd.getNativeAdData atIndex:self.adRowIndex];
        }
    }
    
    [self.tableView reloadData];
}

- (void)nativeDidFailToLoadAd:(APNativeAd *)nativeAd
                    withError:(NSError *)error {
    // 광고 요청 실패 후 이벤트 발생
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
    // 광고 클릭 후 이벤트 발생
}

@end
