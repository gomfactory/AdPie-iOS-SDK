#import "InterstitialAdViewController.h"
#import <AdPieSDK/AdPieSDK.h>
#import "UIViewController+Toast.h"

@interface InterstitialAdViewController () <APInterstitialDelegate>
// Private Properties
@property (nonatomic, copy) NSString *slotId;
@property (nonatomic, strong) APInterstitial *interstitial;
@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation InterstitialAdViewController

#pragma mark - Initialization

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

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupActions];
}

#pragma mark - UI Setup

- (void)setupUI {
    // 1. Load Button
    self.loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loadButton setTitle:@"Load Ad" forState:UIControlStateNormal];
    self.loadButton.backgroundColor = [UIColor systemBlueColor];
    [self.loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loadButton.layer.cornerRadius = 8;
    self.loadButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    self.loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.loadButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.loadButton.widthAnchor constraintEqualToConstant:200].active = YES;
    
    // 2. Show Button
    self.showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showButton setTitle:@"Show Ad" forState:UIControlStateNormal];
    self.showButton.backgroundColor = [UIColor systemGrayColor];
    [self.showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showButton.layer.cornerRadius = 8;
    self.showButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    self.showButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.showButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.showButton.widthAnchor constraintEqualToConstant:200].active = YES;
    
    // 3. StackView
    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 20;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.distribution = UIStackViewDistributionFill;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.stackView addArrangedSubview:self.loadButton];
    [self.stackView addArrangedSubview:self.showButton];
    
    [self.view addSubview:self.stackView];
    
    // 4. StackView AutoLayout
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (void)setupActions {
    [self.loadButton addTarget:self action:@selector(didTapLoadAdButton) forControlEvents:UIControlEventTouchUpInside];
    [self.showButton addTarget:self action:@selector(didTapShowAdButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)didTapLoadAdButton {
    self.interstitial = [[APInterstitial alloc] initWithSlotId:self.slotId];
    self.interstitial.delegate = self;
    [self.interstitial load];
}

- (void)didTapShowAdButton {
    if (!self.interstitial) { return; }
    
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
}

#pragma mark - APInterstitialDelegate

- (void)interstitialDidLoadAd:(APInterstitial *)interstitial {
    [self showToastWithMessage:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__]];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialDidFailToLoadAd:(APInterstitial *)interstitial
                          withError:(NSError *)error
{
    [self showToastWithMessage:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__]];
    NSString * errorMsg = [NSString stringWithFormat:@"Error (code : %d, message : %@, date : %@)",
                           (int)[error code],
                           [error localizedDescription],
                           [[NSDate date] descriptionWithLocale:[NSLocale systemLocale]]];
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, errorMsg);
}

- (void)interstitialDidFailToShowAd:(APInterstitial *)interstitial withError:(NSError *)error {
    [self showToastWithMessage:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__]];
    NSString * errorMsg = [NSString stringWithFormat:@"Error (code : %d, message : %@, date : %@)",
                           (int)[error code],
                           [error localizedDescription],
                           [[NSDate date] descriptionWithLocale:[NSLocale systemLocale]]];
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, errorMsg);
}

- (void)interstitialDidDismissScreen:(APInterstitial *)interstitial {
    [self showToastWithMessage:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__]];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialWillPresentScreen:(APInterstitial *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialWillDismissScreen:(APInterstitial *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialWillLeaveApplication:(APInterstitial *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
