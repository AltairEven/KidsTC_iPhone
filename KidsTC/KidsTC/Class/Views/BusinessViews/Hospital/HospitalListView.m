//
//  HospitalListView.m
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HospitalListView.h"
#import "HospitalListViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface HospitalListView () <UITableViewDataSource, UITableViewDelegate, HospitalListViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) BOOL noMoreData;

- (void)didPullUpToLoadMore;

@end

@implementation HospitalListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        HospitalListView *view = [GConfig getObjectFromNibWithView:self];
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
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([HospitalListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    
    __weak HospitalListView *weakSelf = self;
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
    HospitalListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"HospitalListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell configWithModel:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HospitalListItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return [model cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark HospitalListViewCellDelegate

- (void)didClickedPhoneButtonOnHospitalListViewCell:(HospitalListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hospitalListView:didClickedPhoneButtonAtIndex:)]) {
        [self.delegate hospitalListView:self didClickedPhoneButtonAtIndex:cell.indexPath.row];
    }
}

- (void)didClickedGotoButtonOnHospitalListViewCell:(HospitalListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hospitalListView:didClickedGotoButtonAtIndex:)]) {
        [self.delegate hospitalListView:self didClickedGotoButtonAtIndex:cell.indexPath.row];
    }
}

- (void)didClickedNearbyButtonOnHospitalListViewCell:(HospitalListViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hospitalListView:didClickedGotoButtonAtIndex:)]) {
        [self.delegate hospitalListView:self didClickedGotoButtonAtIndex:cell.indexPath.row];
    }
}

#pragma mark Private methods

- (void)didPullUpToLoadMore {
    self.tableView.backgroundView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPullUpToLoadMoreForHospitalListView:)]) {
        [self.delegate didPullUpToLoadMoreForHospitalListView:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemModelsOfHospitalListView:)]) {
        self.dataArray = [self.dataSource itemModelsOfHospitalListView:self];
    }
    [self.tableView reloadData];
    if ([self.dataArray count] == 0) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
    }
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
