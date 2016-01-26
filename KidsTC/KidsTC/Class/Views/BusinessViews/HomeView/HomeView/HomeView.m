//
//  HomeView.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeView.h"
#import "HomeTopView.h"
#import "TwinklingElvesView.h"
#import "HomeViewNormalTitleCell.h"
#import "HomeViewCountDownTitleCell.h"
#import "HomeViewMoreTitleCell.h"
#import "HomeViewCountDownMoreTitleCell.h"
#import "HomeViewBannerCell.h"
#import "HomeViewThreeCell.h"
#import "HomeViewThemeCell.h"
#import "HomeViewTwinklingElfCell.h"
#import "HomeViewHorizontalListCell.h"
#import "HomeViewNewsCell.h"
#import "HomeViewImageNewsCell.h"
#import "HomeViewThreeImageNewsCell.h"
#import "HomeViewWholeImageNewsCell.h"
#import "HomeViewNoticeCell.h"
#import "HomeViewBigImageTwoDescCell.h"
#import "HomeViewTwoThreeFourCell.h"
#import "HomeViewRecommendCell.h"
#import "HomeViewRecommendNewCell.h"

static NSString *const kNormalTitleCellIdentifier = @"kNormalTitleCellIdentifier";
static NSString *const kCountDownTitleCellIdentifier = @"kCountDownTitleCellIdentifier";
static NSString *const kMoreTitleCellIdentifier = @"kMoreTitleCellIdentifier";
static NSString *const kCountDownMoreTitleCellIdentifier = @"kCountDownMoreTitleCellIdentifier";
static NSString *const kBannerCellIdentifier = @"kBannerCellIdentifier";
static NSString *const kThreeCellIdentifier = @"kThreeCellIdentifier";
static NSString *const kThemeCellIdentifier = @"kThemeCellIdentifier";
static NSString *const kTwinklingElfCellIdentifier = @"kTwinklingElfCellIdentifier";
static NSString *const kHorizontalListCellIdentifier = @"kHorizontalListCellIdentifier";
static NSString *const kNewsCellIdentifier = @"kNewsCellIdentifier";
static NSString *const kImageNewsCellIdentifier = @"kImageNewsCellIdentifier";
static NSString *const kThreeImageNewsCellIdentifier = @"kThreeImageNewsCellIdentifier";
static NSString *const kWholeImageNewsCellIdentifier = @"kWholeImageNewsCellIdentifier";
static NSString *const kNoticeCellIdentifier = @"kNoticeCellIdentifier";
static NSString *const kBigImageTwoDescCellIdentifier = @"kBigImageTwoDescCellIdentifier";
static NSString *const kTwoThreeFourCellIdentifier = @"kTwoThreeFourCellIdentifier";
static NSString *const kRecommendCellIdentifier = @"kRecommendCellIdentifier";
static NSString *const kRecommendNewCellIdentifier = @"kRecommendNewCellIdentifier";

@interface HomeView () <HomeTopViewDelegate, UITableViewDataSource, UITableViewDelegate, HomeViewBannerCellDelegate, HomeViewThemeCellDelegate, HomeViewThreeCellDelegate, HomeViewTwinklingElfCellDelegate, HomeViewHorizontalListCellDelegate, UIScrollViewDelegate, HomeViewThreeImageNewsCellDelegate, HomeViewWholeImageNewsCellDelegate, HomeViewNoticeCellDelegate, HomeViewBigImageTwoDescCellDelegate, HomeViewTwoThreeFourCellDelegate, HomeViewRecommendCellDelegate>

//top
@property (weak, nonatomic) IBOutlet HomeTopView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *bannerImageUrls;
@property (nonatomic, strong) NSArray *twinklingElfModels;

@property (nonatomic, strong) UINib *normalTitleCellNib;
@property (nonatomic, strong) UINib *countDownTitleCellNib;
@property (nonatomic, strong) UINib *moreTitleCellNib;
@property (nonatomic, strong) UINib *countDownMoreTitleCellNib;
@property (nonatomic, strong) UINib *bannerCellNib;
@property (nonatomic, strong) UINib *threeCellNib;
@property (nonatomic, strong) UINib *themeCellNib;
@property (nonatomic, strong) UINib *twinklingElfCellNib;
@property (nonatomic, strong) UINib *horizontalListCellNib;
@property (nonatomic, strong) UINib *newsCellNib;
@property (nonatomic, strong) UINib *imageNewsCellNib;
@property (nonatomic, strong) UINib *threeImageNewsCellNib;
@property (nonatomic, strong) UINib *wholeImageNewsCellNib;
@property (nonatomic, strong) UINib *noticeCellNib;
@property (nonatomic, strong) UINib *bigImageTwoDescCellNib;
@property (nonatomic, strong) UINib *twoThreeFourCellNib;
@property (nonatomic, strong) UINib *recommendCellNib;
@property (nonatomic, strong) UINib *recommendNewCellNib;

@property (nonatomic, strong) UIView *splitFooterView;
@property (weak, nonatomic) IBOutlet UIButton *backToTopButton;

@property (nonatomic, strong) NSMutableDictionary *cellModelsDic;

@property (nonatomic, strong) HomeModel *homeModel;

@property (nonatomic, strong) NSArray *customerRecommendModels;

@property (nonatomic, strong) NSArray *totalSectionModels;

@property (nonatomic, assign) BOOL noMoreData;

@property (nonatomic, strong) NSMutableDictionary *countDownCells;

- (void)pullToRefreshTable;

- (void)pullToLoadMoreData;

- (IBAction)didClickedBackToTop:(id)sender;

- (NSUInteger)floorIndexAtCurrentScrollingPoint;

- (CGPoint)offsetFromFloorIndex:(NSUInteger)index;

@end

@implementation HomeView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        HomeView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.topView.delegate = self;
    [self.topView setBackgroundColor:[[KTCThemeManager manager] currentTheme].navibarBGColor];
    
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if (!self.normalTitleCellNib) {
        self.normalTitleCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewNormalTitleCell class]) bundle:nil];
        [self.tableView registerNib:self.normalTitleCellNib forCellReuseIdentifier:kNormalTitleCellIdentifier];
    }
    if (!self.countDownTitleCellNib) {
        self.countDownTitleCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewCountDownTitleCell class]) bundle:nil];
        [self.tableView registerNib:self.countDownTitleCellNib forCellReuseIdentifier:kCountDownTitleCellIdentifier];
    }
    if (!self.moreTitleCellNib) {
        self.moreTitleCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewMoreTitleCell class]) bundle:nil];
        [self.tableView registerNib:self.moreTitleCellNib forCellReuseIdentifier:kMoreTitleCellIdentifier];
    }
    if (!self.countDownMoreTitleCellNib) {
        self.countDownMoreTitleCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewCountDownMoreTitleCell class]) bundle:nil];
        [self.tableView registerNib:self.countDownMoreTitleCellNib forCellReuseIdentifier:kCountDownMoreTitleCellIdentifier];
    }
    if (!self.bannerCellNib) {
        self.bannerCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewBannerCell class]) bundle:nil];
        [self.tableView registerNib:self.bannerCellNib forCellReuseIdentifier:kBannerCellIdentifier];
    }
    if (!self.threeCellNib) {
        self.threeCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewThreeCell class]) bundle:nil];
        [self.tableView registerNib:self.threeCellNib forCellReuseIdentifier:kThreeCellIdentifier];
    }
    if (!self.themeCellNib) {
        self.themeCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewThemeCell class]) bundle:nil];
        [self.tableView registerNib:self.themeCellNib forCellReuseIdentifier:kThemeCellIdentifier];
    }
    if (!self.twinklingElfCellNib) {
        self.twinklingElfCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewTwinklingElfCell class]) bundle:nil];
        [self.tableView registerNib:self.twinklingElfCellNib forCellReuseIdentifier:kTwinklingElfCellIdentifier];
    }
    if (!self.horizontalListCellNib) {
        self.horizontalListCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewHorizontalListCell class]) bundle:nil];
        [self.tableView registerNib:self.horizontalListCellNib forCellReuseIdentifier:kHorizontalListCellIdentifier];
    }
    if (!self.newsCellNib) {
        self.newsCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewNewsCell class]) bundle:nil];
        [self.tableView registerNib:self.newsCellNib forCellReuseIdentifier:kNewsCellIdentifier];
    }
    if (!self.imageNewsCellNib) {
        self.imageNewsCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewImageNewsCell class]) bundle:nil];
        [self.tableView registerNib:self.imageNewsCellNib forCellReuseIdentifier:kImageNewsCellIdentifier];
    }
    if (!self.threeImageNewsCellNib) {
        self.threeImageNewsCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewThreeImageNewsCell class]) bundle:nil];
        [self.tableView registerNib:self.threeImageNewsCellNib forCellReuseIdentifier:kThreeImageNewsCellIdentifier];
    }
    if (!self.wholeImageNewsCellNib) {
        self.wholeImageNewsCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewWholeImageNewsCell class]) bundle:nil];
        [self.tableView registerNib:self.wholeImageNewsCellNib forCellReuseIdentifier:kWholeImageNewsCellIdentifier];
    }
    if (!self.noticeCellNib) {
        self.noticeCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewNoticeCell class]) bundle:nil];
        [self.tableView registerNib:self.noticeCellNib forCellReuseIdentifier:kNoticeCellIdentifier];
    }
    if (!self.bigImageTwoDescCellNib) {
        self.bigImageTwoDescCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewBigImageTwoDescCell class]) bundle:nil];
        [self.tableView registerNib:self.bigImageTwoDescCellNib forCellReuseIdentifier:kBigImageTwoDescCellIdentifier];
    }
    if (!self.twoThreeFourCellNib) {
        self.twoThreeFourCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewTwoThreeFourCell class]) bundle:nil];
        [self.tableView registerNib:self.twoThreeFourCellNib forCellReuseIdentifier:kTwoThreeFourCellIdentifier];
    }
    if (!self.recommendNewCellNib) {
        self.recommendNewCellNib = [UINib nibWithNibName:NSStringFromClass([HomeViewRecommendNewCell class]) bundle:nil];
        [self.tableView registerNib:self.recommendNewCellNib forCellReuseIdentifier:kRecommendNewCellIdentifier];
    }
    
    self.cellModelsDic = [[NSMutableDictionary alloc] init];
    
    __weak HomeView *weakSelf = self;
    [self.tableView addGifHeaderWithRefreshingBlock:^{
        [weakSelf pullToRefreshTable];
    }];
    [self.tableView addGifFooterWithRefreshingBlock:^{
        if (weakSelf.noMoreData) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        [weakSelf pullToLoadMoreData];
    }];
    [self hideLoadMoreFooter:YES];
    
    self.backToTopButton.layer.cornerRadius = 20;
    self.backToTopButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backToTopButton.layer.borderWidth = 2;
    self.backToTopButton.layer.masksToBounds = YES;
    [self.backToTopButton setHidden:YES];
    
    
    self.countDownCells = [[NSMutableDictionary alloc] init];
}


#pragma mark HomeTopViewDelegate

- (void)didTouchedCategoryButtonOnHomeTopView:(HomeTopView *)topView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCategoryButtonOnHomeView:)]) {
        [self.delegate didClickedCategoryButtonOnHomeView:self];
    }
}

- (void)didTouchedInputFieldOnHomeTopView:(HomeTopView *)topView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedInputFieldOnHomeView:)]) {
        [self.delegate didClickedInputFieldOnHomeView:self];
    }
}

- (void)didTouchedRoleButtonOnHomeTopView:(HomeTopView *)topView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedRoleButtonOnHomeView:)]) {
        [self.delegate didClickedRoleButtonOnHomeView:self];
    }
}


#pragma mark HomeViewBannerCellDelegate

- (void)homeViewBannerCell:(HomeViewBannerCell *)bannerCell didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:bannerCell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, bannerCell.indexPath.section, NO, index)];
    }
}


#pragma mark HomeViewThemeCellDelegate

- (void)homeViewThemeCell:(HomeViewThemeCell *)themeCell didSelectedItemAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:themeCell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, themeCell.indexPath.section, NO, index)];
    }
}


#pragma mark HomeViewThreeCellDelegate

- (void)homeViewThreeCell:(HomeViewThreeCell *)cell didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:cell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, cell.indexPath.section, NO, index)];
    }
}


#pragma mark HomeViewTwinklingElfCellDelegate

- (void)twinklingElfCell:(HomeViewTwinklingElfCell *)twinklingElfCell didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:twinklingElfCell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, twinklingElfCell.indexPath.section, NO, index)];
    }
}

#pragma mark HomeViewHorizontalListCellDelegate

- (void)homeViewHorizontalListCell:(HomeViewHorizontalListCell *)listCell didSelectedItemAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:listCell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, listCell.indexPath.section, NO, index)];
    }
}

#pragma mark HomeViewThreeImageNewsCellDelegate

- (void)homeViewThreeImageNewsCell:(HomeViewThreeImageNewsCell *)cell didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:cell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, cell.indexPath.section, NO, index)];
    }
}

#pragma mark HomeViewWholeImageNewsCellDelegate

- (void)homeViewWholeImageNewsCell:(HomeViewWholeImageNewsCell *)newsCell didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:newsCell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, newsCell.indexPath.section, NO, index)];
    }
}

#pragma mark HomeViewNoticeCellDelegate

- (void)homeNoticeCell:(HomeViewNoticeCell *)cell didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:cell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, cell.indexPath.section, NO, index)];
    }
}

#pragma mark HomeViewBigImageTwoDescCellDelegate

- (void)bigImageTwoDescCell:(HomeViewBigImageTwoDescCell *)cell didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:cell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, cell.indexPath.section, NO, index)];
    }
}

#pragma mark HomeViewTwoThreeFourCellDelegate

- (void)homeCell:(HomeViewTwoThreeFourCell *)cell didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:cell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, cell.indexPath.section, NO, index)];
    }
}

#pragma mark HomeViewRecommendCellDelegate

- (void)homeViewRecommendCell:(HomeViewRecommendCell *)recommendCell didSelectedItemAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:recommendCell.indexPath.section];
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, recommendCell.indexPath.section, NO, index)];
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.totalSectionModels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger number = 1;
    HomeSectionModel *model = [self.totalSectionModels objectAtIndex:section];
    if (model.hasTitle) {
        number = 2;
    }
    if (model.contentModel.type == HomeContentCellTypeNews) {
        number += [((HomeNewsCellModel *)model.contentModel).elementsArray count] - 1;
    } else if (model.contentModel.type == HomeContentCellTypeImageNews) {
        number += [((HomeImageNewsCellModel *)model.contentModel).elementsArray count] - 1;
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
    HomeSectionModel *model = [self.totalSectionModels objectAtIndex:indexPath.section];
    NSUInteger itemIndex = indexPath.row;
    if (model.hasTitle) {
        if (itemIndex == 0) {
            switch (model.titleModel.type) {
                case HomeTitleCellTypeNormalTitle:
                {
                    HomeViewNormalTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalTitleCellIdentifier];
                    if (!cell) {
                        cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewNormalTitleCell" owner:nil options:nil] objectAtIndex:0];
                    }
                    [cell configWithModel:(HomeNormalTitleCellModel *)model.titleModel];
                    return cell;
                }
                    break;
                case HomeTitleCellTypeCountDownTitle:
                {
                    HomeViewCountDownTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountDownTitleCellIdentifier];
                    if (!cell) {
                        cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewCountDownTitleCell" owner:nil options:nil] objectAtIndex:0];
                    }
                    [cell configWithModel:(HomeCountDownTitleCellModel *)model.titleModel];
                    [self.countDownCells setObject:cell forKey:indexPath];
                    return cell;
                }
                    break;
                case HomeTitleCellTypeMoreTitle:
                {
                    HomeViewMoreTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kMoreTitleCellIdentifier];
                    if (!cell) {
                        cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewMoreTitleCell" owner:nil options:nil] objectAtIndex:0];
                    }
                    [cell configWithModel:(HomeMoreTitleCellModel *)model.titleModel];
                    return cell;
                }
                    break;
                case HomeTitleCellTypeCountDownMoreTitle:
                {
                    HomeViewCountDownMoreTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountDownMoreTitleCellIdentifier];
                    if (!cell) {
                        cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewCountDownMoreTitleCell" owner:nil options:nil] objectAtIndex:0];
                    }
                    [cell configWithModel:(HomeCountDownMoreTitleCellModel *)model.titleModel];
                    [self.countDownCells setObject:cell forKey:indexPath];
                    return cell;
                }
                    break;
                default:
                    break;
            }
        } else {
            itemIndex = indexPath.row - 1;
        }
    }
    
    HomeContentCellModel *contentModel = model.contentModel;
    switch (contentModel.type) {
        case HomeContentCellTypeBanner:
        {
            HomeViewBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:kBannerCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewBannerCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithModel:(HomeBannerCellModel *)contentModel];
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
        }
            break;
        case HomeContentCellTypeTwinklingElf:
        {
            HomeViewTwinklingElfCell *cell = [tableView dequeueReusableCellWithIdentifier:kTwinklingElfCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewTwinklingElfCell" owner:nil options:nil] objectAtIndex:0];
            }
            
            [cell configWithModel:(HomeTwinklingElfCellModel *)contentModel];
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
        }
            break;
        case HomeContentCellTypeHorizontalList:
        {
            HomeViewHorizontalListCell *cell = [tableView dequeueReusableCellWithIdentifier:kHorizontalListCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewHorizontalListCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithModel:(HomeHorizontalListCellModel *)contentModel];
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
        }
            break;
        case HomeContentCellTypeThree:
        {
            HomeViewThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:kThreeCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewThreeCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithModel:(HomeThreeCellModel *)contentModel];
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
        }
            break;
        case HomeContentCellTypeTwoColumn:
        {
            HomeViewThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:kThemeCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewThemeCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithModel:(HomeTwoColumnCellModel *)contentModel];
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
        }
            break;
        case HomeContentCellTypeNews:
        {
            HomeViewNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewNewsCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithModel:[((HomeNewsCellModel *)contentModel).elementsArray objectAtIndex:itemIndex]];
            cell.indexPath = indexPath;
            return cell;
        }
            break;
        case HomeContentCellTypeImageNews:
        {
            HomeViewImageNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kImageNewsCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewImageNewsCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithModel:[((HomeImageNewsCellModel *)contentModel).elementsArray objectAtIndex:itemIndex]];
            cell.indexPath = indexPath;
            return cell;
        }
            break;
        case HomeContentCellTypeThreeImageNews:
        {
            HomeViewThreeImageNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kThreeImageNewsCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewThreeImageNewsCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithModel:(HomeThreeImageNewsCellModel *)contentModel];
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
        }
            break;
        case HomeContentCellTypeWholeImageNews:
        {
            HomeViewWholeImageNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kWholeImageNewsCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewWholeImageNewsCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithModel:(HomeWholeImageNewsCellModel *)contentModel];
            cell.delegate = self;
            cell.indexPath = indexPath;
            return cell;
        }
            break;
        case HomeContentCellTypeNotice:
        {
            HomeViewNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoticeCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewNoticeCell" owner:nil options:nil] objectAtIndex:0];
            }
            
            cell.indexPath = indexPath;
            cell.delegate = self;
            [cell configWithModel:(HomeNoticeCellModel *)contentModel];
            
            return cell;
        }
            break;
        case HomeContentCellTypeBigImageTwoDesc:
        {
            HomeViewBigImageTwoDescCell *cell = [tableView dequeueReusableCellWithIdentifier:kBigImageTwoDescCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewBigImageTwoDescCell" owner:nil options:nil] objectAtIndex:0];
            }
            
            cell.indexPath = indexPath;
            cell.delegate = self;
            [cell configWithCellModel:(HomeBigImageTwoDescCellModel *)contentModel];
            
            return cell;
        }
            break;
        case HomeContentCellTypeTwoThreeFour:
        {
            HomeViewTwoThreeFourCell *cell = [tableView dequeueReusableCellWithIdentifier:kTwoThreeFourCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewTwoThreeFourCell" owner:nil options:nil] objectAtIndex:0];
            }
            
            cell.indexPath = indexPath;
            cell.delegate = self;
            [cell configWithCellModel:(HomeTwoThreeFourCellModel *)contentModel];
            
            return cell;
        }
            break;
        case HomeContentCellTypeRecommend:
        {
            HomeViewRecommendNewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecommendNewCellIdentifier];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewRecommendNewCell" owner:nil options:nil] objectAtIndex:0];
            }
            
            HomeRecommendElement *element = [[(HomeRecommendCellModel *)contentModel recommendElementsArray] firstObject];
            [cell configWithModel:element];
            
            return cell;
        }
            break;
        default:
            break;
    }

    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    HomeSectionModel *model = [self.totalSectionModels objectAtIndex:indexPath.section];
    if (model.hasTitle && indexPath.row == 0) {
        height = [model.titleModel cellHeight];
    } else {
        height = [model.contentModel cellHeight];
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.01;
    HomeSectionModel *model = [self.totalSectionModels objectAtIndex:section];
    if (model.marginTop >= 1) {
        height = model.marginTop;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01;
    if ([[self.homeModel allSectionModels] count] == section + 1) {
        height = 40;
    }
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([[self.homeModel allSectionModels] count] != section + 1) {
        return nil;
    }
    if (!self.splitFooterView) {
        CGFloat lableWidth = 80;
        CGFloat viewHeight = 40;
        self.splitFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
        UILabel *splitLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 2) - (lableWidth / 2), 0, lableWidth, viewHeight)];
        [splitLabel setFont:[UIFont systemFontOfSize:13]];
        [splitLabel setTextAlignment:NSTextAlignmentCenter];
        [splitLabel setTextColor:[UIColor lightGrayColor]];
        [splitLabel setText:@"为您推荐"];
        [self.splitFooterView addSubview:splitLabel];
        
        CGFloat margin = 5;
        CGFloat lineWidth = (SCREEN_WIDTH - lableWidth - margin * 2) / 2;
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(margin, viewHeight / 2, lineWidth, 1)];
        [leftLine setBackgroundColor:[UIColor lightGrayColor]];
        [self.splitFooterView addSubview:leftLine];
        CGFloat xPosition =SCREEN_WIDTH / 2 + lableWidth / 2 + margin;
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(xPosition, viewHeight / 2, lineWidth, 1)];
        [rightLine setBackgroundColor:[UIColor lightGrayColor]];
        [self.splitFooterView addSubview:rightLine];
    }
    
    return self.splitFooterView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didClickedAtCoordinate:)]) {
        HomeSectionModel *model = [self.totalSectionModels objectAtIndex:indexPath.section];
        BOOL isTitle = NO;
        NSUInteger index = indexPath.row;
        if (indexPath.row > 0) {
            if (model.hasTitle) {
                index --;
            }
        } else {
            isTitle = model.hasTitle;
        }
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, indexPath.section, isTitle, index)];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.contentOffset.y > SCREEN_HEIGHT) {
        [self.backToTopButton setHidden:NO];
    } else {
        [self.backToTopButton setHidden:YES];
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(homeView:didScrolled:)] && self.tableView.contentOffset.y > 0) {
            [self.delegate homeView:self didScrolled:self.tableView.contentOffset];
        }
        if ([self.delegate respondsToSelector:@selector(homeView:didScrolledIntoVisionWithFloorIndex:)]) {
            [self.delegate homeView:self didScrolledIntoVisionWithFloorIndex:[self floorIndexAtCurrentScrollingPoint]];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeView:didEndDeDidEndDecelerating:)]) {
        if (self.tableView.contentOffset.y < 100) {
            [self.delegate homeView:self didEndDeDidEndDecelerating:YES];
        } else {
            [self.delegate homeView:self didEndDeDidEndDecelerating:NO];
        }
    }
}

#pragma mark Private Methods

- (void)pullToRefreshTable {
    self.tableView.backgroundView = nil;
    [self.tableView.mj_footer resetNoMoreData];
    self.noMoreData = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewDidPulledDownToRefresh:)]) {
        [self.delegate homeViewDidPulledDownToRefresh:self];
    }
}

- (void)pullToLoadMoreData {
    self.tableView.backgroundView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewDidPulledUpToloadMore:)]) {
        [self.delegate homeViewDidPulledUpToloadMore:self];
    }
}

- (IBAction)didClickedBackToTop:(id)sender {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSUInteger)floorIndexAtCurrentScrollingPoint {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, self.tableView.contentOffset.y + (SCREEN_HEIGHT - 49 - 64) - 100)];
    if (!indexPath) {
        return 0;
    }
    NSUInteger index = 0;
    if (indexPath.section < [self.homeModel.allSectionModels count]) {
        HomeSectionModel *sectionModel = [self.homeModel.allSectionModels objectAtIndex:indexPath.section];
        index = sectionModel.floorIndex;
    } else {
        index = [self.homeModel.allSectionModels count] - 1;
    }
    return index;
}

- (CGPoint)offsetFromFloorIndex:(NSUInteger)index {
    NSUInteger section = 0;
    for (NSUInteger floorIndex = 0; floorIndex < self.homeModel.floorCount; floorIndex ++) {
        HomeFloorModel *floorModel = [self.homeModel.floorModels objectAtIndex:floorIndex];
        if (floorIndex < index) {
            section += [floorModel.sectionModels count];
        } else {
            break;
        }
    }
    CGRect area = [self.tableView rectForSection:section];
    CGFloat yOffset = self.tableView.contentOffset.y + area.origin.y - self.tableView.contentOffset.y - (SCREEN_HEIGHT - 49 - 64) + area.size.height;
    if (yOffset < 0) {
        yOffset = 0;
    } else if (yOffset > self.tableView.contentSize.height) {
        yOffset = self.tableView.contentSize.height;
    }
    CGPoint offsetNew = CGPointMake(self.tableView.contentOffset.x, yOffset);
    return offsetNew;
}

#pragma mark Public Methods

- (void)reloadData {
    for (UITableViewCell *cell in [self.countDownCells allValues]) {
        if ([cell isKindOfClass:[HomeViewCountDownTitleCell class]]) {
            [(HomeViewCountDownTitleCell *)cell stopCountDown];
        }
        if ([cell isKindOfClass:[HomeViewCountDownMoreTitleCell class]]) {
            [(HomeViewCountDownMoreTitleCell *)cell stopCountDown];
        }
    }
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(homeModelForHomeView:)]) {
            self.homeModel= [self.dataSource homeModelForHomeView:self];
        }
        if ([self.dataSource respondsToSelector:@selector(customerRecommendModesArrayForHomeView:)]) {
            self.customerRecommendModels = [self.dataSource customerRecommendModesArrayForHomeView:self];
        }
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[self.homeModel allSectionModels]];
        [array addObjectsFromArray:self.customerRecommendModels];
        self.totalSectionModels = [NSArray arrayWithArray:array];
        [self.tableView reloadData];
    }
    if ([self.totalSectionModels count] == 0) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
    }
}

- (void)startRefresh {
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)startLoadMore {
    [self.tableView.mj_footer beginRefreshing];
}

- (void)endLoadMore {
    [self.tableView.mj_footer endRefreshing];
}

- (void)noMoreData:(BOOL)noMore {
    if (noMore) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
    self.noMoreData = noMore;
}

- (void)hideLoadMoreFooter:(BOOL)hidden {
    [self.tableView.mj_footer setHidden:hidden];
}

- (void)scrollHomeViewToFloorIndex:(NSUInteger)index {
    CGPoint offset = [self offsetFromFloorIndex:index];
    [self.tableView setContentOffset:offset animated:YES];
}

- (void)resetTopRoleWithImage:(UIImage *)image {
    [self.topView setRoleWithImage:image];
}

- (void)resetTopRoleWithTitle:(NSString *)title {
    [self.topView setRoleWithTitle:title];
}

- (void)resetTopViewWithBGColor:(UIColor *)bgColor {
    [self.topView setBackgroundColor:bgColor];
}

- (void)resetTopViewWithInputContent:(NSString *)content isPlaceHolder:(BOOL)isPlaceHolder {
    [self.topView resetInputFieldContent:content isPlaceHolder:isPlaceHolder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
