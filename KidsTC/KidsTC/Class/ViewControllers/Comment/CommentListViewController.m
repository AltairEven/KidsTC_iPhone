//
//  CommentListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CommentListViewController.h"
#import "MWPhotoBrowser.h"
#import "CommentDetailViewController.h"

@interface CommentListViewController () <CommentListViewDelegate>

@property (weak, nonatomic) IBOutlet CommentListView *listView;

@property (nonatomic, strong) CommentListViewModel *viewModel;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) CommentRelationType relationType;

@property (nonatomic, strong) NSDictionary *commentNumberDic;

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@end

@implementation CommentListViewController

- (instancetype)initWithIdentifier:(NSString *)identifier relationType:(CommentRelationType)type commentNumberDic:(NSDictionary *)numberDic {
    self = [super initWithNibName:@"CommentListViewController" bundle:nil];
    if (self) {
        self.identifier = identifier;
        self.relationType = type;
        self.commentNumberDic = numberDic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"用户评价";
    _pageIdentifier = @"pv_prod_evaluations";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    self.viewModel = [[CommentListViewModel alloc] initWithView:self.listView];
    [self.viewModel setIdentifier:self.identifier];
    [self.viewModel setRelationType:self.relationType];
    [self.viewModel setNumbersDic:self.commentNumberDic];
    [self.viewModel startUpdateDataWithType:KTCCommentTypeAll];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listView reloadSegmentHeader];
}


#pragma mark CommentListViewDataSource & CommentListViewDelegate

- (void)commentListView:(CommentListView *)listView willShowWithTag:(CommentListViewTag)tag {
    [self.viewModel resetResultWithType:(KTCCommentType)tag];
}

- (void)commentListView:(CommentListView *)listView DidPullDownToRefreshforViewTag:(CommentListViewTag)tag {
    [self.viewModel startUpdateDataWithType:(KTCCommentType)tag];
}

- (void)commentListView:(CommentListView *)listView DidPullUpToLoadMoreforViewTag:(CommentListViewTag)tag {
    [self.viewModel getMoreDataWithType:(KTCCommentType)tag];
}

- (void)commentListView:(CommentListView *)listView didClickedCellAtIndex:(NSUInteger)cellIndex {
    CommentListItemModel *model = [[self.viewModel resultOfCurrentType] objectAtIndex:cellIndex];
    CommentDetailViewController *controller = [[CommentDetailViewController alloc] initWithSource:CommentDetailViewSourceServiceOrStore relationType:self.relationType headerModel:model];
    [controller setRelationIdentifier:self.identifier];
    [controller setCommentIdentifier:model.identifier];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)commentListView:(CommentListView *)listView didClickedImageAtCellIndex:(NSUInteger)cellIndex andImageIndex:(NSUInteger)imageIndex {
    NSArray *result = [self.viewModel resultOfCurrentType];
    CommentListItemModel *model = [result objectAtIndex:cellIndex];
    self.photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:model.photosArray];
    [self.photoBrowser setCurrentPhotoIndex:imageIndex];
    [self presentViewController:self.photoBrowser animated:YES completion:nil];
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
