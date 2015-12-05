//
//  StoreListView.m
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreListView.h"
#import "StoreListViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface StoreListView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *listModels;

@property (nonatomic, assign) BOOL noMoreData;

- (void)pullToRefreshTable;

- (void)pullToLoadMoreData;

@end

@implementation StoreListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        StoreListView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([StoreListViewCell class]) bundle:nil];
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
        __weak StoreListView *weakSelf = self;
        [self.tableView addRefreshViewHeaderWithRefreshingBlock:^{
            [weakSelf pullToRefreshTable];
        }];
    } else {
        [self.tableView removeHeader];
    }
}

- (void)setEnbaleLoadMore:(BOOL)enbaleLoadMore {
    _enbaleLoadMore = enbaleLoadMore;
    if (enbaleLoadMore) {
        __weak StoreListView *weakSelf = self;
        [self.tableView addGifFooterWithRefreshingBlock:^{
            [weakSelf pullToLoadMoreData];
        }];
    } else {
        [self.tableView removeFooter];
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listModels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    StoreListItemModel *model = [self.listModels objectAtIndex:indexPath.row];
    [cell configWithItemModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreListItemModel *model = [self.listModels objectAtIndex:indexPath.row];
    return [model cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeListView:didSelectedItemAtIndex:)]) {
        [self.delegate storeListView:self didSelectedItemAtIndex:indexPath.row];
    }
}

#pragma mark Private methods

- (void)pullToRefreshTable {
    [self.tableView.gifFooter resetNoMoreData];
    self.noMoreData = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeListViewDidPulledDownToRefresh:)]) {
        [self.delegate storeListViewDidPulledDownToRefresh:self];
    }
}

- (void)pullToLoadMoreData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeListViewDidPulledUpToloadMore:)]) {
        [self.delegate storeListViewDidPulledUpToloadMore:self];
    }
}


#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemModelsForStoreListView:)]) {
        self.listModels = [self.dataSource itemModelsForStoreListView:self];
    }
    [self.tableView reloadData];
}

- (void)startRefresh {
    [self.tableView.header beginRefreshing];
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
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
