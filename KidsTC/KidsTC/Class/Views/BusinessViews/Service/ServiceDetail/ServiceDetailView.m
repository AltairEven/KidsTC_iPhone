//
//  ServiceDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailView.h"
#import "FiveStarsView.h"
#import "RichPriceView.h"
#import "InsuranceView.h"
#import "AUIBannerScrollView.h"
#import "ServiceOwnerStoreModel.h"

#define BannerRatio (0.7)

@interface ServiceDetailView () <UITableViewDataSource, UITableViewDelegate, AUIBannerScrollViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *topCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *storeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *reviewCell;
//top
@property (weak, nonatomic) IBOutlet AUIBannerScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *serviceStarsView;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *saledCountLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *promotionPriceView;
@property (weak, nonatomic) IBOutlet UILabel *priceDescriptionLabel;
@property (weak, nonatomic) IBOutlet InsuranceView *InsuranceView;
@property (weak, nonatomic) IBOutlet UIView *countDownBGView;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
//description
@property (weak, nonatomic) IBOutlet UILabel *serviceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//store
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *storeStarsView;
@property (weak, nonatomic) IBOutlet UILabel *hotSalesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *goIntoStoreButton;
@property (weak, nonatomic) IBOutlet UIButton *moreStoresButton;
//review
@property (weak, nonatomic) IBOutlet UIButton *gotoReviewButton;

//footer
@property (weak, nonatomic) IBOutlet UIView *footerView;

//picker
@property (weak, nonatomic) UIPickerView *storePickerView;

@property (nonatomic, strong) ServiceDetailModel *model;

//private methods
- (void)footerViewDidPulled;

- (void)configTopCell;

- (CGFloat)configDescriptionCell;

- (void)configStoreCell;

- (IBAction)didClickedButton:(id)sender;

@end

@implementation ServiceDetailView


#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        ServiceDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.bannerScrollView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    UIView *footBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self.footerView setFrame:CGRectMake(0, 5, SCREEN_WIDTH, 400)];
    [self.footerView setBackgroundColor:[UIColor whiteColor]];
    [footBG addSubview:self.footerView];
    self.tableView.tableFooterView = footBG;
    //price view
    [self.promotionPriceView setContentColor:[AUITheme theme].buttonBGColor_Normal];
    [self.promotionPriceView.unitLabel setFont:[UIFont systemFontOfSize:15]];
    [self.promotionPriceView.priceLabel setFont:[UIFont systemFontOfSize:25]];
    
    self.priceDescriptionLabel.layer.borderWidth = BORDER_WIDTH;
    self.priceDescriptionLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    self.priceDescriptionLabel.layer.masksToBounds = YES;
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ServiceDetailSubviewSectionReviews + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ServiceDetailSubviewSectionTop:
        {
            [self configTopCell];
            return self.topCell;
        }
            break;
        case ServiceDetailSubviewSectionDescription:
        {
            [self configDescriptionCell];
            return self.descriptionCell;
        }
            break;
        case ServiceDetailSubviewSectionStore:
        {
            [self configStoreCell];
            return self.storeCell;
        }
            break;
        case ServiceDetailSubviewSectionReviews:
        {
            [self.reviewCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.reviewCell;
        }
            break;
        default:
            break;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ServiceDetailSubviewSectionTop:
        {
            CGFloat height = [self heightForBannerScrollView:self.bannerScrollView] + 10;
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 15)];
            [tempLabel setFont:[UIFont systemFontOfSize:17]];
            [tempLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [tempLabel setText:self.model.serviceName];
            height += [tempLabel sizeToFitWithMaximumNumberOfLines:2];
            height += 80;
            
            if (self.model.showCountdown) {
                height += 20;
            }
            
            return height;
        }
            break;
        case ServiceDetailSubviewSectionDescription:
        {
            return [self configDescriptionCell];
        }
            break;
        case ServiceDetailSubviewSectionStore:
        {
            return 180;
        }
            break;
        case ServiceDetailSubviewSectionReviews:
        {
            return 40;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section > ServiceDetailSubviewSectionTop) {
        height = 5;
    }
    return height;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tableView) {
        CGFloat threshold = scrollView.contentSize.height - SCREEN_HEIGHT + PULL_THRESHOLD;
        if (decelerate && (scrollView.contentOffset.y >= threshold)) {
            [self footerViewDidPulled];
        }
    }
}


#pragma mark AUIBannerScrollViewDataSource

- (NSUInteger)numberOfBannersOnScrollView:(AUIBannerScrollView *)scrollView {
    return [self.model.imageUrls count];
}

- (UIImageView *)bannerImageViewOnScrollView:(AUIBannerScrollView *)scrollView withViewFrame:(CGRect)frame atIndex:(NSUInteger)index {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    NSURL *imageUrl = [self.model.imageUrls objectAtIndex:index];
    if (index == 1) {
        [imageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"home4"]];
    } else {
        [imageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"detail_banner"]];
    }
    return imageView;
}


- (CGFloat)heightForBannerScrollView:(AUIBannerScrollView *)scrollView {
    return SCREEN_WIDTH * BannerRatio;
}


#pragma mark Private methods

- (void)footerViewDidPulled {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPulledAtFooterViewOnServiceDetailView:)]) {
        [self.delegate didPulledAtFooterViewOnServiceDetailView:self];
    }
}

- (void)configTopCell {
    [self.topCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    //banner
    [self.bannerScrollView reloadData];
    //others
    [self.serviceNameLabel setText:self.model.serviceName];
    [self.serviceStarsView setStarNumber:self.model.starNumber];
    [self.reviewCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.model.commentsNumber]];
    [self.saledCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.model.saleCount]];
    [self.promotionPriceView setPrice:self.model.price];
    [self.InsuranceView setSupportedInsurance:self.model.supportedInsurances];
    
    if ([self.model.priceDescription length] > 0) {
        [self.priceDescriptionLabel setHidden:NO];
        [self.priceDescriptionLabel setText:self.model.priceDescription];
    } else {
        [self.priceDescriptionLabel setHidden:YES];
    }
    
    [self.countDownBGView setHidden:!self.model.showCountdown];
}

- (CGFloat)configDescriptionCell {
    [self.descriptionCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    CGFloat height = 130;
    [self.serviceDescriptionLabel setText:self.model.promotionDescription];
    [self.descriptionCell layoutIfNeeded];
    CGFloat nowHeight = self.serviceDescriptionLabel.frame.size.height;
    if (nowHeight > 20) {
        height += nowHeight;
    }
    [self.ageLabel setText:self.model.ageDescription];
    [self.dateLabel setText:self.model.timeDescription];
    return height;
}

- (void)configStoreCell {
    [self.storeCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    if (self.model.currentStoreModel) {
        [self.storeImageView setImageWithURL:self.model.currentStoreModel.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.storeNameLabel setText:self.model.currentStoreModel.storeName];
        [self.storeStarsView setStarNumber:self.model.currentStoreModel.starNumber];
        [self.hotSalesCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.model.currentStoreModel.hotSaleCount]];
        [self.followCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.model.currentStoreModel.favourateCount]];
    }
}

- (IBAction)didClickedButton:(id)sender {
    if (!self.delegate) {
        return;
    }
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1000:
        {
            if ([self.delegate respondsToSelector:@selector(didClickedGoIntoStoreButton)]) {
                [self.delegate didClickedGoIntoStoreButton];
            }
        }
            break;
        case 1001:
        {
            if ([self.delegate respondsToSelector:@selector(didClickedMoreStoresButton)]) {
                [self.delegate didClickedMoreStoresButton];
            }
        }
            break;
        case 1002:
        {
            if ([self.delegate respondsToSelector:@selector(didClickedCheckReviewsButton)]) {
                [self.delegate didClickedCheckReviewsButton];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailModelForServiceDetailView:)]) {
        self.model = [self.dataSource detailModelForServiceDetailView:self];
        [self.tableView reloadData];
    }
}

- (void)resetStoreSection {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailModelForServiceDetailView:)]) {
        self.model = [self.dataSource detailModelForServiceDetailView:self];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ServiceDetailSubviewSectionStore] withRowAnimation:UITableViewRowAnimationNone];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
