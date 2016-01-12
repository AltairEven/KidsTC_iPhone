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
#import "AUISegmentView.h"
#import "StoreDetailViewActiveCell.h"
#import "StoreDetailViewCouponCell.h"
#import "StoreListViewCell.h"
#import "StoreDetailTitleCell.h"
#import "StoreDetailHotRecommendCell.h"
#import "StoreDetailCommentCell.h"
#import "StoreDetailServiceLinearCell.h"



typedef enum {
    StoreDetailViewSectionTop = 0,
    StoreDetailViewSectionAddress = 1,
    StoreDetailViewSectionCoupon = 2,
    StoreDetailViewSectionActivity = 3,
    StoreDetailViewSectionHotRecommend = 4,
    StoreDetailViewSectionRecommend = 5,
    StoreDetailViewSectionBrief = 6,
    StoreDetailViewSectionComment = 7,
    StoreDetailViewSectionNearby = 8,
    StoreDetailViewSectionBrother = 19,
    StoreDetailViewSectionService = 10
}StoreDetailViewSection;


static NSString *const kTitleCellIdentifier = @"kTitleCellIdentifier";
static NSString *const kActivityCellIdentifier = @"kActivityCellIdentifier";
static NSString *const kCouponCellIdentifier = @"kCouponCellIdentifier";
static NSString *const kHotRecommendCellIdentifier = @"kHotRecommendCellIdentifier";
static NSString *const kCommentCellIdentifier = @"kCommentCellIdentifier";
static NSString *const kBrotherStoreCellIdentifier = @"kBrotherStoreCellIdentifier";
static NSString *const kServiceLinearCellIdentifier = @"kServiceLinearCellIdentifier";

@interface StoreDetailView () <UITableViewDataSource, UITableViewDelegate, AUIBannerScrollViewDataSource, AUISegmentViewDataSource, AUISegmentViewDelegate, StoreDetailCommentCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *topCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *briefCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *nearbyCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *recommendCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *serviceLinearCell;

//banner
@property (weak, nonatomic) IBOutlet AUIBannerScrollView *bannerScrollView;
//top
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet FiveStarsView *starView;
@property (weak, nonatomic) IBOutlet UILabel *appointmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
//tel
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
//address
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//commend
@property (weak, nonatomic) IBOutlet UIView *recommendBGView;
@property (weak, nonatomic) IBOutlet UIImageView *recommenderFaceImageView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
//description
@property (weak, nonatomic) IBOutlet UILabel *storeBriefLabel;
//nearby
@property (weak, nonatomic) IBOutlet UIView *nearbyBGView;
//brothers
//service
@property (weak, nonatomic) IBOutlet AUISegmentView *serviceLinearView;

@property (nonatomic, strong) UINib *titleCellNib;
@property (nonatomic, strong) UINib *activityCellNib;
@property (nonatomic, strong) UINib *couponCellNib;
@property (nonatomic, strong) UINib *hotRecommendCellNib;
@property (nonatomic, strong) UINib *commentCellNib;
@property (nonatomic, strong) UINib *brotherStoreCellNib;
@property (nonatomic, strong) UINib *serviceLinearCellNib;

@property (nonatomic, strong) StoreDetailModel *detailModel;

@property (nonatomic, strong) NSArray *sectionIdentifiersArray;

- (UITableViewCell *)createTableCellWithIdentifier:(NSString *)identifier forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

- (void)configTitleCell:(StoreDetailTitleCell *)cell WithSection:(StoreDetailViewSection)section;
- (void)configTopCell;
- (void)configRecommendCell;
- (void)configNearbyCell;
- (IBAction)didClickedCouponButton:(id)sender;

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
    if (!self.hotRecommendCellNib) {
        self.hotRecommendCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailHotRecommendCell class]) bundle:nil];
        [self.tableView registerNib:self.hotRecommendCellNib forCellReuseIdentifier:kHotRecommendCellIdentifier];
    }
    if (!self.commentCellNib) {
        self.commentCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailCommentCell class]) bundle:nil];
        [self.tableView registerNib:self.commentCellNib forCellReuseIdentifier:kCommentCellIdentifier];
    }
    if (!self.brotherStoreCellNib) {
        self.brotherStoreCellNib = [UINib nibWithNibName:NSStringFromClass([StoreListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.brotherStoreCellNib forCellReuseIdentifier:kBrotherStoreCellIdentifier];
    }
    if (!self.serviceLinearCellNib) {
        self.serviceLinearCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailServiceLinearCell class]) bundle:nil];
        [self.serviceLinearView registerNib:self.serviceLinearCellNib forCellReuseIdentifier:kServiceLinearCellIdentifier];
    }
    
    [self.serviceLinearView setScrollEnable:YES];
    [self.serviceLinearView setShowSeparator:NO];
    self.serviceLinearView.dataSource = self;
    self.serviceLinearView.delegate = self;
    
    [self.recommendCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    self.recommenderFaceImageView.layer.cornerRadius = 30;
    self.recommenderFaceImageView.layer.masksToBounds = YES;
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
        case StoreDetailViewSectionAddress:
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
        case StoreDetailViewSectionHotRecommend:
        {
            NSUInteger count = [self.detailModel.hotRecommendServiceArray count];
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
        case StoreDetailViewSectionBrief:
        {
            //include title
            if ([self.detailModel.storeBrief length] > 0) {
                number = 2;
            } else {
                number = 1;
            }
        }
            break;
        case StoreDetailViewSectionComment:
        {
//            NSUInteger count = [self.detailModel.commentItemsArray count];
//            if (count > 0) {
//                //include title
//                count ++;
//            }
            number = 2;
        }
            break;
        case StoreDetailViewSectionNearby:
        {
            //include title
            number = 2;
        }
            break;
        case StoreDetailViewSectionBrother:
        {
            //include title
            number = 2;
        }
            break;
        case StoreDetailViewSectionService:
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
        case StoreDetailViewSectionAddress:
        {
            cell = self.addressCell;
        }
            break;
        case StoreDetailViewSectionCoupon:
        {
            cell = [self createTableCellWithIdentifier:kCouponCellIdentifier forTableView:tableView atIndexPath:indexPath];
            [((StoreDetailViewCouponCell *)cell).descriptionLabel setText:self.detailModel.couponName];
        }
            break;
        case StoreDetailViewSectionActivity:
        {
            cell = [self createTableCellWithIdentifier:kActivityCellIdentifier forTableView:tableView atIndexPath:indexPath];
            [((StoreDetailViewActiveCell *)cell) configWithModel:[self.detailModel.activeModelsArray objectAtIndex:indexPath.row]];
        }
            break;
        case StoreDetailViewSectionHotRecommend:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionHotRecommend];
            } else {
                cell = [self createTableCellWithIdentifier:kHotRecommendCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [((StoreDetailHotRecommendCell *)cell) configWithModel:[self.detailModel.hotRecommendServiceArray objectAtIndex:indexPath.row - 1]];
            }
        }
            break;
        case StoreDetailViewSectionRecommend:
        {
            cell = self.recommendCell;
        }
            break;
        case StoreDetailViewSectionBrief:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionBrief];
            } else {
                cell = self.briefCell;
            }
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
        case StoreDetailViewSectionBrother:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionBrother];
            } else {
                cell = [self createTableCellWithIdentifier:kBrotherStoreCellIdentifier forTableView:tableView atIndexPath:indexPath];
                StoreListItemModel *model = [self.detailModel.brotherStores firstObject];
                [((StoreListViewCell *)cell) configWithItemModel:model];
            }
        }
            break;
        case StoreDetailViewSectionService:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionService];
            } else {
                cell = self.serviceLinearCell;
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
        case StoreDetailViewSectionAddress:
        {
            height = self.addressCell.frame.size.height;
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
        case StoreDetailViewSectionBrief:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = [self.detailModel briefCellHeight];
            }
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
        case StoreDetailViewSectionNearby:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = [self.detailModel nearbyCellHeight];
            }
        }
            break;
        case StoreDetailViewSectionBrother:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                StoreListItemModel *model = [self.detailModel.brotherStores objectAtIndex:indexPath.row - 1];
                height = [model cellHeight];
            }
        }
            break;
        case StoreDetailViewSectionService:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = [StoreDetailServiceLinearCell cellHeight];
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
            case StoreDetailViewSectionAddress:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedAddressOnStoreDetailView:)]) {
                    [self.delegate didClickedAddressOnStoreDetailView:self];
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
            case StoreDetailViewSectionBrief:
            {
                if (indexPath.row == 0 && [self.delegate respondsToSelector:@selector(didClickedMoreDetailOnStoreDetailView:)]) {
                    [self.delegate didClickedMoreDetailOnStoreDetailView:self];
                }
            }
                break;
            case StoreDetailViewSectionComment:
            {
                if (indexPath.row == 0) {
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
            case StoreDetailViewSectionBrother:
            {
                if ([self.delegate respondsToSelector:@selector(didClickedMoreBrothersStoreOnStoreDetailView:)]) {
                    [self.delegate didClickedMoreBrothersStoreOnStoreDetailView:self];
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
    return self.detailModel.bannerRatio * SCREEN_WIDTH;
}

#pragma mark AUISegmentViewDataSource, & AUISegmentViewDelegate

- (NSUInteger)numberOfCellsForSegmentView:(AUISegmentView *)segmentView {
    return [self.detailModel.serviceModelsArray count];
}

- (UITableViewCell *)segmentView:(AUISegmentView *)segmentView cellAtIndex:(NSUInteger)index {
    StoreDetailServiceLinearCell *cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailServiceLinearCell" owner:nil options:nil] objectAtIndex:0];
    [cell configWithModel:[self.detailModel.serviceModelsArray objectAtIndex:index]];
    return cell;
}

- (CGFloat)segmentView:(AUISegmentView *)segmentView cellWidthAtIndex:(NSUInteger)index {
    return (SCREEN_WIDTH - 10) / 1.6;
}

- (void)segmentView:(AUISegmentView *)segmentView didSelectedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeDetailView:didClickedServiceAtIndex:)]) {
        [self.delegate storeDetailView:self didClickedServiceAtIndex:index];
    }
}

#pragma mark StoreDetailCommentCellDelegate

- (void)storeDetailCommentCell:(StoreDetailCommentCell *)cell didClickedImageAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(storeDetailView:didClickedReviewAtIndex:)]) {
        [self.delegate storeDetailView:self didClickedReviewAtIndex:cell.indexPath.row - 1];
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
        if ([identifier isEqualToString:kHotRecommendCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailHotRecommendCell" owner:nil options:nil] objectAtIndex:0];
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
    [self.storeName setText:self.detailModel.storeName];
    
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
        case StoreDetailViewSectionHotRecommend:
        {
            [cell resetWithMainTitle:@"门店热推" subTitle:@"查看更多"];
        }
            break;
        case StoreDetailViewSectionBrief:
        {
            [cell resetWithMainTitle:@"门店简介" subTitle:@"详细信息"];
        }
            break;
        case StoreDetailViewSectionComment:
        {
            [cell resetWithMainTitle:@"用户评论" subTitle:@"查看更多"];
        }
            break;
        case StoreDetailViewSectionNearby:
        {
            [cell resetWithMainTitle:@"门店附近" subTitle:nil];
        }
            break;
        case StoreDetailViewSectionBrother:
        {
            [cell resetWithMainTitle:@"兄弟门店" subTitle:@"查看更多"];
        }
            break;
        case StoreDetailViewSectionService:
        {
            [cell resetWithMainTitle:@"门店服务" subTitle:nil];
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
    [self.nearbyBGView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    CGFloat gap = 0.5;
    CGFloat singleWidth = (SCREEN_WIDTH - gap * 2) / 3;
    CGFloat singleHeight = 30;
    
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
            if (index % 3 >= 2) {
                //换行
                xPosition = 0;
                yPosition += singleHeight;
                
                UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(xPosition + margin, yPosition, SCREEN_WIDTH - margin * 2, gap)];
                [gapView setBackgroundColor:gapColor];
                [bgView addSubview:gapView];
                
            } else {
                //行内
                xPosition += singleWidth;
                
                UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(xPosition, yPosition + margin, gap, imageSideLenght)];
                [gapView setBackgroundColor:gapColor];
                [bgView addSubview:gapView];
                
                xPosition += gap;
            }
        }
    }
}

- (IBAction)didClickedCouponButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCouponButtonOnStoreDetailView:)]) {
        [self.delegate didClickedCouponButtonOnStoreDetailView:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailModelForStoreDetailView:)]) {
        self.detailModel = [self.dataSource detailModelForStoreDetailView:self];
        if (self.detailModel) {
            NSMutableArray *tempSections = [[NSMutableArray alloc] init];
            [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionTop]];
            if ([self.detailModel.storeAddress length] > 0) {
                [self.addressLabel setText:self.detailModel.storeAddress];
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionAddress]];
            }
            if ([self.detailModel hasCoupon]) {
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionCoupon]];
            }
            if ([self.detailModel.activeModelsArray count] > 0) {
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionActivity]];
            }
            if ([self.detailModel.hotRecommendServiceArray count] > 0) {
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionHotRecommend]];
            }
            if ([self.detailModel.recommendString length] > 0) {
                [self configRecommendCell];
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionRecommend]];
            }
            if ([self.detailModel.storeBrief length] > 0) {
                [self.storeBriefLabel setText:self.detailModel.storeBrief];
            }
            [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionBrief]];
            [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionComment]];
            if ([self.detailModel.nearbyFacilities count] > 0) {
                [self configNearbyCell];
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionNearby]];
            }
            if ([self.detailModel.brotherStores count] > 0) {
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionBrother]];
            }
            if ([self.detailModel.serviceModelsArray count] > 0) {
                [self.serviceLinearView reloadData];
                [tempSections addObject:[NSNumber numberWithInteger:StoreDetailViewSectionService]];
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
