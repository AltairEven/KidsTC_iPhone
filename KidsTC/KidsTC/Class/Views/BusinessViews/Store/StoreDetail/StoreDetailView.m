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
#import "InsuranceView.h"
#import "StoreDetailViewActiveCell.h"
#import "StoreDetailViewServiceCell.h"
#import "StoreListViewCell.h"
#import "StoreDetailTitleCell.h"
#import "StoreDetailTuanCell.h"

#define BannerRatio (0.7)

typedef enum {
    StoreDetailViewSectionTop,
    StoreDetailViewSectionContact,
    StoreDetailViewSectionActive,
    StoreDetailViewSectionTuan,
    StoreDetailViewSectionService,
    StoreDetailViewSectionDescription,
    StoreDetailViewSectionBrother,
    StoreDetailViewSectionReview
}StoreDetailViewSection;

static NSString *const kActiveCellIdentifier = @"kActiveCellIdentifier";
static NSString *const kTuanCellIdentifier = @"kTuanCellIdentifier";
static NSString *const kServiceCellIdentifier = @"kServiceCellIdentifier";
static NSString *const kTitleCellIdentifier = @"kTitleCellIdentifier";
static NSString *const kListCellIdentifier = @"kListCellIdentifier";

@interface StoreDetailView () <UITableViewDataSource, UITableViewDelegate, AUIBannerScrollViewDataSource, StoreDetailViewServiceCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *topCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *telCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (strong, nonatomic) IBOutlet StoreDetailTitleCell *reviewCell;

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
//service
//description
@property (weak, nonatomic) IBOutlet UILabel *storeBriefLabel;
//brothers

@property (nonatomic, strong) UINib *activeCellNib;
@property (nonatomic, strong) UINib *tuanCellNib;
@property (nonatomic, strong) UINib *serviceCellNib;
@property (nonatomic, strong) UINib *titleCellNib;
@property (nonatomic, strong) UINib *listCellNib;

@property (nonatomic, strong) StoreDetailModel *detailModel;

- (UITableViewCell *)createTableCellWithIdentifier:(NSString *)identifier forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

- (void)configTopCell;
- (void)configTitleCell:(StoreDetailTitleCell *)cell WithSection:(StoreDetailViewSection)section;

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.bannerScrollView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    UIView *footBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.tableView.tableFooterView = footBG;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (!self.activeCellNib) {
        self.activeCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailViewActiveCell class]) bundle:nil];
        [self.tableView registerNib:self.activeCellNib forCellReuseIdentifier:kActiveCellIdentifier];
    }
    if (!self.tuanCellNib) {
        self.tuanCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailTuanCell class]) bundle:nil];
        [self.tableView registerNib:self.tuanCellNib forCellReuseIdentifier:kTuanCellIdentifier];
    }
    if (!self.serviceCellNib) {
        self.serviceCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailViewServiceCell class]) bundle:nil];
        [self.tableView registerNib:self.serviceCellNib forCellReuseIdentifier:kServiceCellIdentifier];
    }
    if (!self.titleCellNib) {
        self.titleCellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailTitleCell class]) bundle:nil];
        [self.tableView registerNib:self.titleCellNib forCellReuseIdentifier:kTitleCellIdentifier];
    }
    if (!self.listCellNib) {
        self.listCellNib = [UINib nibWithNibName:NSStringFromClass([StoreListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.listCellNib forCellReuseIdentifier:kListCellIdentifier];
    }
}

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailModelForStoreDetailView:)]) {
        self.detailModel = [self.dataSource detailModelForStoreDetailView:self];
        [self.tableView reloadData];
        [self.bannerScrollView reloadData];
    }
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return StoreDetailViewSectionReview + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger number = 0;
    switch (section) {
        case StoreDetailViewSectionTop:
        {
            number = 1;
        }
            break;
        case StoreDetailViewSectionContact:
        {
            number = 2;
        }
            break;
        case StoreDetailViewSectionActive:
        {
            number = [self.detailModel.activeModelsArray count];
        }
            break;
        case StoreDetailViewSectionTuan:
        {
            NSUInteger count = [self.detailModel.tuanModelsArray count];
            if (count > 0) {
                //include title
                count ++;
            }
            number = count;
        }
            break;
        case StoreDetailViewSectionService:
        {
            NSUInteger count = [self.detailModel.serviceModelsArray count] / 2;
            if (count > 0) {
                //include title
                count ++;
            }
            number = count;
        }
            break;
        case StoreDetailViewSectionDescription:
        {
            number = 2;
        }
            break;
        case StoreDetailViewSectionBrother:
        {
            number = 2;
        }
            break;
        case StoreDetailViewSectionReview:
        {
            number = 1;
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
    switch (indexPath.section) {
        case StoreDetailViewSectionTop:
        {
            [self configTopCell];
            cell = self.topCell;
        }
            break;
        case StoreDetailViewSectionContact:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self.telephoneLabel setText:self.detailModel.phoneNumber];
                    cell = self.telCell;
                }
                    break;
                case 1:
                {
                    [self.addressLabel setText:self.detailModel.storeAddress];
                    cell = self.addressCell;
                }
                default:
                    break;
            }
        }
            break;
        case StoreDetailViewSectionActive:
        {
            cell = [self createTableCellWithIdentifier:kActiveCellIdentifier forTableView:tableView atIndexPath:indexPath];
            [((StoreDetailViewActiveCell *)cell) configWithModel:[self.detailModel.activeModelsArray objectAtIndex:indexPath.row]];
        }
            break;
        case StoreDetailViewSectionTuan:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kActiveCellIdentifier forTableView:tableView atIndexPath:indexPath];
                ActiveModel *tuanModel = [[ActiveModel alloc] initWithType:ActiveTypeTuan AndDescription:@"团购"];
                [((StoreDetailViewActiveCell *)cell) configWithModel:tuanModel];
            } else {
                cell = [self createTableCellWithIdentifier:kTuanCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [((StoreDetailTuanCell *)cell) configWithModel:[self.detailModel.tuanModelsArray objectAtIndex:indexPath.row - 1]];
            }
        }
            break;
        case StoreDetailViewSectionService:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionService];
            } else {
                cell = [self createTableCellWithIdentifier:kServiceCellIdentifier forTableView:tableView atIndexPath:indexPath];
                NSUInteger itemIndex = indexPath.row - 1;
                ServiceListItemModel *leftModel = [self.detailModel.serviceModelsArray objectAtIndex:itemIndex * 2];
                ServiceListItemModel *rightModel = [self.detailModel.serviceModelsArray objectAtIndex:(itemIndex * 2) + 1];
                [((StoreDetailViewServiceCell *)cell) configWithLeftModel:leftModel rightModel:rightModel];
                ((StoreDetailViewServiceCell *)cell).index = itemIndex;
                ((StoreDetailViewServiceCell *)cell).delegate = self;
            }
        }
            break;
        case StoreDetailViewSectionDescription:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionDescription];
            } else {
                [self.storeBriefLabel setText:self.detailModel.storeBrief];
                cell = self.descriptionCell;
            }
        }
            break;
        case StoreDetailViewSectionBrother:
        {
            if (indexPath.row == 0) {
                cell = [self createTableCellWithIdentifier:kTitleCellIdentifier forTableView:tableView atIndexPath:indexPath];
                [self configTitleCell:(StoreDetailTitleCell *)cell WithSection:StoreDetailViewSectionBrother];
            } else {
                cell = [self createTableCellWithIdentifier:kListCellIdentifier forTableView:tableView atIndexPath:indexPath];
                StoreListItemModel *model = [self.detailModel.brotherStores firstObject];
                [((StoreListViewCell *)cell) configWithItemModel:model];
            }
        }
            break;
        case StoreDetailViewSectionReview:
        {
            cell = self.reviewCell;
        }
            break;
        default:
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case StoreDetailViewSectionTop:
        {
            height = [self heightForBannerScrollView:self.bannerScrollView] + 80;
        }
            break;
        case StoreDetailViewSectionContact:
        {
            height = self.telCell.frame.size.height;
        }
            break;
        case StoreDetailViewSectionActive:
        {
            height = [StoreDetailViewActiveCell cellHeight];
        }
            break;
        case StoreDetailViewSectionTuan:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = [StoreDetailTuanCell cellHeight];
            }
        }
            break;
        case StoreDetailViewSectionService:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = [StoreDetailViewServiceCell cellHeight];
            }
        }
            break;
        case StoreDetailViewSectionDescription:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = self.descriptionCell.frame.size.height;
            }
        }
            break;
        case StoreDetailViewSectionBrother:
        {
            if (indexPath.row == 0) {
                height = [StoreDetailTitleCell cellHeight];
            } else {
                height = [StoreListViewCell cellHeight];
            }
        }
            break;
        case StoreDetailViewSectionReview:
        {
            height = self.reviewCell.frame.size.height;
        }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    switch (section) {
        case StoreDetailViewSectionTop:
        {
            height = 0.01;
        }
        case StoreDetailViewSectionActive:
        {
            if ([self.detailModel.activeModelsArray count] > 0) {
                height = 2.5;
            } else {
                height = 0.01;
            }
        }
        case StoreDetailViewSectionTuan:
        {
            if ([self.detailModel.tuanModelsArray count] > 0) {
                height = 2.5;
            } else {
                height = 0.01;
            }
        }
            break;
        case StoreDetailViewSectionService:
        {
            if ([self.detailModel.serviceModelsArray count] > 0) {
                height = 2.5;
            } else {
                height = 0.01;
            }
        }
            break;
        default:
        {
            height = 2.5;
        }
            break;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0;
    switch (section) {
        case StoreDetailViewSectionActive:
        {
            if ([self.detailModel.activeModelsArray count] > 0) {
                height = 2.5;
            } else {
                height = 0.01;
            }
        }
        case StoreDetailViewSectionTuan:
        {
            if ([self.detailModel.tuanModelsArray count] > 0) {
                height = 2.5;
            } else {
                height = 0.01;
            }
        }
            break;
        case StoreDetailViewSectionService:
        {
            if ([self.detailModel.serviceModelsArray count] > 0) {
                height = 2.5;
            } else {
                height = 0.01;
            }
        }
            break;
        default:
        {
            height = 2.5;
        }
            break;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.delegate) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    switch (indexPath.section) {
        case StoreDetailViewSectionTop:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
            break;
        case StoreDetailViewSectionContact:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            switch (indexPath.row) {
                case 0:
                {
                    if ([self.delegate respondsToSelector:@selector(didClickedTelephoneOnStoreDetailView:)]) {
                        [self.delegate didClickedTelephoneOnStoreDetailView:self];
                    }
                }
                    break;
                case 1:
                {
                    if ([self.delegate respondsToSelector:@selector(didClickedAddressOnStoreDetailView:)]) {
                        [self.delegate didClickedAddressOnStoreDetailView:self];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case StoreDetailViewSectionActive:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
            break;
        case StoreDetailViewSectionTuan:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            if (indexPath.row == 0) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                if ([self.delegate respondsToSelector:@selector(didClickedAllTuanOnStoreDetailView:)]) {
                    [self.delegate didClickedAllTuanOnStoreDetailView:self];
                }
            } else {
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                if ([self.delegate respondsToSelector:@selector(storeDetailView:didSelectedTuanAtIndex:)]) {
                    [self.delegate storeDetailView:self didSelectedTuanAtIndex:indexPath.row - 1];
                }
                return;
            }
            return;
        }
            break;
        case StoreDetailViewSectionService:
        {
            if (indexPath.row == 0) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                if ([self.delegate respondsToSelector:@selector(didClickedAllServiceOnStoreDetailView:)]) {
                    [self.delegate didClickedAllServiceOnStoreDetailView:self];
                }
            } else {
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                return;
            }
        }
            break;
        case StoreDetailViewSectionDescription:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if ([self.delegate respondsToSelector:@selector(didClickedMoreDetailOnStoreDetailView:)]) {
                [self.delegate didClickedMoreDetailOnStoreDetailView:self];
            }
        }
            break;
        case StoreDetailViewSectionBrother:
        {
            if (indexPath.row == 0) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                if ([self.delegate respondsToSelector:@selector(didClickedMoreBrothersStoreOnStoreDetailView:)]) {
                    [self.delegate didClickedMoreBrothersStoreOnStoreDetailView:self];
                }
            } else {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                if ([self.delegate respondsToSelector:@selector(didClickedBrotherStoreOnStoreDetailView:)]) {
                    [self.delegate didClickedBrotherStoreOnStoreDetailView:self];
                }
            }
        }
            break;
        case StoreDetailViewSectionReview:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if ([self.delegate respondsToSelector:@selector(didClickedReviewOnStoreDetailView:)]) {
                [self.delegate didClickedReviewOnStoreDetailView:self];
            }
        }
            break;
        default:
            break;
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


#pragma mark StoreDetailViewServiceCellDelegate


- (void)storeDetailViewServiceCell:(StoreDetailViewServiceCell *)cell didClickedServiceAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeDetailView:didClickedServiceAtIndex:)]) {
        [self.delegate storeDetailView:self didClickedServiceAtIndex:index];
    }
}

#pragma mark Private method

- (UITableViewCell *)createTableCellWithIdentifier:(NSString *)identifier forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        if ([identifier isEqualToString:kActiveCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailViewActiveCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kTuanCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailTuanCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kServiceCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailViewServiceCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kTitleCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailTitleCell" owner:nil options:nil] objectAtIndex:0];
        }
        if ([identifier isEqualToString:kListCellIdentifier]) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreListViewCell" owner:nil options:nil] objectAtIndex:0];
        }
    }
    return cell;
}

- (void)configTopCell {
    [self.storeName setText:self.detailModel.storeName];
    
    [self.starView setStarNumber:self.detailModel.starNumber];
    
    [self.appointmentLabel setText:[NSString stringWithFormat:@"已有%lu人预约", (unsigned long)(self.detailModel.appointmentNumber)]];
    [self.appointmentLabel sizeOfSizeToFitWithMaximumNumberOfLines:1];
    
    [self.reviewLabel setText:[NSString stringWithFormat:@"%lu人评价", (unsigned long)(self.detailModel.commentNumber)]];
    [self.reviewLabel sizeOfSizeToFitWithMaximumNumberOfLines:1];
    
    [self.topCell layoutIfNeeded];
}

- (void)configTitleCell:(StoreDetailTitleCell *)cell WithSection:(StoreDetailViewSection)section {
    switch (section) {
        case StoreDetailViewSectionService:
        {
            [cell resetWithMainTitle:@"门店服务" subTitle:@"全部服务"];
        }
            break;
        case StoreDetailViewSectionDescription:
        {
            [cell resetWithMainTitle:@"门店简介" subTitle:@"详细信息"];
        }
            break;
        case StoreDetailViewSectionBrother:
        {
            [cell resetWithMainTitle:@"兄弟门店" subTitle:@"查看更多"];
        }
            break;
        default:
            break;
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
