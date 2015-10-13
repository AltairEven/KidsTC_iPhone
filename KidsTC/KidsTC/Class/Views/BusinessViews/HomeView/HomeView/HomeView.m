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

@interface HomeView () <HomeTopViewDelegate, UITableViewDataSource, UITableViewDelegate, HomeViewBannerCellDelegate, HomeViewThemeCellDelegate, HomeViewThreeCellDelegate, HomeViewTwinklingElfCellDelegate, HomeViewHorizontalListCellDelegate, UIScrollViewDelegate>

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

@property (nonatomic, strong) UIView *splitFooterView;
@property (weak, nonatomic) IBOutlet UIButton *backToTopButton;

@property (nonatomic, strong) NSMutableDictionary *cellModelsDic;

@property (nonatomic, strong) HomeModel *homeModel;

@property (nonatomic, strong) HomeModel *customerRecommendModel;

@property (nonatomic, strong) NSArray *totalSectionModels;

@property (nonatomic, assign) BOOL noMoreData;

- (void)pullToRefreshTable;

- (void)pullToLoadMoreData;

- (IBAction)didClickedBackToTop:(id)sender;

- (NSIndexPath *)indexPathAtCurrentScrollingPoint;

- (CGPoint)offsetFromSectionGroupIndex:(NSUInteger)index;

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
    [self.topView setBackgroundColor:[AUITheme theme].navibarBGColor];
    
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
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
    
    self.cellModelsDic = [[NSMutableDictionary alloc] init];
    
    __weak HomeView *weakSelf = self;
    [self.tableView addRefreshViewHeaderWithRefreshingBlock:^{
        [weakSelf pullToRefreshTable];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        if (weakSelf.noMoreData) {
            [weakSelf.tableView.legendFooter noticeNoMoreData];
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

- (void)didTouchedMessageButtonOnHomeTopView:(HomeTopView *)topView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedMessageButtonOnHomeView:)]) {
        [self.delegate didClickedMessageButtonOnHomeView:self];
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
    if (model.hasTitle && indexPath.row == 0) {
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
                HomeViewCountDownMoreTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kMoreTitleCellIdentifier];
                if (!cell) {
                    cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeViewCountDownMoreTitleCell" owner:nil options:nil] objectAtIndex:0];
                }
                [cell configWithModel:(HomeCountDownMoreTitleCellModel *)model.titleModel];
                return cell;
            }
                break;
            default:
                break;
        }
    } else {
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
                [cell configWithModel:[((HomeNewsCellModel *)contentModel).elementsArray objectAtIndex:indexPath.row]];
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
                [cell configWithModel:[((HomeImageNewsCellModel *)contentModel).elementsArray objectAtIndex:indexPath.row]];
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
                cell.indexPath = indexPath;
                return cell;
            }
                break;
            default:
                break;
        }
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
        if (model.hasTitle && indexPath.row == 0) {
            isTitle = YES;
        }
        [self.delegate homeView:self didClickedAtCoordinate:HomeClickMakeCoordinate(model.floorIndex, indexPath.section, isTitle, indexPath.row)];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.contentOffset.y > 100) {
        [self.backToTopButton setHidden:NO];
    } else {
        [self.backToTopButton setHidden:YES];
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(homeView:didScrolled:)] && self.tableView.contentOffset.y > 0) {
            [self.delegate homeView:self didScrolled:self.tableView.contentOffset];
        }
        NSIndexPath *indexPath = [self indexPathAtCurrentScrollingPoint];
        if (indexPath.section > 1) {
            NSUInteger index = indexPath.section - 2;
            if ([self.delegate respondsToSelector:@selector(homeView:didScrolledIntoVisionWithSectionGroupIndex:)]) {
                [self.delegate homeView:self didScrolledIntoVisionWithSectionGroupIndex:index];
            }
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
    [self.tableView.gifFooter resetNoMoreData];
    self.noMoreData = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewDidPulledDownToRefresh:)]) {
        [self.delegate homeViewDidPulledDownToRefresh:self];
    }
}

- (void)pullToLoadMoreData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewDidPulledUpToloadMore:)]) {
        [self.delegate homeViewDidPulledUpToloadMore:self];
    }
}

- (IBAction)didClickedBackToTop:(id)sender {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSIndexPath *)indexPathAtCurrentScrollingPoint {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, self.tableView.contentOffset.y + (SCREEN_HEIGHT - 49 - 64) - 100)];
    return indexPath;
}

- (CGPoint)offsetFromSectionGroupIndex:(NSUInteger)index {
    NSUInteger section = index + 2;
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
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(homeModelForHomeView:)]) {
            self.homeModel= [self.dataSource homeModelForHomeView:self];
        }
        if ([self.dataSource respondsToSelector:@selector(customerRecommendModelForHomeView:)]) {
            self.customerRecommendModel = [self.dataSource customerRecommendModelForHomeView:self];
        }
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[self.homeModel allSectionModels]];
        [array addObjectsFromArray:[self.customerRecommendModel allSectionModels]];
        self.totalSectionModels = [NSArray arrayWithArray:array];
        [self.tableView reloadData];
    }
}

- (void)startRefresh {
    [self.tableView.header beginRefreshing];
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
}

- (void)startLoadMore {
    [self.tableView.legendFooter beginRefreshing];
}

- (void)endLoadMore {
    [self.tableView.legendFooter endRefreshing];
}

- (void)noMoreData:(BOOL)noMore {
    [self.tableView.legendFooter noticeNoMoreData];
    self.noMoreData = YES;
}

- (void)hideLoadMoreFooter:(BOOL)hidden {
    [self.tableView.legendFooter setHidden:hidden];
}

- (void)scrollHomeViewToSectionGroupIndex:(NSUInteger)index {
    CGPoint offset = [self offsetFromSectionGroupIndex:index];
    [self.tableView setContentOffset:offset animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
