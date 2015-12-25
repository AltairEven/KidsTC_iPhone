//
//  AppointmentOrderListView.m
//  KidsTC
//
//  Created by 钱烨 on 8/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppointmentOrderListView.h"
#import "AppointmentOrderListCell.h"
#import "AUISegmentView.h"
#import "AppointmentListViewHeaderTabCell.h"

static NSString *const kHeaderCellIdentifier = @"kHeaderCellIdentifier";
static NSString *const kCellIdentifier = @"cellIdentifier";

@interface AppointmentOrderListView () <AUISegmentViewDataSource, AUISegmentViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet AUISegmentView *headerTab;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *headerCellNib;
@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *listModels;

@property (nonatomic, strong) NSMutableDictionary *noMoreDataDic;
@property (nonatomic, strong) NSMutableDictionary *hideFooterDic;

- (void)pullDownToRefresh;

- (void)pullUpToLoadMore;

@end

@implementation AppointmentOrderListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        AppointmentOrderListView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([AppointmentOrderListCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    __weak AppointmentOrderListView *weakSelf = self;
    [weakSelf.tableView addRefreshViewHeaderWithRefreshingBlock:^{
        [weakSelf pullDownToRefresh];
    }];
    [weakSelf.tableView addGifFooterWithRefreshingBlock:^{
        BOOL noMore = [[weakSelf.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%d", weakSelf.currentLsitStatus]] boolValue];
        if (noMore) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        [weakSelf pullUpToLoadMore];
    }];
    
    self.headerTab.dataSource = self;
    self.headerTab.delegate = self;
    [self.headerTab setShowSeparator:YES];
    if (!self.headerCellNib) {
        self.headerCellNib = [UINib nibWithNibName:NSStringFromClass([AppointmentListViewHeaderTabCell class]) bundle:nil];
        [self.headerTab registerNib:self.headerCellNib forCellReuseIdentifier:kHeaderCellIdentifier];
    }
    [self.headerTab reloadData];
    [self.headerTab setSelectedIndex:0];
    //data
    self.noMoreDataDic = [[NSMutableDictionary alloc] init];
    self.hideFooterDic = [[NSMutableDictionary alloc] init];
    
    _currentLsitStatus = AppointmentOrderListStatusAll;
}

#pragma mark AUISegmentViewDataSource & AUISegmentViewDelegate

- (NSUInteger)numberOfCellsForSegmentView:(AUISegmentView *)segmentView {
    return 3;
}

- (UITableViewCell *)segmentView:(AUISegmentView *)segmentView cellAtIndex:(NSUInteger)index {
    
    AppointmentListViewHeaderTabCell *cell = [segmentView dequeueReusableCellWithIdentifier:kHeaderCellIdentifier forIndex:index];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"AppointmentListViewHeaderTabCell" owner:nil options:nil] objectAtIndex:0];
    }
    switch (index) {
        case 0:
        {
            [cell.titleLabel setText:@"全部"];
        }
            break;
        case 1:
        {
            [cell.titleLabel setText:@"待到店"];
        }
            break;
        case 2:
        {
            [cell.titleLabel setText:@"已到店"];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)segmentView:(AUISegmentView *)segmentView didSelectedAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
        {
            _currentLsitStatus = AppointmentOrderListStatusAll;
        }
            break;
        case 1:
        {
            _currentLsitStatus = AppointmentOrderListStatusWaitingUse;
        }
            break;
        case 2:
        {
            _currentLsitStatus = AppointmentOrderListStatusWaitingComment;
        }
            break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListView:didChangedListStatus:)]) {
        [self.delegate orderListView:self didChangedListStatus:self.currentLsitStatus];
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listModels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppointmentOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"OrderListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell configWithOrderModel:[self.listModels objectAtIndex:indexPath.section]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AppointmentOrderListCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListView:didSelectAtIndex: ofListStatus:)]) {
        [self.delegate orderListView:self didSelectAtIndex:indexPath.section ofListStatus:self.currentLsitStatus];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}

#pragma mark Private methods

- (void)pullDownToRefresh {
    self.tableView.backgroundView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListViewDidPullDownToRefresh:forListStatus:)]) {
        [self.delegate orderListViewDidPullDownToRefresh:self forListStatus:self.currentLsitStatus];
    }
}

- (void)pullUpToLoadMore {
    self.tableView.backgroundView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListViewDidPullUpToLoadMore:forListStatus:)]) {
        [self.delegate orderListViewDidPullUpToLoadMore:self forListStatus:self.currentLsitStatus];
    }
}


#pragma mark Public methods

- (void)reloadDataforListStatus:(AppointmentOrderListStatus)status {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(orderModelsForOrderListView:forListStatus:)]) {
        self.listModels = [self.dataSource orderModelsForOrderListView:self forListStatus:status];
        [self.tableView reloadData];
        if ([self.listModels count] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
        if ([[self.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%d", self.currentLsitStatus]] boolValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer resetNoMoreData];
        }
    }
    [self.tableView.mj_footer setHidden:[[self.hideFooterDic objectForKey:[NSString stringWithFormat:@"%d", self.currentLsitStatus]] boolValue]];
    if ([self.listModels count] == 0) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
    }
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)endLoadMore {
    [self.tableView.mj_footer endRefreshing];
}

- (void)noMoreData:(BOOL)noMore forListStatus:(AppointmentOrderListStatus)status {
    [self.noMoreDataDic setObject:[NSNumber numberWithBool:noMore] forKey:[NSString stringWithFormat:@"%d", status]];
}

- (void)hideLoadMoreFooter:(BOOL)hidden forListStatus:(AppointmentOrderListStatus)status {
    [self.tableView.mj_footer setHidden:hidden];
    [self.hideFooterDic setObject:[NSNumber numberWithBool:hidden] forKey:[NSString stringWithFormat:@"%d", status]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
