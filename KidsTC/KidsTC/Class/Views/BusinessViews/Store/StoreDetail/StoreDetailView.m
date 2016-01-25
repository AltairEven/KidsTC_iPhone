//
//  StoreDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 7/16/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreDetailView.h"
#import "AUIBannerScrollView.h"
#import "FiveStarsView.h"
#import "StoreDetailViewActiveCell.h"
#import "StoreDetailViewCouponCell.h"
#import "StoreListViewCell.h"
#import "StoreDetailTitleCell.h"
#import "StoreDetailHotRecommendCell.h"
#import "StoreDetailCommentCell.h"
#import "StoreDetailServiceCell.h"
#import "StoreDetailStrategyCell.h"
#import "TTTAttributedLabel.h"

#define ServiceMaxDisplayCount (3)
#define HotRecommendMaxDisplayCount (1)
#define StrategyMaxDisplayCount (1)

typedef enum {
    StoreDetailViewSectionTop = 0,
    StoreDetailViewSectionAddress = 1,
    StoreDetailViewSectionCoupon = 2,
    StoreDetailViewSectionActivity = 3,
    StoreDetailViewSectionHotRecommend = 4,
    StoreDetailViewSectionService = 5,
    StoreDetailViewSectionRecommend = 6,
    StoreDetailViewSectionComment = 7,
    StoreDetailViewSectionDetailInfo = 8,
    StoreDetailViewSectionStrategy = 9,
    StoreDetailViewSectionNearby = 10
}StoreDetailViewSection;


static NSString *const kTitleCellIdentifier = @"kTitleCellIdentifier";
static NSString *const kActivityCellIdentifier = @"kActivityCellIdentifier";
static NSString *const kCouponCellIdentifier = @"kCouponCellIdentifier";
static NSString *const kHotRecommendCellIdentifier = @"kHotRecommendCellIdentifier";
static NSString *const kCommentCellIdentifier = @"kCommentCellIdentifier";
static NSString *const kBrotherStoreCellIdentifier = @"kBrotherStoreCellIdentifier";
static NSString *const kServiceCellIdentifier = @"kServiceCellIdentifier";
static NSString *const kStrategyCellIdentifier = @"kStrategyCellIdentifier";

@interface StoreDetailView () <UITableViewDataSource, UITableViewDelegate, AUIBannerScrollViewDataSource, StoreDetailCommentCellDelegate, TTTAttributedLabelDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *topCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *nearbyCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *recommendCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *detailInfoCell;

//banner
@property (weak, nonatomic) IBOutlet AUIBannerScrollView *bannerScrollView;
//top
@property (weak, nonatomic) IBOutlet UIView *storeAddressBriefBGView;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressBriefLabel;
@property (weak, nonatomic) IBOutlet UILabel *broStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *storeBriefLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starView;
@property (weak, nonatomic) IBOutlet UILabel *appointmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
//commend
@property (weak, nonatomic) IBOutlet UIView *recommendBGView;
@property (weak, nonatomic) IBOutlet UIImageView *recommenderFaceImageView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
//detail info
@property (weak, nonatomic) IBOutlet UIWebView *detailInfoView;
//nearby
@property (weak, nonatomic) IBOutlet UIView *nearbyBGView;
//brothers

@property (nonatomic, strong) UINib *titleCellNib;
@property (nonatomic, strong) UINib *activityCellNib;
@property (nonatomic, strong) UINib *couponCellNib;
@property (nonatomic, strong) UINib *hotRecommendCellNib;
@property (nonatomic, strong) UINib *commentCellNib;
@property (nonatomic, strong) UINib *brotherStoreCellNib;
@property (nonatomic, strong) UINib *serviceCellNib;
@property (nonatomic, strong) UINib *strategyCellNib;

@property (nonatomic, strong) StoreDetailModel *detailModel;

@property (nonatomic, strong) NSArray *sectionIdentifiersArray;

- (UITableViewCell *)createTableCellWithIdentifier:(NSString *)identifier forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

- (void)configTitleCell:(StoreDetailTitleCell *)cell WithSection:(StoreDetailViewSection)section;
- (void)configTopCell;
- (void)configRecommendCell;
- (void)configNearbyCell;

- (void)didTappedOnAddressBrief;
- (IBAction)didClickedCouponButton:(id)sender;

- (void)didTappedOnStoreNearby:(id)sender;

@end

@implementation StoreDetailView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        StoreDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.bannerScrollView.dataSource = self;
    [self.bannerScrollView setRecyclable:YES];
    [self.bannerScrollView setShowPageIndex:NO];
    
    [self.storeBriefLabel setDelegate:self];
    [self.storeBriefLabel setLinkAttributes:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnAddressBrief)];
    [self.storeAddressBriefBGView addGestureRecognizer:tap];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    UIView *footBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    self.tableView.tableFooterView = footBG;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (!self.titleCellNib) {
        self.titleCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailTitleCell class]) bundle:nil];
        [self.tableView registerNib:self.titleCellNib forCellReuseIdentifier:kTitleCellIdentifier];
    }
    if (!self.activityCellNib) {
        self.activityCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailViewActiveCell class]) bundle:nil];
        [self.tableView registerNib:self.activityCellNib forCellReuseIdentifier:kActivityCellIdentifier];
    }
    if (!self.couponCellNib) {
        self.couponCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailViewCouponCell class]) bundle:nil];
        [self.tableView registerNib:self.couponCellNib forCellReuseIdentifier:kCouponCellIdentifier];
    }
    if (!self.serviceCellNib) {
        self.serviceCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailServiceCell class]) bundle:nil];
        [self.tableView registerNib:self.serviceCellNib forCellReuseIdentifier:kServiceCellIdentifier];
    }
    if (!self.hotRecommendCellNib) {
        self.hotRecommendCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailHotRecommendCell class]) bundle:nil];
        [self.tableView registerNib:self.hotRecommendCellNib forCellReuseIdentifier:kHotRecommendCellIdentifier];
    }
    if (!self.strategyCellNib) {
        self.strategyCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailStrategyCell class]) bundle:nil];
        [self.tableView registerNib:self.strategyCellNib forCellReuseIdentifier:kStrategyCellIdentifier];
    }
    if (!self.commentCellNib) {
        self.commentCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailCommentCell class]) bundle:nil];
        [self.tableView registerNib:self.commentCellNib forCellReuseIdentifier:kCommentCellIdentifier];
    }
    if (!self.brotherStoreCellNib) {
        self.brotherStoreCellNib = [UINib nibWithNibName:NSStringFromClass([StoreListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.brotherStoreCellNib forCellReuseIdentifier:kBrotherStoreCellIdentifier];
    }
    
    [self.recommendCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    self.recommenderFaceImageView.layer.cornerRadius = 30;
    self.recommenderFaceImageView.layer.masksToBounds = YES;
    
    self.detailInfoView.delegate = self;
//    self.detailInfoView.scrollView.scrollEnabled = NO;
    self.detailInfoView.scrollView.showsHorizontalScrollIndicator = NO;
    self.detailInfoView.scrollView.showsVerticalScrollIndicator = NO;
    NSString *userAgent = [self.detailInfoView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *extInfo = [NSString stringWithFormat:@"KidsTC/Iphone/%@", appVersion];
    if ([userAgent rangeOfString:extInfo].location == NSNotFound)
    {
        NSString *newUserAgent = [NSString stringWithFormat:@"%@ %@", userAgent, extInfo];
        // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    
    [self.nearbyBGView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionIdentifiersArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    StoreDetailViewSection sectionEnum = (StoreDetailViewSection)[[self.sectionIdentifiersArray objectAtIndex:section] integerValue];
    NSUInteger number = 0;
    switch (sectionEnum) {
        case StoreDetailViewSectionTop:
        {
            number = 1;
        }
            break;
        case StoreDetailViewSectionCoupon:
        {
            number = 1;
        }
            break;
        case StoreDetailViewSectionActivity:
        {
            number = [self.detailModel.activeModelsArray count];
        }
            break;
        case StoreDetailViewSectionService:
        {
            NSUInteger count = [self.detailModel.serviceModelsArray count];
            if (count > ServiceMaxDisplayCount) {
                //最多3个
                count = ServiceMaxDisplayCount;
            }
            if (count > 0) {
                //include title
                count ++;
            }
            number = count;
        }
            break;
        case StoreDetailViewSectionHotRecommend:
        {
            NSUInteger count = [[self.detailModel.hotRecommedService recommendItems] count];
            if (count > HotRecommendMaxDisplayCount) {
                //最多1个
                count = HotRecommendMaxDisplayCount;
            }
            if (count > 0) {
                //include title
                count ++;
            }
            number = count;
        }
            break;
        case StoreDetailViewSectionRecommend:
        {
            number = 1;
        }
            break;
        case StoreDetailViewSectionComment:
        {
            NSUInteger count = [self.detailModel.commentItemsArray count];
            if (count > 2) {
                count = 2;
            } else if (count == 0) {
                count = 2;
            } else {
                //include title
                count ++;
            }
            number = count;
        }
            break;
        case StoreDetailViewSectionDetailInfo:
        {
            //include title
            if ([self.detailModel.storeBrief length] > 0) {
                number = 2;
            } else {
                number = 1;
            }
        }
            break;
        case StoreDetailViewSectionStrategy:
        {
            NSUInteger count = [self.detailModel.strategyModelsArray count];
            if (count > StrategyMaxDisplayCount) {
                //最多1个
                count = StrategyMaxDisplayCount;
            }
            if (count > 0) {
                //include title
                count ++;
            }
            number = count;
        }
            break;
        case StoreDetailViewSectionNearby:
        {
            //include title
            number = 2;
        }
            break;
        default:
            break;
    }
    return number;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    StoreDetailViewSection sectionEnum = (StoreDetailViewSection)[[self.sectionIdentifiersArray objectAtIndex:indexPath.section] integerValue];
    switch (sectionEnum) {
        case StoreDetailViewSectionTop:
        {
            cell = self.topCell;
        }
            break;
        case StoreDetailViewSectionCoupon:
        {
            cell = [self createTableCellWithIdentifier:kCouponCellIdentifier forTableView:tableView atIndexPath:indexPath];
            [((StoreDetailViewCouponCell *)cell).descriptionLabel setText:self.detailModel.couponName];
            if (self.detailModel.couponProvideCount > 0) {
                NSString *countString = [NSString stringWithFormat:@"%lu", (unsigned long)self.detailModel.couponProvideCount];
                NSString *wholeString = [NSString stringWithFormat:@"已有%@人领用", countString];
                NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
                NSDictionary *attribute = [NSDictionary dictionaryWithObject:[[KTCThemeManager manager] defaultTheme].highlightTextColor forKey:NSForegroundColorAttributeName];
                [labelString setAttributes:attribute range:NSMakeRange(2, [countString length])];
                [((StoreDetailViewCouponCell *)cell).subTitleLabel setAttributedText:labelString];
            } else {
                [((StoreDetailViewCouponCell *)cell).subTitleLabel setText:@"更多优惠券"];
            }
        }
            break;
        case StoreDetailViewSectionActivity:
        {
            cell = [self createTableCellWithIdentifier:kActivityCellIdentifier forTableView:tableView atIndexPath:indexPath];
            [((StoreDetailViewActiveCell *)cell) configWithModel:[self.detailModel.activeModelsArray objectAtIndex:indexPath.row]];
        }
            break;
        case StoreDetailViewSectionService:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionService];
            } else {
                cell = [self createTableCellWithIdentifier:kServiceCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [((StoreDetailServiceCell *)cell) configWithModel:[self.detailModel.serviceModelsArray objectAtIndex:indexPath.row - 1]];
            }
        }
            break;
        case StoreDetailViewSectionHotRecommend:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionHotRecommend];
            } else {
                cell = [self createTableCellWithIdentifier:kHotRecommendCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [((StoreDetailHotRecommendCell *)cell) configWithModel:[[self.detailModel.hotRecommedService recommendItems] objectAtIndex:indexPath.row - 1]];
            }
        }
            break;
        case StoreDetailViewSectionRecommend:
        {
            cell = self.recommendCell;
        }
            break;
        case StoreDetailViewSectionComment:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionComment];
            } else {
                cell = [self createTableCellWithIdentifier:kCommentCellIdentifier forTableView:tableView atIndexPath:indexPath];
                if ([self.detailModel.commentItemsArray count] > 0) {
                    ((StoreDetailCommentCell *)cell).delegate = self;
                    [((StoreDetailCommentCell *)cell) configWithModel:[self.detailModel.commentItemsArray objectAtIndex:indexPath.row - 1]];
                    ((StoreDetailCommentCell *)cell).indexPath = indexPath;
                } else {
                    [((StoreDetailCommentCell *)cell) configWithModel:nil];
                }
            }
        }
            break;
        case StoreDetailViewSectionDetailInfo:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionDetailInfo];
            } else {
                cell = self.detailInfoCell;
            }
        }
            break;
        case StoreDetailViewSectionStrategy:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionStrategy];
            } else {
                cell = [self createTableCellWithIdentifier:kStrategyCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [((StoreDetailStrategyCell *)cell) configWithItemModel:[self.detailModel.strategyModelsArray objectAtIndex:indexPath.row - 1]];
            }
        }
            break;
        case StoreDetailViewSectionNearby:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionNearby];
            } else {
                cell = self.nearbyCell;
            }
        }
            break;
        default:
            break;
    }
    [cell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    StoreDetailViewSection sectionEnum = (StoreDetailViewSection)[[self.sectionIdentifiersArray objectAtIndex:indexPath.section] integerValue];
    switch (sectionEnum) {
        case StoreDetailViewSectionTop:
        {
            height = [self.detailModel topCellHeight];
        }
            break;
        case StoreDetailViewSectionCoupon:
        {
            height = [self.detailModel couponCellHeight];
        }
            break;
        case StoreDetailViewSectionActivity:
        {
            height = [self.detailModel activityCellHeightAtIndex:indexPath.row];
        }
            break;
        case StoreDetailViewSectionService:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = [StoreDetailServiceCell cellHeight];
            }
        }
            break;
        case StoreDetailViewSectionHotRecommend:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = [StoreDetailHotRecommendCell cellHeight];
            }
        }
            break;
        case StoreDetailViewSectionRecommend:
        {
            height = [self.detailModel recommendCellHeight];
        }
            break;
        case StoreDetailViewSectionComment:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                if ([self.detailModel.commentItemsArray count] > 0) {
                    CommentListItemModel *model = [self.detailModel.commentItemsArray objectAtIndex:indexPath.row - 1];
                    height = [model storeDetailCellHeight];
                } else {
                    return 140;
                }
            }
        }
            break;
        case StoreDetailViewSectionDetailInfo:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = self.detailInfoView.scrollView.contentSize.height;
            }
        }
            break;
        case StoreDetailViewSectionStrategy:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                StoreRelatedStrategyModel *model = [self.detailModel.strategyModelsArray objectAtIndex:indexPath.row - 1];
                height = [model cellHeight];
            }
        }
            break;
        case StoreDetailViewSectionNearby:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = [self.detailModel nearbyCellHeight];
            }
        }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.01;
    if (section > 0) {
        height = 2.5;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 2.5;
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.delegate) {
        StoreDetailViewSection sectionEnum = (StoreDetailViewSection)[[self.sectionIdentifiersArray objectAtIndex:indexPath.section] integerValue];
        switch (sectionEnum) {
            case StoreDetailViewSectionService:
            {
                if (indexPath.row == 0) {
                    if ([self.detailModel.serviceModelsArray count] <= ServiceMaxDisplayCount) {
                        return;
                    }
                    if ([self.delegate respondsToSelector:@selector(didClickedAllServiceOnStoreDetailView:)]) {
                        [self.delegate didClickedAllServiceOnStoreDetailView:self];
                    }
                } else {
                    if ([self.delegate respondsToSelector:@selector(storeDetailView:didClickedServiceAtIndex:)]) {
                        [self.delegate storeDetailView:self didClickedServiceAtIndex:indexPath.row - 1];
                    }
                }
            }
                break;
            case StoreDetailViewSectionCoupon:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedCouponButtonOnStoreDetailView:)]) {
                    [self.delegate didClickedCouponButtonOnStoreDetailView:self];
                }
            }
                break;
            case StoreDetailViewSectionActivity:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedActiveOnStoreDetailView:atIndex:)]) {
                    [self.delegate didClickedActiveOnStoreDetailView:self atIndex:indexPath.row];
                }
            }
                break;
            case StoreDetailViewSectionHotRecommend:
            {
                if (indexPath.row == 0) {
                    if ([self.detailModel.hotRecommedService.recommendItems count] <= HotRecommendMaxDisplayCount) {
                        return;
                    }
                    if ([self.delegate respondsToSelector:@selector(didClickedAllHotRecommendOnStoreDetailView:)]) {
                        [self.delegate didClickedAllHotRecommendOnStoreDetailView:self];
                    }
                } else {
                    if ([self.delegate respondsToSelector:@selector(storeDetailView:didSelectedHotRecommendAtIndex:)]) {
                        [self.delegate storeDetailView:self didSelectedHotRecommendAtIndex:indexPath.row - 1];
                    }
                }
            }
                break;
            case StoreDetailViewSectionComment:
            {
                if (indexPath.row == 0) {
                    if (self.detailModel.commentAllNumber == 0) {
                        return;
                    }
                    if ([self.delegate respondsToSelector:@selector(didClickedMoreReviewOnStoreDetailView:)]) {
                        [self.delegate didClickedMoreReviewOnStoreDetailView:self];
                    }
                } else {
                    if ([self.delegate respondsToSelector:@selector(storeDetailView:didClickedReviewAtIndex:)]) {
                        [self.delegate storeDetailView:self didClickedReviewAtIndex:indexPath.row - 1];
                    }
                }
            }
                break;
            case StoreDetailViewSectionDetailInfo:
            {
                if (indexPath.row == 0 && [self.delegate respondsToSelector:@selector(didClickedMoreDetailOnStoreDetailView:)]) {
                    [self.delegate didClickedMoreDetailOnStoreDetailView:self];
                }
            }
                break;
            case StoreDetailViewSectionStrategy:
            {
                if (indexPath.row == 0) {
                    if ([self.detailModel.serviceModelsArray count] <= ServiceMaxDisplayCount) {
                        return;
                    }
                    if ([self.delegate respondsToSelector:@selector(didClickedAllStrategyOnStoreDetailView:)]) {
                        [self.delegate didClickedAllStrategyOnStoreDetailView:self];
                    }
                } else {
                    if ([self.delegate respondsToSelector:@selector(storeDetailView:didSelectedSteategyAtIndex:)]) {
                        [self.delegate storeDetailView:self didSelectedSteategyAtIndex:indexPath.row - 1];
                    }
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark AUIBannerScrollViewDataSource

- (NSUInteger)numberOfBannersOnScrollView:(AUIBannerScrollView *)scrollView {
    return [self.detailModel.imageUrls count];
}

- (UIImageView *)bannerImageViewOnScrollView:(AUIBannerScrollView *)scrollView withViewFrame:(CGRect)frame atIndex:(NSUInteger)index {
    UIImageView *imageView = nil;
    imageView = [[UIImageView alloc] initWithFrame:frame];
    NSURL *imageUrl = [self.detailModel.imageUrls objectAtIndex:index];
    [imageView setImageWithURL:imageUrl];
    return imageView;
}

- (NSURL *)bannerImageUrlForScrollView:(AUIBannerScrollView *)scrollView atIndex:(NSUInteger)index {
    NSURL *imageUrl = [self.detailModel.imageUrls objectAtIndex:index];
    return imageUrl;
}


- (CGFloat)heightForBannerScrollView:(AUIBannerScrollView *)scrollView {
    return self.detailModel.imageRatio * SCREEN_WIDTH;
}

#pragma mark StoreDetailCommentCellDelegate

- (void)storeDetailCommentCell:(StoreDetailCommentCell *)cell didClickedImageAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(storeDetailView:didClickedReviewAtIndex:)]) {
        [self.delegate storeDetailView:self didClickedReviewAtIndex:cell.indexPath.row - 1];
    }
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeDetailView:didSelectedLinkWithSegueModel:)]) {
        TextSegueModel *model = [addressComponents objectForKey:@"promotionSegueModel"];
        [self.delegate storeDetailView:self didSelectedLinkWithSegueModel:model.segueModel];
    }
}


#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.tableView reloadData];
    if (![self.detailInfoView isLoading]) {
        [self.detailInfoView.scrollView setContentOffset:CGPointMake(self.detailInfoView.scrollView.contentOffset.x, 0)];
        [self.detailInfoView.scrollView setScrollEnabled:NO];
    }
}

#pragma mark Private method

- (UITableViewCell *)createTableCellWithIdentifier:(NSString *)identifier forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        if ([identifier isEqualToString:kTitleCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailTitleCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kCouponCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailViewCouponCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kActivityCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailViewActiveCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kServiceCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailServiceCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kHotRecommendCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailHotRecommendCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kStrategyCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailStrategyCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kCommentCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailHotCommentCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kBrotherStoreCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreListViewCell" owner:nil options:nil] objectAtIndex:0];
        }
    }
    return cell;
}

- (void)configTopCell {
    [GConfig resetLineView:self.bannerScrollView withLayoutAttribute:NSLayoutAttributeHeight constant:self.detailModel.imageRatio * SCREEN_WIDTH];
    
    if ([self.detailModel.storeAddress length] > 0) {
        [self.storeAddressBriefBGView setHidden:NO];
        [self.storeAddressBriefLabel setText:self.detailModel.storeAddress];
    } else {
        [self.storeAddressBriefBGView setHidden:YES];
    }
    
    NSString *title = @"点击查看";
    NSUInteger count = [self.detailModel.brotherStores count];
    if (count > 0) {
        title = [NSString stringWithFormat:@"共%lu家兄弟门店", (unsigned long)count];
    }
    [self.broStoreLabel setText:title];
    
    [self.storeName setText:self.detailModel.storeName];
    
    
    NSMutableAttributedString *briefLabelString = [[NSMutableAttributedString alloc] initWithString:self.detailModel.storeBrief];
    NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [[KTCThemeManager manager] defaultTheme].globalThemeColor, NSForegroundColorAttributeName, nil];
    [briefLabelString setAttributes:fontAttribute range:NSMakeRange(0, [briefLabelString length])];
    if (self.detailModel.promotionSegueModels) {
        for (TextSegueModel *model in self.detailModel.promotionSegueModels) {
            //[NSNumber numberWithBool:YES], NSUnderlineStyleAttributeName
            NSDictionary *linkAttribute = [NSDictionary dictionaryWithObjectsAndKeys:model.linkColor, NSForegroundColorAttributeName, [NSNumber numberWithBool:YES], NSUnderlineStyleAttributeName, nil];
            for (NSString *rangeString in model.linkRangeStrings) {
                NSRange range = NSRangeFromString(rangeString);
                [briefLabelString addAttributes:linkAttribute range:range];
                [self.storeBriefLabel addLinkToAddress:[NSDictionary dictionaryWithObject:model forKey:@"promotionSegueModel"] withRange:range];
            }
        }
    }
    [self.storeBriefLabel setAttributedText:briefLabelString];
    
    [self.starView setStarNumber:self.detailModel.starNumber];
    
    NSString *appointmentCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.detailModel.appointmentNumber];
    NSString *wholeString = [NSString stringWithFormat:@"%@预约", appointmentCount];
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[[KTCThemeManager manager] defaultTheme].highlightTextColor forKey:NSForegroundColorAttributeName];
    [labelString setAttributes:attribute range:NSMakeRange(0, [appointmentCount length])];
    [self.appointmentLabel setAttributedText:labelString];
    [self.appointmentLabel sizeOfSizeToFitWithMaximumNumberOfLines:1];
    
    NSString *commentCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.detailModel.commentNumber];
    wholeString = [NSString stringWithFormat:@"%@评价", commentCount];
    labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
    [labelString setAttributes:attribute range:NSMakeRange(0, [commentCount length])];
    [self.reviewLabel setAttributedText:labelString];
    [self.reviewLabel sizeOfSizeToFitWithMaximumNumberOfLines:1];
    
    [self.topCell layoutIfNeeded];
}

- (void)configTitleCell:(StoreDetailTitleCell *)cell WithSection:(StoreDetailViewSection)section {
    switch (section) {
        case StoreDetailViewSectionService:
        {
            NSString *subTitle = nil;
            if ([self.detailModel.serviceModelsArray count] > ServiceMaxDisplayCount) {
                subTitle = @"更多";
            }
            [cell resetWithMainTitle:@"优惠服务" subTitle:subTitle];
        }
            break;
        case StoreDetailViewSectionHotRecommend:
        {
            NSString *subTitle = nil;
            if ([[self.detailModel.hotRecommedService recommendItems] count] > HotRecommendMaxDisplayCount) {
                subTitle = @"查看更多";
                if ([self.detailModel.hotRecommedService.keyword length] > 0) {
                    subTitle = [NSString stringWithFormat:@"更多%@", self.detailModel.hotRecommedService.keyword];
                }
            }
            [cell resetWithMainTitle:self.detailModel.hotRecommedService.title subTitle:subTitle];
        }
            break;
        case StoreDetailViewSectionComment:
        {
            NSString *subTitle = nil;
            if (self.detailModel.commentAllNumber > 0) {
                subTitle = [NSString stringWithFormat:@"%lu人已评论", (unsigned long)self.detailModel.commentAllNumber];
            }
            [cell resetWithMainTitle:@"用户评论" subTitle:subTitle];
        }
            break;
        case StoreDetailViewSectionDetailInfo:
        {
            [cell resetWithMainTitle:@"门店介绍" subTitle:nil];
        }
            break;
        case StoreDetailViewSectionStrategy:
        {
            NSString *subTitle = nil;
            if ([self.detailModel.strategyModelsArray count] > StrategyMaxDisplayCount) {
                subTitle = @"更多";
            }
            [cell resetWithMainTitle:@"经验说" subTitle:subTitle];
        }
            break;
        case StoreDetailViewSectionNearby:
        {
            [cell resetWithMainTitle:@"门店附近" subTitle:nil];
        }
            break;
        default:
            break;
    }
}

- (void)configRecommendCell {
    
    [self.recommenderFaceImageView setImageWithURL:self.detailModel.recommenderFaceImageUrl];
    
    NSString *recommderName = self.detailModel.recommenderName;
    if ([recommderName length] == 0) {
        recommderName = @"童童推荐";
    }
    NSString *wholeString = [NSString stringWithFormat:@"%@：%@", recommderName, self.detailModel.recommendString];
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:15] forKey:NSFontAttributeName];
    [labelString setAttributes:attribute range:NSMakeRange(0, [recommderName length] + 1)];
    [self.recommendLabel setAttributedText:labelString];
}

- (void)configNearbyCell {
    for (UIView *subview in self.nearbyBGView.subviews) {
        UIGestureRecognizer *gesRec = [subview.gestureRecognizers firstObject];
        if (gesRec) {
            [subview removeGestureRecognizer:gesRec];
        }
        [subview removeFromSuperview];
    }
    
    CGFloat gap = 0.5;
    CGFloat singleWidth = (SCREEN_WIDTH - gap * 2) / 3;
    CGFloat singleHeight = 40;
    
    CGFloat xPosition = 0;
    CGFloat yPosition = 0;
    
    CGFloat margin = 5;
    CGFloat imageSideLenght = singleHeight - margin * 2;
    CGFloat labelWidth = singleWidth - margin * 3 - imageSideLenght;
    UIFont *font = [UIFont systemFontOfSize:13];
    UIColor *gapColor = RGBA(230, 230, 230, 0.7);
    
    NSUInteger nearbyCount = [self.detailModel.nearbyFacilities count];
    
    for (NSUInteger index = 0; index < nearbyCount; index ++) {
        StoreDetailNearbyModel *model = [self.detailModel.nearbyFacilities objectAtIndex:index];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(xPosition, yPosition, singleWidth, singleHeight)];
        bgView.tag = index;
        [bgView setBackgroundColor:[UIColor clearColor]];
        [self.nearbyBGView addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, imageSideLenght, imageSideLenght)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setImageWithURL:model.imageUrl];
        [bgView addSubview:imageView];
        
        CGFloat labelStart = margin + imageSideLenght + margin;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelStart, margin, labelWidth, imageSideLenght)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:font];
        [label setTextColor:[UIColor lightGrayColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:model.name];
        [bgView addSubview:label];
        
        if (index < nearbyCount - 1) {
            //非最后一个
            if (index % 3 < 2) {
                //行内
                xPosition += singleWidth;
                
                UIView *vGapView = [[UIView alloc] initWithFrame:CGRectMake(xPosition, yPosition + margin, gap, imageSideLenght)];
                [vGapView setBackgroundColor:gapColor];
                [self.nearbyBGView addSubview:vGapView];
                
                xPosition += gap;
                
            } else {
                //换行
                xPosition = 0;
                yPosition += singleHeight;
                
                UIView *hGapView = [[UIView alloc] initWithFrame:CGRectMake(margin, yPosition, SCREEN_WIDTH - margin * 2, gap)];
                [hGapView setBackgroundColor:gapColor];
                [self.nearbyBGView addSubview:hGapView];
            }
        }
        
        if (model.hasInfo) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnStoreNearby:)];
            [bgView addGestureRecognizer:tap];
            [label setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
        }
    }
}

- (void)didTappedOnAddressBrief {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAddressOnStoreDetailView:)]) {
        [self.delegate didClickedAddressOnStoreDetailView:self];
    }
}

- (IBAction)didClickedCouponButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCouponButtonOnStoreDetailView:)]) {
        [self.delegate didClickedCouponButtonOnStoreDetailView:self];
    }
}

- (void)didTappedOnStoreNearby:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeDetailView:didClickedNearbyAtIndex:)]) {
        UIView *view = ((UITapGestureRecognizer *)sender).view;
        [self.delegate storeDetailView:self didClickedNearbyAtIndex:view.tag];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailModelForStoreDetailView:)]) {
        self.detailModel = [self.dataSource detailModelForStoreDetailView:self];
        if (self.detailModel) {
            NSMutableArray *tempSections = [[NSMutableArray alloc] init];
            [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionTop]];
            if ([self.detailModel hasCoupon]) {
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionCoupon]];
            }
            if ([self.detailModel.activeModelsArray count] > 0) {
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionActivity]];
            }
            if ([[self.detailModel.hotRecommedService recommendItems] count] > 0) {
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionHotRecommend]];
            }
            if ([self.detailModel.serviceModelsArray count] > 0) {
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionService]];
            }
            if ([self.detailModel.recommendString length] > 0) {
                [self configRecommendCell];
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionRecommend]];
            }
            [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionComment]];
            [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionDetailInfo]];
            self.detailInfoView.scrollView.scrollEnabled = YES;
            [self.detailInfoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailModel.detailUrlString]]];
            if ([self.detailModel.strategyModelsArray count] > 0) {
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionStrategy]];
            }
            if ([self.detailModel.nearbyFacilities count] > 0) {
                [self configNearbyCell];
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionNearby]];
            }
            self.sectionIdentifiersArray = [NSArray arrayWithArray:tempSections];
            
            [self configTopCell];
        } else {
            self.sectionIdentifiersArray = nil;
        }
    }
    [self.tableView reloadData];
    [self.bannerScrollView reloadData];
    if (!self.detailModel) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
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
