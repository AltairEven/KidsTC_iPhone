//
//  CommentListView.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CommentListView.h"
#import "AUISegmentView.h"
#import "CommentListViewSegmentCell.h"
#import "CommentListViewCell.h"

static NSString *const kSegmentIdentifier = @"kSegmentIdentifier";

static NSString *const kContentCellIdentifier = @"kCommentCellIdentifier";

@interface CommentListView () <UITableViewDataSource, UITableViewDelegate, AUISegmentViewDataSource, AUISegmentViewDelegate, CommentListViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet AUISegmentView *segmentView;

@property (nonatomic, strong) UINib *segmentNib;

@property (nonatomic, strong) UINib *contentNib;

@property (nonatomic, strong) NSArray *listModels;

@property (nonatomic, strong) NSMutableDictionary *noMoreDataDic;
@property (nonatomic, strong) NSMutableDictionary *hideFooterDic;

- (void)pullDownToRefresh;

- (void)pullUpToLoadMore;

@end

@implementation CommentListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        CommentListView *view = [GConfig getObjectFromNibWithView:self];
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
    if (!self.contentNib) {
        self.contentNib = [UINib nibWithNibName:NSStringFromClass([CommentListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.contentNib forCellReuseIdentifier:kContentCellIdentifier];
    }
    __weak CommentListView *weakSelf = self;
    [weakSelf.tableView addRefreshViewHeaderWithRefreshingBlock:^{
        [weakSelf pullDownToRefresh];
    }];
    [weakSelf.tableView addGifFooterWithRefreshingBlock:^{
        BOOL noMore = [[weakSelf.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)weakSelf.currentViewTag]] boolValue];
        if (noMore) {
            [weakSelf.tableView.gifFooter noticeNoMoreData];
            return;
        }
        [weakSelf pullUpToLoadMore];
    }];
    
    self.segmentView.dataSource = self;
    self.segmentView.delegate = self;
    if (!self.segmentNib) {
        self.segmentNib = [UINib nibWithNibName:NSStringFromClass([CommentListViewSegmentCell class]) bundle:nil];
        [self.segmentView registerNib:self.segmentNib forCellReuseIdentifier:kSegmentIdentifier];
    }
    _currentViewTag = CommentListViewTagAll;
    [self.segmentView setSelectedIndex:self.currentViewTag - 1];
    //data
    self.noMoreDataDic = [[NSMutableDictionary alloc] init];
    self.hideFooterDic = [[NSMutableDictionary alloc] init];
}

#pragma mark AUISegmentViewDataSource & AUISegmentViewDelegate

- (NSUInteger)numberOfCellsForSegmentView:(AUISegmentView *)segmentView {
    return 5;
}

- (UITableViewCell *)segmentView:(AUISegmentView *)segmentView cellAtIndex:(NSUInteger)index {
    
    CommentListViewSegmentCell *cell = [segmentView dequeueReusableCellWithIdentifier:kSegmentIdentifier forIndex:index];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"CommentListViewSegmentCell" owner:nil options:nil] objectAtIndex:0];
    }
    switch (index) {
        case 0:
        {
            [cell.titleLabel setText:@"全部评价"];
            NSUInteger number = 0;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCommentsOnCommentListView:withTag:)]) {
                number = [self.dataSource numberOfCommentsOnCommentListView:self withTag:CommentListViewTagAll];
            }
            [cell.countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
        }
            break;
        case 1:
        {
            [cell.titleLabel setText:@"好评"];
            NSUInteger number = 0;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCommentsOnCommentListView:withTag:)]) {
                number = [self.dataSource numberOfCommentsOnCommentListView:self withTag:CommentListViewTagGood];
            }
            [cell.countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
        }
            break;
        case 2:
        {
            [cell.titleLabel setText:@"中评"];
            NSUInteger number = 0;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCommentsOnCommentListView:withTag:)]) {
                number = [self.dataSource numberOfCommentsOnCommentListView:self withTag:CommentListViewTagNormal];
            }
            [cell.countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
        }
            break;
        case 3:
        {
            [cell.titleLabel setText:@"差评"];
            NSUInteger number = 0;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCommentsOnCommentListView:withTag:)]) {
                number = [self.dataSource numberOfCommentsOnCommentListView:self withTag:CommentListViewTagBad];
            }
            [cell.countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
        }
            break;
        case 4:
        {
            [cell.titleLabel setText:@"有图"];
            NSUInteger number = 0;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCommentsOnCommentListView:withTag:)]) {
                number = [self.dataSource numberOfCommentsOnCommentListView:self withTag:CommentListViewTagPicture];
            }
            [cell.countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)segmentView:(AUISegmentView *)segmentView didSelectedAtIndex:(NSUInteger)index {
    _currentViewTag = (CommentListViewTag)index + 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListView:willShowWithTag:)]) {
        [self.delegate commentListView:self willShowWithTag:_currentViewTag];
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
    CommentListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContentCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"CommentListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    CommentListItemModel *model = [self.listModels objectAtIndex:indexPath.section];
    [cell configWithItemModel:model];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    CommentListItemModel *model = [self.listModels objectAtIndex:indexPath.section];
    height = [model cellHeight];
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListView:didClickedCellAtIndex:)]) {
        [self.delegate commentListView:self didClickedCellAtIndex:indexPath.section];
    }
}


#pragma mark CommentListViewCellDelegate

- (void)commentListViewCell:(CommentListViewCell *)cell didClickedImageAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListView:didClickedImageAtCellIndex:andImageIndex:)]) {
        [self.delegate commentListView:self didClickedImageAtCellIndex:cell.indexPath.section andImageIndex:index];
    }
}

#pragma mark Private methods

- (void)pullDownToRefresh {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListView:DidPullDownToRefreshforViewTag:)]) {
        [self.delegate commentListView:self DidPullDownToRefreshforViewTag:self.currentViewTag];
    }
}

- (void)pullUpToLoadMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListView:DidPullUpToLoadMoreforViewTag:)]) {
        [self.delegate commentListView:self DidPullUpToLoadMoreforViewTag:self.currentViewTag];
    }
}

#pragma mark Public methods

- (void)reloadSegmentHeader {
    [self.segmentView reloadData];
    [self.segmentView setSelectedIndex:self.currentViewTag - 1];
}

- (void)reloadDataforViewTag:(CommentListViewTag)tag {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(commentListItemModelsOfCommentListView:withTag:)]) {
        self.listModels = [self.dataSource commentListItemModelsOfCommentListView:self withTag:(CommentListViewTag)self.segmentView.selectedIndex + 1];
        [self.tableView reloadData];
        if ([self.listModels count] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        if ([[self.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentViewTag]] boolValue]) {
            [self.tableView.gifFooter noticeNoMoreData];
        } else {
            [self.tableView.gifFooter resetNoMoreData];
        }
    }
    [self.tableView.gifFooter setHidden:[[self.hideFooterDic objectForKey:[NSString stringWithFormat:@"%d", self.currentViewTag]] boolValue]];
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
}

- (void)endLoadMore {
    [self.tableView.gifFooter endRefreshing];
}

- (void)noMoreData:(BOOL)noMore forViewTag:(CommentListViewTag)tag {
    [self.noMoreDataDic setObject:[NSNumber numberWithBool:noMore] forKey:[NSString stringWithFormat:@"%d", tag]];
}

- (void)hideLoadMoreFooter:(BOOL)hidden forViewTag:(CommentListViewTag)tag {
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
