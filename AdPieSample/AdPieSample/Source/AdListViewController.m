#import "AdListViewController.h"
#import "AdListCell.h"
#import "AdMenuItem.h"
#import "InterstitialAdViewController.h"
#import "RewardedAdViewController.h"
#import "NativeAdViewController.h"
#import "BannerAdViewController.h"
#import <AdPieSDK/AdPieSDK.h>

@interface AdListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<AdMenuItem *> *items;
@end

@implementation AdListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    
    self.items = @[
        
        [AdMenuItem itemWithTitle:@"Banner Ad" subtitle:@"배너 광고" actionBlock:^{
            return [[BannerAdViewController alloc] initWithSlotId:@"57342fdd7174ea39844cac15"];
        }],
        
        [AdMenuItem itemWithTitle:@"Interstitial Ad" subtitle:@"전면 광고" actionBlock:^{
            return [[InterstitialAdViewController alloc] initWithSlotId:@"573430057174ea39844cac16"];
        }],
        
        [AdMenuItem itemWithTitle:@"Rewarded Ad" subtitle:@"리워드 광고" actionBlock:^{
            return [[RewardedAdViewController alloc] initWithSlotId:@"61de726d65a17f71c7896827"];
        }],
        
        [AdMenuItem itemWithTitle:@"Native Ad" subtitle:@"네이티브 광고" actionBlock:^{
            return [[NativeAdViewController alloc] initWithSlotId:@"580491a37174ea5279c5d09b"];
        }]
    ];
    
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = [NSString stringWithFormat:@"AdPie SDK v%@", [AdPieSDK sdkVersion]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[AdListCell class] forCellReuseIdentifier:@"AdListCell"];
    
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdListCell" forIndexPath:indexPath];
    
    AdMenuItem *item = self.items[indexPath.row];
    [cell configureWithData:item];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AdMenuItem *selectedItem = self.items[indexPath.row];
    if (selectedItem.actionBlock) {
        UIViewController *destinationVC = selectedItem.actionBlock();
        if (destinationVC) {
            destinationVC.title = selectedItem.title;
            if (self.navigationController) {
                [self.navigationController pushViewController:destinationVC animated:YES];
            } else {
                [self presentViewController:destinationVC animated:YES completion:nil];
            }
        }
    }
}

@end
