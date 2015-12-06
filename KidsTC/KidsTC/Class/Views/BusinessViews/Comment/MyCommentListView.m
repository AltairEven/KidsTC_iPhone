//
//  MyCommentListView.m
//  KidsTC
//
//  Created by Altair on 12/1/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "MyCommentListView.h"
#import "MyCommentListViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface MyCommentListView () <UITableViewDataSource, UITableViewDelegate, MyCommentListViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *listModels;

@property (nonatomic, assign) BOOL noMoreData;

- (void)pullDownToRefresh;

- (void)pullUpToLoadMore;

@end

@implementation MyCommentListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        MyCommentListView *view = [GConfig getObjectFromNibWithView:self];
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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([MyCommentListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    __weak MyCommentListView *weakSelf = self;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listModels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"MyCommentListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell configWithItemModel:[self.listModels objectAtIndex:indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentListItemModel *model = [self.listModels objectAtIndex:indexPath.row];
    return [model cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListView:didClickedAtIndex:)]) {
        [self.delegate commentListView:self didClickedAtIndex:indexPath.row];
    }
}

#pragma mark MyCommentListViewCellDelegate

- (void)myCommentListViewCell:(MyCommentListViewCell *)cell didClickedImageAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListView:didClickedImageAtCellIndex:andImageIndex:)]) {
        [self.delegate commentListView:self didClickedImageAtCellIndex:cell.indexPath.row andImageIndex:index];
    }
}

- (void)didClickedEditButton:(MyCommentListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListView:didClickedEditAtIndex:)]) {
        [self.delegate commentListView:self didClickedEditAtIndex:cell.indexPath.row];
    }
}

- (void)didClickedDeleteButton:(MyCommentListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListView:didClickedDeleteAtIndex:)]) {
        [self.delegate commentListView:self didClickedDeleteAtIndex:cell.indexPath.row];
    }
}


#pragma mark Private methods

- (void)pullDownToRefresh {
    self.tableView.backgroundView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPullDownToRefreshForCommentListView:)]) {
        [self.delegate didPullDownToRefreshForCommentListView:self];
    }
}

- (void)pullUpToLoadMore {
    self.tableView.backgroundView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPullUpToLoadMoreForCommentListView:)]) {
        [self.delegate didPullUpToLoadMoreForCommentListView:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemModelsForCommentListView:)]) {
        self.listModels = [self.dataSource itemModelsForCommentListView:self];
        [self.tableView reloadData];
        if (self.noMoreData) {
            [self.tableView.gifFooter noticeNoMoreData];
        } else {
            [self.tableView.gifFooter resetNoMoreData];
        }
    }
    if ([self.listModels count] == 0) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
    }
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

- (void)noMoreData:(BOOL)noMore {
    self.noMoreData = noMore;
    if (self.noMoreData) {
        [self.tableView.gifFooter noticeNoMoreData];
    } else {
        [self.tableView.gifFooter resetNoMoreData];
    }
}

- (void)hideLoadMoreFooter:(BOOL)hidden {
    [self.tableView.gifFooter setHidden:hidden];
}

@end
