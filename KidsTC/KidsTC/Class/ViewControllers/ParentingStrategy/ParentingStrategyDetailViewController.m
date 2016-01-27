//
//  ParentingStrategyDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailViewController.h"
#import "ParentingStrategyDetailViewModel.h"
#import "CommentDetailViewController.h"
#import "CommonShareViewController.h"
#import "KTCSegueMaster.h"
#import "KTCMapViewController.h"
#import "KTCStoreMapViewController.h"
#import "ServiceDetailViewController.h"
#import "StrategyDetailRelatedServiceListViewController.h"
#import "StrategyDetailBottomView.h"

@interface ParentingStrategyDetailViewController () <ParentingStrategyDetailViewDelegate, StrategyDetailBottomViewDelegate>

@property (weak, nonatomic) IBOutlet ParentingStrategyDetailView *detailView;
@property (weak, nonatomic) IBOutlet StrategyDetailBottomView *bottomView;

@property (nonatomic, strong) ParentingStrategyDetailViewModel *viewModel;

@property (nonatomic, copy) NSString *strategyId;

@property (nonatomic, strong) UIButton *likeButton;

- (void)buildRightBarItems;

- (void)didClickedCommentButton;

- (void)didClickedLikeButton;

- (void)didClickedShareButton;

- (void)resetBottomView;

@end

@implementation ParentingStrategyDetailViewController

- (instancetype)initWithStrategyIdentifier:(NSString *)identifier {
    self = [super initWithNibName:@"ParentingStrategyDetailViewController" bundle:nil];
    if (self) {
        self.strategyId = identifier;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIdentifier = @"pv_stgy";
    // Do any additional setup after loading the view from its nib.
    [self buildRightBarItems];
    self.detailView.delegate = self;
    self.viewModel = [[ParentingStrategyDetailViewModel alloc] initWithView:self.detailView];
    __weak ParentingStrategyDetailViewController *weakSelf = self;
    [self.viewModel setNetErrorBlock:^(NSError *error) {
        [weakSelf showConnectError:YES];
    }];
    [self reloadNetworkData];
    
    self.bottomView.delegate = self;
    [self.bottomView setHidden:YES];
}

#pragma mark ParentingStrategyDetailViewDelegate

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didSelectedItemAtIndex:(NSUInteger)index {
    ParentingStrategyDetailCellModel *model = [self.viewModel.detailModel.cellModels objectAtIndex:index];
    CommentDetailViewController *controller = [[CommentDetailViewController alloc] initWithSource:CommentDetailViewSourceStrategyDetail relationType:CommentRelationTypeStrategyDetail headerModel:model];
    [controller setRelationIdentifier:model.identifier];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didClickedLocationButtonAtIndex:(NSUInteger)index {
    ParentingStrategyDetailCellModel *model = [self.viewModel.detailModel.cellModels objectAtIndex:index];
    if (model.location) {
        KTCMapViewController *controller = [[KTCMapViewController alloc] initWithMapType:KTCMapTypeStoreGuide destination:model.location];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didClickedCommentButtonAtIndex:(NSUInteger)index {
    ParentingStrategyDetailCellModel *model = [self.viewModel.detailModel.cellModels objectAtIndex:index];
    CommentDetailViewController *controller = [[CommentDetailViewController alloc] initWithSource:CommentDetailViewSourceStrategyDetail relationType:CommentRelationTypeStrategyDetail headerModel:model];
    [controller setRelationIdentifier:model.identifier];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didClickedRelatedInfoButtonAtIndex:(NSUInteger)index {
    ParentingStrategyDetailCellModel *model = [self.viewModel.detailModel.cellModels objectAtIndex:index];
    [KTCSegueMaster makeSegueWithModel:model.relatedInfoModel fromController:self];
}

- (void)didClickedStoreOnParentingStrategyDetailView:(ParentingStrategyDetailView *)detailView {
    KTCStoreMapViewController *controller = [[KTCStoreMapViewController alloc] initWithStoreItems:[self.viewModel.detailModel relatedStoreItems]];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
    //MTA
    [MTA trackCustomEvent:@"event_skip_map_stores_dtl" args:nil];
}

- (void)didClickedAllRelatedServiceOnParentingStrategyDetailView:(ParentingStrategyDetailView *)detailView {
    StrategyDetailRelatedServiceListViewController *controller = [[StrategyDetailRelatedServiceListViewController alloc] initWithListItemModels:self.viewModel.detailModel.relatedServices];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didClickedRelatedServiceAtIndex:(NSUInteger)index {
    StrategyDetailServiceItemModel *serviceModel = [self.viewModel.detailModel.relatedServices objectAtIndex:index];
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:serviceModel.serviceId channelId:serviceModel.channelId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
    //MTA
    [MTA trackCustomEvent:@"event_skip_stgy_prods_dtl" args:nil];
}

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didSelectedLinkWithSegueModel:(HomeSegueModel *)model {
    [KTCSegueMaster makeSegueWithModel:model fromController:self];
}


#pragma mark StrategyDetailBottomViewDelegate


- (void)didClickedLeftButtonOnStrategyDetailBottomView:(StrategyDetailBottomView *)bottomView {
    [self didClickedCommentButton];
}

- (void)didClickedRightButtonOnStrategyDetailBottomView:(StrategyDetailBottomView *)bottomView {
    if ([self.viewModel.detailModel.relatedServices count] > 0) {
        [self.detailView scrollToRelatedServices];
    } else {
        [self didClickedShareButton];
    }
}


#pragma mark Private methods

- (void)buildRightBarItems {
    CGFloat buttonWidth = 28;
    CGFloat buttonHeight = 28;
    CGFloat buttonGap = 15;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth * 3 + buttonGap * 2, buttonHeight)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat xPosition = 0;
    //comment
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setFrame:CGRectMake(xPosition, 0, buttonWidth, buttonHeight)];
    [commentButton setBackgroundColor:[UIColor clearColor]];
    [commentButton setImage:[UIImage imageNamed:@"comment_n"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(didClickedCommentButton) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:commentButton];
    //like
    xPosition += buttonWidth + buttonGap;
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setFrame:CGRectMake(xPosition, 0, buttonWidth, buttonHeight)];
    [self.likeButton setBackgroundColor:[UIColor clearColor]];
    [self.likeButton setImage:[UIImage imageNamed:@"like_n"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"like_h"] forState:UIControlStateHighlighted];
    [self.likeButton addTarget:self action:@selector(didClickedLikeButton) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.likeButton];
    //share
    xPosition += buttonWidth + buttonGap;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(xPosition, 0, buttonWidth, buttonHeight)];
    [shareButton setBackgroundColor:[UIColor clearColor]];
    [shareButton setImage:[UIImage imageNamed:@"share_n"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(didClickedShareButton) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:shareButton];
    
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    self.navigationItem.rightBarButtonItem = rItem;
}

- (void)didClickedCommentButton {
    CommentDetailViewController *controller = [[CommentDetailViewController alloc] initWithSource:CommentDetailViewSourceStrategy relationType:CommentRelationTypeStrategy headerModel:nil];
    [controller setRelationIdentifier:self.viewModel.detailModel.identifier];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedLikeButton {
    [GToolUtil checkLogin:^(NSString *uid) {
        __weak ParentingStrategyDetailViewController *weakSelf = self;
        [weakSelf.viewModel addOrRemoveFavouriteWithSucceed:^(NSDictionary *data) {
            [weakSelf.likeButton setHighlighted:weakSelf.viewModel.detailModel.isFavourite];
        } failure:^(NSError *error) {
            if ([[error userInfo] count] > 0) {
                [[iToast makeText:[[error userInfo] objectForKey:@"data"]] show];
            }
        }];
    } target:self];
}

- (void)didClickedShareButton {
    CommonShareViewController *controller = [CommonShareViewController instanceWithShareObject:self.viewModel.detailModel.shareObject sourceType:KTCShareServiceTypeStrategy];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)resetBottomView {
    [self.bottomView setHidden:NO];
    if ([self.viewModel.detailModel.relatedServices count] > 0) {
        [self.bottomView.rightLabel setText:@"查看优惠服务"];
        [self.bottomView hideLeftTag:NO rightTag:NO];
    } else {
        [self.bottomView.rightLabel setText:@"分享给好友"];
        [self.bottomView hideLeftTag:NO rightTag:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Super method

- (void)reloadNetworkData {
    [[GAlertLoadingView sharedAlertLoadingView] show];
    __weak ParentingStrategyDetailViewController *weakSelf = self;
    [weakSelf.viewModel startUpdateDataWithStrategyIdentifier:self.strategyId Succeed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf.likeButton setHighlighted:weakSelf.viewModel.detailModel.isFavourite];
        [weakSelf resetBottomView];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf resetBottomView];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
