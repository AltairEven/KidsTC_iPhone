//
//  FavourateView.m
//  KidsTC
//
//  Created by 钱烨 on 7/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "FavourateView.h"
#import "ServiceListViewCell.h"
#import "StoreListViewCell.h"
#import "ParentingStrategyViewCell.h"
#import "NewsListViewCell.h"
#import "AUISegmentView.h"
#import "FavourateSegmentViewCell.h"

static NSString *const kSegmentCellIdentifier = @"kSegmentCellIdentifier";
static NSString *const kServiceCellIdentifier = @"kServiceCellIdentifier";
static NSString *const kStoreCellIdentifier = @"kStoreCellIdentifier";
static NSString *const kParentingStrategyCellIdentifier = @"kParentingStrategyCellIdentifier";
static NSString *const kNewsCellIdentifier = @"kNewsCellIdentifier";

@interface FavourateView () <UITableViewDataSource, UITableViewDelegate, AUISegmentViewDataSource, AUISegmentViewDelegate>

@property (weak, nonatomic) IBOutlet AUISegmentView *segmentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *segmentCellNib;
@property (nonatomic, strong) UINib *serviceCellNib;
@property (nonatomic, strong) UINib *storeCellNib;
@property (nonatomic, strong) UINib *parentingStrategyCellNib;
@property (nonatomic, strong) UINib *newsCellNib;

@property (nonatomic, strong) NSArray *ItemModelArray;

@property (nonatomic, strong) NSMutableDictionary *noMoreDataDic;
@property (nonatomic, strong) NSMutableDictionary *hideFooterDic;

- (void)pullDownToRefresh;
- (void)pullUpToLoadMore;

@end

@implementation FavourateView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        FavourateView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    
    self.segmentView.dataSource = self;
    self.segmentView.delegate = self;
    [self.segmentView setShowSeparator:YES];
    if (!self.segmentCellNib) {
        self.segmentCellNib = [UINib nibWithNibName:NSStringFromClass([FavourateSegmentViewCell class]) bundle:nil];
        [self.segmentView registerNib:self.segmentCellNib forCellReuseIdentifier:kSegmentCellIdentifier];
    }
    [self.segmentView reloadData];
    [self.segmentView setSelectedIndex:0];
    
    
    if (!self.serviceCellNib) {
        self.serviceCellNib = [UINib nibWithNibName:NSStringFromClass([ServiceListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.serviceCellNib forCellReuseIdentifier:kServiceCellIdentifier];
    }
    if (!self.storeCellNib) {
        self.storeCellNib = [UINib nibWithNibName:NSStringFromClass([StoreListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.storeCellNib forCellReuseIdentifier:kStoreCellIdentifier];
    }
    if (!self.parentingStrategyCellNib) {
        self.parentingStrategyCellNib = [UINib nibWithNibName:NSStringFromClass([ParentingStrategyViewCell class]) bundle:nil];
        [self.tableView registerNib:self.parentingStrategyCellNib forCellReuseIdentifier:kParentingStrategyCellIdentifier];
    }
    if (!self.newsCellNib) {
        self.newsCellNib = [UINib nibWithNibName:NSStringFromClass([NewsListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.newsCellNib forCellReuseIdentifier:kNewsCellIdentifier];
    }
    
    //pull to refresh
    __weak FavourateView *weakSelf = self;
    [weakSelf.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf pullDownToRefresh];
    }];
    [weakSelf.tableView addGifFooterWithRefreshingBlock:^{
        BOOL noMore = [[weakSelf.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%d", weakSelf.currentTag]] boolValue];
        if (noMore) {
            [weakSelf.tableView.gifFooter noticeNoMoreData];
            return;
        }
        [weakSelf pullUpToLoadMore];
    }];
    
    //data
    self.noMoreDataDic = [[NSMutableDictionary alloc] init];
    self.hideFooterDic = [[NSMutableDictionary alloc] init];
}

- (NSUInteger)serviceListPageSize {
    return 10;
}

- (NSUInteger)storeListPageSize {
    return 10;
}

- (NSUInteger)strategyListPageSize {
    return 10;
}

- (NSUInteger)newsListPageSize {
    return 10;
}

#pragma mark AUISegmentViewDataSource & AUISegmentViewDelegate

- (NSUInteger)numberOfCellsForSegmentView:(AUISegmentView *)segmentView {
    return 4;
}

- (UITableViewCell *)segmentView:(AUISegmentView *)segmentView cellAtIndex:(NSUInteger)index {
    
    FavourateSegmentViewCell *cell = [segmentView dequeueReusableCellWithIdentifier:kSegmentCellIdentifier forIndex:index];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"FavourateSegmentViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    switch (index) {
        case 0:
        {
            [cell.titleLabel setText:@"服务"];
        }
            break;
        case 1:
        {
            [cell.titleLabel setText:@"门店"];
        }
            break;
        case 2:
        {
            [cell.titleLabel setText:@"攻略"];
        }
            break;
        case 3:
        {
            [cell.titleLabel setText:@"资讯"];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)segmentView:(AUISegmentView *)segmentView didSelectedAtIndex:(NSUInteger)index {
    _currentTag = (FavourateViewSegmentTag)index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(favourateView:didChangedSegmentSelectedIndexWithTag:)]) {
        [self.delegate favourateView:self didChangedSegmentSelectedIndexWithTag:(FavourateViewSegmentTag)index];
    }
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ItemModelArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.currentTag) {
        case FavourateViewSegmentTagService:
        {
            ServiceListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceCellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"ServiceListViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithItemModel:[self.ItemModelArray objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            StoreListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStoreCellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreListViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithItemModel:[self.ItemModelArray objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            ParentingStrategyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kParentingStrategyCellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"ParentingStrategyViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithItemModel:[self.ItemModelArray objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            NewsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"NewsListViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithItemModel:[self.ItemModelArray objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        default:
            break;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (self.currentTag) {
        case FavourateViewSegmentTagService:
        {
            height = [ServiceListViewCell cellHeight];
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            height = [StoreListViewCell cellHeight];
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            ParentingStrategyListItemModel *model = [self.ItemModelArray objectAtIndex:indexPath.row];
            height = [model cellHeight];
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            height = [NewsListViewCell cellHeight];
        }
            break;
        default:
            break;
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(favourateView:didSelectedAtIndex:ofTag:)]) {
        [self.delegate favourateView:self didSelectedAtIndex:indexPath.row ofTag:self.currentTag];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.ItemModelArray];
        [array removeObjectAtIndex:indexPath.row];
        self.ItemModelArray = [NSArray arrayWithArray:array];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(favourateView:didDeleteIndex:ofTag:)]) {
            [self.delegate favourateView:self didDeleteIndex:indexPath.row ofTag:self.currentTag];
        }
    }
}

#pragma mark Private methods

- (void)pullDownToRefresh {
    if (self.delegate && [self.delegate respondsToSelector:@selector(favourateView:needUpdateDataForTag:)]) {
        [self.delegate favourateView:self needUpdateDataForTag:self.currentTag];
    }
}

- (void)pullUpToLoadMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(favourateView:needLoadMoreDataForTag:)]) {
        [self.delegate favourateView:self needLoadMoreDataForTag:self.currentTag];
    }
}



#pragma mark Public methods

- (void)reloadDataForTag:(FavourateViewSegmentTag)tag {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(favourateView:itemModelsForSegmentTag:)]) {
        self.ItemModelArray = [self.dataSource favourateView:self itemModelsForSegmentTag:tag];
        [self.tableView reloadData];
        if ([self.ItemModelArray count] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
        if ([[self.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%d", self.currentTag]] boolValue]) {
            [self.tableView.gifFooter noticeNoMoreData];
        } else {
            [self.tableView.gifFooter resetNoMoreData];
        }
    }
    [self.tableView.gifFooter setHidden:[[self.hideFooterDic objectForKey:[NSString stringWithFormat:@"%d", self.currentTag]] boolValue]];
}

- (void)endRefresh {
    [self.tableView.legendHeader endRefreshing];
}

- (void)endLoadMore {
    [self.tableView.gifFooter endRefreshing];
}

- (void)noMoreData:(BOOL)noMore forTag:(FavourateViewSegmentTag)tag {
    [self.noMoreDataDic setObject:[NSNumber numberWithBool:noMore] forKey:[NSString stringWithFormat:@"%d", tag]];
}

- (void)hideLoadMoreFooter:(BOOL)hidden ForTag:(FavourateViewSegmentTag)tag {
    [self.tableView.gifFooter setHidden:hidden];
    [self.hideFooterDic setObject:[NSNumber numberWithBool:hidden] forKey:[NSString stringWithFormat:@"%d", tag]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
