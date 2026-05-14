#import "NativeAdViewController.h"
#import "AdPieTableViewCell.h"
#import <AdPieSDK/AdPieSDK.h>
#import "UIViewController+Toast.h"

@interface NativeAdViewController () <APNativeDelegate>
// MARK: - Properties
@property (nonatomic, copy) NSString *slotId;
@property (nonatomic, strong) APNativeAd *nativeAd;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSInteger adRowIndex;
@end

@implementation NativeAdViewController

// MARK: - Init

- (instancetype)initWithSlotId:(NSString *)slotId {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _slotId = [slotId copy];
        _adRowIndex = 10;
        _items = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"init(coder:) has not been implemented"
                                 userInfo:nil];
}

// MARK: - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self setupAd];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadAd];
}

// MARK: - Setup

- (void)setupUI {
    // Basic Setup
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    // Height Setup (Support Auto Layout)
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    // Register Cells
    UINib *adNib = [UINib nibWithNibName:@"AdPieTableViewCell" bundle:nil];
    [self.tableView registerNib:adNib forCellReuseIdentifier:@"AdPieTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
}

- (void)setupData {
    for (int i = 1; i <= 20; i++) {
        NSString *item = [NSString stringWithFormat:@"Item %d", i];
        [self.items addObject:item];
    }
}

- (void)setupAd {
    self.nativeAd = [[APNativeAd alloc] initWithSlotId:self.slotId];
    self.nativeAd.delegate = self;
}
    
- (void)loadAd {
    [self.nativeAd load];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = self.items[indexPath.row];
    if ([item isKindOfClass:[NSString class]]) {
        // Normal Text Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
        cell.textLabel.text = (NSString *)item;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if ([item isKindOfClass:[APNativeAdData class]]) {
        // Ad Cell
        AdPieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdPieTableViewCell" forIndexPath:indexPath];
        APNativeAdData *adData = (APNativeAdData *)item;
        // Bind Ad Data
        if ([cell.nativeAdView fillAd:adData]) {
            [self.nativeAd registerViewForInteraction:cell.nativeAdView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = self.items[indexPath.row];
    if ([item isKindOfClass:[APNativeAdData class]]) {
        return 405.0;
    }
    return UITableViewAutomaticDimension;
}


#pragma mark - APNativeDelegate

- (void)nativeDidLoadAd:(APNativeAd *)nativeAd {
    [self showToastWithMessage:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__]];
    if (nativeAd.nativeAdData == nil) { return; }
    NSInteger insertIndex = MIN(self.adRowIndex, self.items.count);
    [self.items insertObject:nativeAd.nativeAdData atIndex:insertIndex];
    [self.tableView reloadData];
}

- (void)nativeDidFailToLoadAd:(APNativeAd *)nativeAd withError:(NSError *)error {
    [self showToastWithMessage:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__]];
    NSString * errorMsg = [NSString stringWithFormat:@"Error (code : %d, message : %@, date : %@)",
                           (int)[error code],
                           [error localizedDescription],
                           [[NSDate date] descriptionWithLocale:[NSLocale systemLocale]]];
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, errorMsg);
}

- (void)nativeWillLeaveApplication:(APNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
