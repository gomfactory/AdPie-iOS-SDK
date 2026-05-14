#import "AdListCell.h"

@interface AdListCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *logoLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIStackView *textStackView;
@end


@implementation AdListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout {
    // 1. Container View
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 12;
    self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.containerView.layer.borderWidth = 1.0;
    self.containerView.clipsToBounds = YES;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.containerView];
    
    // 2. Logo Label
    self.logoLabel = [[UILabel alloc] init];
    self.logoLabel.text = @"AdPie";
    self.logoLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    // RGB 값 50/255.0
    self.logoLabel.textColor = [UIColor colorWithRed:50/255.0 green:80/255.0 blue:120/255.0 alpha:1.0];
    self.logoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.logoLabel];
    
    // 3. Title & Subtitle Labels
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.subtitleLabel.textColor = [UIColor grayColor];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 4. Stack View
    self.textStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.subtitleLabel]];
    self.textStackView.axis = UILayoutConstraintAxisVertical;
    self.textStackView.spacing = 4;
    self.textStackView.alignment = UIStackViewAlignmentLeading;
    self.textStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.textStackView];
    
    // 5. Constraints
    [NSLayoutConstraint activateConstraints:@[
        // Container View Constraints
        [self.containerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        
        // Logo Label Constraints
        [self.logoLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:16],
        [self.logoLabel.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor],
        [self.logoLabel.widthAnchor constraintEqualToConstant:60],
        
        // Stack View Constraints
        [self.textStackView.leadingAnchor constraintEqualToAnchor:self.logoLabel.trailingAnchor constant:8],
        [self.textStackView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-16],
        [self.textStackView.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor]
    ]];
}

- (void)configureWithData:(AdMenuItem *)data {
    self.titleLabel.text = data.title;
    self.subtitleLabel.text = data.subtitle;
}

@end
