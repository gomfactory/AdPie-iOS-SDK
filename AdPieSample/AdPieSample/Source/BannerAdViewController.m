
#import "BannerAdViewController.h"
#import "UIViewController+Toast.h"
#import <AdPieSDK/AdPieSDK.h>

@interface BannerAdViewController () <APAdViewDelegate>
@property (nonatomic, copy) NSString *slotId;
@property (nonatomic, strong) APAdView *bannerView;
@end

@implementation BannerAdViewController

- (instancetype)initWithSlotId:(NSString *)slotId {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _slotId = [slotId copy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Load Ad
    [self.bannerView load];
}


- (void)setupUI {
    // Banner View
    self.bannerView = [[APAdView alloc] init];
    self.bannerView.slotId = self.slotId;
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = self;
    // AutoLayout
    [self.view addSubview:self.bannerView];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.bannerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.bannerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:10],
        [self.bannerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-10],
        [self.bannerView.heightAnchor constraintEqualToConstant:50]
    ]];
    self.bannerView.onPaidEvent = ^(double ecpm) {
        NSLog(@"onPaidEvent, ecpm: %f", ecpm);
    };
}

#pragma mark APAdView delegates
- (void)adViewDidLoadAd:(APAdView *)view {
    [self showToastWithMessage:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__]];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)adViewDidFailToLoadAd:(APAdView *)view withError:(NSError *)error {
    [self showToastWithMessage:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__]];
    NSString * errorMsg = [NSString stringWithFormat:@"Error (code : %d, message : %@, date : %@)",
                           (int)[error code],
                           [error localizedDescription],
                           [[NSDate date] descriptionWithLocale:[NSLocale systemLocale]]];
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, errorMsg);
}

- (void)adViewWillLeaveApplication:(APAdView *)view {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
