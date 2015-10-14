//
//  LoveHouseListView.m
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "LoveHouseListView.h"
#import "LoveHouseListViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface LoveHouseListView () <UITableViewDataSource, UITableViewDelegate, LoveHouseListViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) BOOL noMoreData;

- (void)didPullUpToLoadMore;

@end

@implementation LoveHouseListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        LoveHouseListView *view = [GConfig getObjectFromNibWithView:self];
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
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([LoveHouseListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    
    __weak LoveHouseListView *weakSelf = self;
    [weakSelf.tableView addGifFooterWithRefreshingBlock:^{
        if (weakSelf.noMoreData) {
            [weakSelf.tableView.gifFooter noticeNoMoreData];
            return ;
        }
        [weakSelf didPullUpToLoadMore];
    }];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoveHouseListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"LoveHouseListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell configWithModel:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LoveHouseListViewCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark LoveHouseListViewCellDelegate

- (void)didClickedGotoButtonOnLoveHouseListViewCell:(LoveHouseListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loveHouseListView:didClickedGotoButtonAtIndex:)]) {
        [self.delegate loveHouseListView:self didClickedGotoButtonAtIndex:cell.indexPath.row];
    }
}

- (void)didClickedNearbyButtonOnLoveHouseListViewCell:(LoveHouseListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loveHouseListView:didClickedNearbyButtonAtIndex:)]) {
        [self.delegate loveHouseListView:self didClickedNearbyButtonAtIndex:cell.indexPath.row];
    }
}

#pragma mark Private methods

- (void)didPullUpToLoadMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPullUpToLoadMoreForLoveHouseListView:)]) {
        [self.delegate didPullUpToLoadMoreForLoveHouseListView:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemModelsOfLoveHouseListView:)]) {
        self.dataArray = [self.dataSource itemModelsOfLoveHouseListView:self];
    }
    [self.tableView reloadData];
}

- (void)startLoadMore {
    [self.tableView.gifFooter resetNoMoreData];
    [self.tableView.gifFooter beginRefreshing];
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
