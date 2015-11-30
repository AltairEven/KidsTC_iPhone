//
//  OrderListView.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderListView.h"
#import "OrderListViewCell.h"

static NSString *const kCellIdentifier = @"cellIdentifier";

@interface OrderListView () <UITableViewDataSource, UITableViewDelegate, OrderListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *listModels;

@property (nonatomic, assign) BOOL noMoreData;

- (void)pullDownToRefresh;

- (void)pullUpToLoadMore;

@end

@implementation OrderListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        OrderListView *view = [GConfig getObjectFromNibWithView:self];
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
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([OrderListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    __weak OrderListView *weakSelf = self;
    [weakSelf.tableView addRefreshViewHeaderWithRefreshingBlock:^{
        [weakSelf pullDownToRefresh];
    }];
    [weakSelf.tableView addGifFooterWithRefreshingBlock:^{
        if (weakSelf.noMoreData) {
            [weakSelf.tableView.gifFooter noticeNoMoreData];
            return;
        }
        [weakSelf pullUpToLoadMore];
    }];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listModels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"OrderListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell configWithOrderListModel:[self.listModels objectAtIndex:indexPath.section] atIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListModel *model = [self.listModels objectAtIndex:indexPath.section];
    return [model cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListView:didSelectAtIndex:)]) {
        [self.delegate orderListView:self didSelectAtIndex:indexPath.section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}


#pragma mark OrderListCellDelegate

- (void)didClickedPayButtonOnOrderListViewCell:(OrderListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListView:didClickedPayButtonAtIndex:)]) {
        [self.delegate orderListView:self didClickedPayButtonAtIndex:cell.indexPath.section];
    }
}

- (void)didClickedCommentButtonOnOrderListViewCell:(OrderListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListView:didClickedCommentButtonAtIndex:)]) {
        [self.delegate orderListView:self didClickedCommentButtonAtIndex:cell.indexPath.section];
    }
}

- (void)didClickedReturnButtonOnOrderListViewCell:(OrderListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListView:didClickedReturnButtonAtIndex:)]) {
        [self.delegate orderListView:self didClickedReturnButtonAtIndex:cell.indexPath.section];
    }
}

#pragma mark Private methods

- (void)pullDownToRefresh {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListViewDidPullDownToRefresh:)]) {
        [self.delegate orderListViewDidPullDownToRefresh:self];
    }
}

- (void)pullUpToLoadMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListViewDidPullUpToLoadMore:)]) {
        [self.delegate orderListViewDidPullUpToLoadMore:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(orderListModelsForOrderListView:)]) {
        self.listModels = [self.dataSource orderListModelsForOrderListView:self];
        [self.tableView reloadData];
    }
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
}

- (void)endLoadMore {
    [self.tableView.gifFooter endRefreshing];
}

- (void)noMoreData:(BOOL)noMore {
    self.noMoreData = noMore;
    if (noMore) {
        [self.tableView.gifFooter noticeNoMoreData];
    } else {
        [self.tableView.gifFooter resetNoMoreData];
    }
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
