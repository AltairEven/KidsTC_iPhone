//
//  CommentDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentDetailView.h"
#import "CommentDetailViewCell.h"
#import "CommentDetailViewNormalHeaderCell.h"
#import "CommentDetailViewStrategyHeaderCell.h"

static NSString *const kReplyCellIdentifier = @"kReplyCellIdentifier";

static NSString *const kNormalHeaderCellIdentifier = @"kNormalHeaderCellIdentifier";

static NSString *const kStrategyHeaderCellIdentifier = @"kStrategyHeaderCellIdentifier";

@interface CommentDetailView () <UITableViewDataSource, UITableViewDelegate, CommentDetailViewNormalHeaderCellDelegate, CommentDetailViewStrategyHeaderCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//table
@property (nonatomic, strong) UINib *replyCellNib;

@property (nonatomic, strong) UINib *normalHeaderCellNib;

@property (nonatomic, strong) UINib *strategyHeaderCellNib;

@property (nonatomic, assign) BOOL noMoreData;

@property (nonatomic, strong) CommentDetailModel *detailModel;

//bottom
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *bottomTextField;


- (void)pullToRefreshTable;

- (void)pullToLoadMoreData;

- (void)didTappedOnBottomView;

@end

@implementation CommentDetailView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        CommentDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    if (!self.replyCellNib) {
        self.replyCellNib = [UINib nibWithNibName:NSStringFromClass([CommentDetailViewCell class]) bundle:nil];
        [self.tableView registerNib:self.replyCellNib forCellReuseIdentifier:kReplyCellIdentifier];
    }
    if (!self.normalHeaderCellNib) {
        self.normalHeaderCellNib = [UINib nibWithNibName:NSStringFromClass([CommentDetailViewNormalHeaderCell class]) bundle:nil];
        [self.tableView registerNib:self.normalHeaderCellNib forCellReuseIdentifier:kNormalHeaderCellIdentifier];
    }
    if (!self.strategyHeaderCellNib) {
        self.strategyHeaderCellNib = [UINib nibWithNibName:NSStringFromClass([CommentDetailViewStrategyHeaderCell class]) bundle:nil];
        [self.tableView registerNib:self.strategyHeaderCellNib forCellReuseIdentifier:kStrategyHeaderCellIdentifier];
    }
    self.enableUpdate = YES;
    self.enbaleLoadMore = YES;
    
    //bottom
    [self.bottomView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnBottomView)];
    [self.bottomView addGestureRecognizer:tap];
    
    self.bottomTextField.layer.cornerRadius = 10;
    self.bottomTextField.layer.masksToBounds = YES;
    [self.bottomTextField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)]];
    [self.bottomTextField setLeftViewMode:UITextFieldViewModeAlways];
}

- (NSUInteger)pageSize {
    return 10;
}


- (void)setEnableUpdate:(BOOL)enableUpdate {
    _enableUpdate = enableUpdate;
    if (enableUpdate) {
        __weak CommentDetailView *weakSelf = self;
        [self.tableView addGifHeaderWithRefreshingBlock:^{
            [weakSelf pullToRefreshTable];
        }];
    } else {
        self.tableView.mj_header = nil;
    }
}

- (void)setEnbaleLoadMore:(BOOL)enbaleLoadMore {
    _enbaleLoadMore = enbaleLoadMore;
    if (enbaleLoadMore) {
        __weak CommentDetailView *weakSelf = self;
        [self.tableView addGifFooterWithRefreshingBlock:^{
            if (weakSelf.noMoreData) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [weakSelf pullToLoadMoreData];
        }];
    } else {
        self.tableView.mj_footer = nil;
    }
    [self.tableView.mj_footer setHidden:YES];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (section == 0) {
        if (self.detailModel.headerModel) {
            number = 1;
        }
    } else {
        number = [self.detailModel.replyModels count];
    }
    
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (self.detailModel.modelSource) {
            case CommentDetailViewSourceStrategy:
            {
                CommentDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReplyCellIdentifier forIndexPath:indexPath];
                if (!cell) {
                    cell =  [[[NSBundle mainBundle] loadNibNamed:@"CommentDetailViewCell" owner:nil options:nil] objectAtIndex:0];
                }
                [cell configWithModel:[self.detailModel.replyModels objectAtIndex:indexPath.row]];
                return cell;
            }
                break;
            case CommentDetailViewSourceStrategyDetail:
            {
                CommentDetailViewStrategyHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kStrategyHeaderCellIdentifier forIndexPath:indexPath];
                if (!cell) {
                    cell =  [[[NSBundle mainBundle] loadNibNamed:@"CommentDetailViewStrategyHeaderCell" owner:nil options:nil] objectAtIndex:0];
                }
                ((ParentingStrategyDetailCellModel *)self.detailModel.headerModel).commentCount = self.detailModel.totalReplyCount;
                [cell configWithDetailCellModel:self.detailModel.headerModel];
                cell.delegate = self;
                return cell;
            }
                break;
            case CommentDetailViewSourceServiceOrStore:
            {
                CommentDetailViewNormalHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalHeaderCellIdentifier forIndexPath:indexPath];
                if (!cell) {
                    cell =  [[[NSBundle mainBundle] loadNibNamed:@"CommentDetailViewNormalHeaderCell" owner:nil options:nil] objectAtIndex:0];
                }
                cell.delegate = self;
                ((CommentListItemModel *)self.detailModel.headerModel).replyNumber = self.detailModel.totalReplyCount;
                [cell configWithModel:self.detailModel.headerModel];
                return cell;
            }
            default:
                break;
        }
    } else {
        CommentDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReplyCellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"CommentDetailViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        [cell configWithModel:[self.detailModel.replyModels objectAtIndex:indexPath.row]];
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = [self.detailModel headerCellHeight];
    } else {
        CommentReplyItemModel *model = [self.detailModel.replyModels objectAtIndex:indexPath.row];
        height = [model cellHeight];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(commentDetailView:didSelectedReplyAtIndex:)]) {
            [self.delegate commentDetailView:self didSelectedReplyAtIndex:indexPath.row];
        }
    }
}

#pragma mark CommentDetailViewNormalHeaderCellDelegate

- (void)headerCell:(CommentDetailViewNormalHeaderCell *)cell didChangedBoundsWithNewHeight:(CGFloat)height {
    self.detailModel.headerCellHeight = height;
    [self.tableView reloadData];
}

#pragma mark CommentDetailViewStrategyHeaderCellDelegate


- (void)didClickedRelatedInfoButtonOnCommentDetailViewStrategyHeaderCell:(CommentDetailViewStrategyHeaderCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedRelationInfoOnCommentDetailView:)]) {
        [self.delegate didClickedRelationInfoOnCommentDetailView:self];
    }
}

- (void)commentDetailViewStrategyHeaderCell:(CommentDetailViewStrategyHeaderCell *)cell didSelectedLinkWithSegueModel:(HomeSegueModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentDetailView:didSelectedLinkWithSegueModel:)]) {
        [self.delegate commentDetailView:self didSelectedLinkWithSegueModel:model];
    }
}

#pragma mark Private methods

- (void)pullToRefreshTable {
    [self.tableView.mj_footer resetNoMoreData];
    self.noMoreData = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentDetailViewDidPulledDownToRefresh:)]) {
        [self.delegate commentDetailViewDidPulledDownToRefresh:self];
    }
}

- (void)pullToLoadMoreData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentDetailViewDidPulledUpToloadMore:)]) {
        [self.delegate commentDetailViewDidPulledUpToloadMore:self];
    }
}


- (void)didTappedOnBottomView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTappedOnCommentDetailView:)]) {
        [self.delegate didTappedOnCommentDetailView:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailModelForCommentDetailView:)]) {
        self.detailModel = [self.dataSource detailModelForCommentDetailView:self];
        [self.tableView.mj_footer setHidden:NO];
    }
    [self.tableView reloadData];
}

- (void)startRefresh {
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)endLoadMore {
    [self.tableView.mj_footer endRefreshing];
}

- (void)noMoreData:(BOOL)noMore {
    self.noMoreData = noMore;
    if (noMore) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
}

- (void)hideLoadMoreFooter:(BOOL)hidden {
    [self.tableView.mj_footer setHidden:hidden];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
