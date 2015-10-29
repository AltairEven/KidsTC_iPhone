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

@interface ParentingStrategyDetailViewController () <ParentingStrategyDetailViewDelegate>

@property (weak, nonatomic) IBOutlet ParentingStrategyDetailView *detailView;

@property (nonatomic, strong) ParentingStrategyDetailViewModel *viewModel;

@property (nonatomic, copy) NSString *strategyId;

- (void)buildRightBarItems;

- (void)didClickedCommentButton;

- (void)didClickedLikeButton;

- (void)didClickedShareButton;

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
    // Do any additional setup after loading the view from its nib.
    [self buildRightBarItems];
    self.detailView.delegate = self;
    self.viewModel = [[ParentingStrategyDetailViewModel alloc] initWithView:self.detailView];
    [self.viewModel startUpdateDataWithStrategyIdentifier:self.strategyId Succeed:nil failure:nil];
}

#pragma mark ParentingStrategyDetailViewDelegate

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didSelectedItemAtIndex:(NSUInteger)index {
    ParentingStrategyDetailCellModel *model = [self.viewModel.detailModel.cellModels objectAtIndex:index];
    CommentDetailViewController *controller = [[CommentDetailViewController alloc] initWithSource:CommentDetailViewSourceStrategy headerModel:model];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didClickedLocationButtonAtIndex:(NSUInteger)index {
    
}

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didClickedCommentButtonAtIndex:(NSUInteger)index {
    
}

- (void)parentingStrategyDetailView:(ParentingStrategyDetailView *)detailView didClickedRelatedInfoButtonAtIndex:(NSUInteger)index {
    
}


#pragma mark Private methods

- (void)buildRightBarItems {
    CGFloat buttonWidth = 30;
    CGFloat buttonHeight = 30;
    CGFloat buttonGap = 10;
    
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
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setFrame:CGRectMake(xPosition, 0, buttonWidth, buttonHeight)];
    [likeButton setBackgroundColor:[UIColor clearColor]];
    [likeButton setImage:[UIImage imageNamed:@"like_n"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(didClickedLikeButton) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:likeButton];
    //share
    xPosition += buttonWidth + buttonGap;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(xPosition, 0, buttonWidth, buttonHeight)];
    [shareButton setBackgroundColor:[UIColor clearColor]];
    [shareButton setImage:[UIImage imageNamed:@"share_n"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(didClickedShareButton) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:shareButton];
    
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    self.navigationItem.rightBarButtonItem = rItem;
}

- (void)didClickedCommentButton {
    
}

- (void)didClickedLikeButton {
    
}

- (void)didClickedShareButton {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
