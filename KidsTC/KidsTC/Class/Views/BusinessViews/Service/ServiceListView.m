//
//  ServiceListView.m
//  KidsTC
//
//  Created by 钱烨 on 7/10/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceListView.h"
#import "ServiceListViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface ServiceListView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, assign) BOOL noMoreData;

- (void)pullToRefreshTable;

- (void)pullToLoadMoreData;

@end

@implementation ServiceListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        ServiceListView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([ServiceListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    self.enableUpdate = YES;
    self.enbaleLoadMore = YES;
}

- (NSUInteger)pageSize {
    return 10;
}


- (void)setEnableUpdate:(BOOL)enableUpdate {
    _enableUpdate = enableUpdate;
    if (enableUpdate) {
        __weak ServiceListView *weakSelf = self;
        [self.tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf pullToRefreshTable];
        }];
    } else {
        [self.tableView removeHeader];
    }
}

- (void)setEnbaleLoadMore:(BOOL)enbaleLoadMore {
    _enbaleLoadMore = enbaleLoadMore;
    if (enbaleLoadMore) {
        __weak ServiceListView *weakSelf = self;
        [self.tableView addGifFooterWithRefreshingBlock:^{
            [weakSelf pullToLoadMoreData];
        }];
    } else {
        [self.tableView removeFooter];
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfServiceInListView:)]) {
        number = [self.dataSource numberOfServiceInListView:self];
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ServiceListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemModelForServiceListView:atIndex:)]) {
        ServiceListItemModel *model = [self.dataSource itemModelForServiceListView:self atIndex:indexPath.row];
        [cell configWithItemModel:model];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ServiceListViewCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceListView:didSelectedItemAtIndex:)]) {
        [self.delegate serviceListView:self didSelectedItemAtIndex:indexPath.row];
    }
}

#pragma mark Private methods

- (void)pullToRefreshTable {
    [self.tableView.gifFooter resetNoMoreData];
    self.noMoreData = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceListViewDidPulledDownToRefresh:)]) {
        [self.delegate serviceListViewDidPulledDownToRefresh:self];
    }
}

- (void)pullToLoadMoreData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceListViewDidPulledUpToloadMore:)]) {
        [self.delegate serviceListViewDidPulledUpToloadMore:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource) {
        [self.tableView reloadData];
    }
}

- (void)startRefresh {
    [self.tableView.legendHeader beginRefreshing];
}

- (void)endRefresh {
    [self.tableView.legendHeader endRefreshing];
}

- (void)endLoadMore {
    [self.tableView.gifFooter endRefreshing];
}

- (void)noMoreLoad {
    [self.tableView.gifFooter noticeNoMoreData];
    self.noMoreData = YES;
}

- (void)hideLoadMoreFooter:(BOOL)hidden {
    [self.tableView.gifFooter setHidden:hidden];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
