//
//  CommentDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 10/29/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "AUIKeyboardAdhesiveView.h"

@interface CommentDetailViewController () <CommentDetailViewDelegate>

@property (weak, nonatomic) IBOutlet CommentDetailView *detailView;
@property (nonatomic, strong) CommentDetailViewModel *viewModel;

@property (nonatomic, strong) AUIKeyboardAdhesiveView *keyboardAdhesiveView;

@property (nonatomic, strong) id headerModel;

@end

@implementation CommentDetailViewController

- (instancetype)initWithSource:(CommentDetailSource)source headerModel:(id)model {
    self = [super initWithNibName:@"CommentDetailViewController" bundle:nil];
    if (self) {
        _viewSource = source;
        self.headerModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navigationTitle = @"用户评价";
    // Do any additional setup after loading the view from its nib.
    self.detailView.delegate = self;
    self.viewModel = [[CommentDetailViewModel alloc] initWithView:self.detailView];
    [self.viewModel.detailModel setModelSource:self.viewSource];
    [self.viewModel.detailModel setHeaderModel:self.headerModel];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.keyboardAdhesiveView) {
        self.keyboardAdhesiveView = [[AUIKeyboardAdhesiveView alloc] initWithAvailableFuntions:nil];
        [self.keyboardAdhesiveView.headerView setBackgroundColor:[AUITheme theme].globalThemeColor];
        [self.keyboardAdhesiveView setTextLimitLength:100];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.keyboardAdhesiveView) {
        [self.keyboardAdhesiveView destroy];
    }
}

#pragma mark CommentDetailViewDelegate

- (void)commentDetailView:(CommentDetailView *)detailView didSelectedReplyAtIndex:(NSUInteger)index {
    CommentReplyItemModel *model = [self.viewModel.detailModel.replyModels objectAtIndex:index];
    [self.keyboardAdhesiveView setPlaceholder:[NSString stringWithFormat:@"回复%@：",model.userName]];
    [self.keyboardAdhesiveView expand];
}

- (void)didTappedOnCommentDetailView:(CommentDetailView *)detailView {
    [self.keyboardAdhesiveView setPlaceholder:@"回复楼主："];
    [self.keyboardAdhesiveView expand];
}

- (void)commentDetailViewDidPulledDownToRefresh:(CommentDetailView *)detailView {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)commentDetailViewDidPulledUpToloadMore:(CommentDetailView *)detailView {
    [self.viewModel getMoreReplies];
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
