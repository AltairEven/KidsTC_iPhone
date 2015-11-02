//
//  CommentListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentListViewModel.h"
#import "MWPhotoBrowser.h"

@interface CommentListViewController () <CommentListViewDelegate>

@property (weak, nonatomic) IBOutlet CommentListView *listView;

@property (nonatomic, strong) CommentListViewModel *viewModel;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) KTCCommentObject commentObject;

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@end

@implementation CommentListViewController

- (instancetype)initWithIdentifier:(NSString *)identifier object:(KTCCommentObject)object {
    self = [super initWithNibName:@"CommentListViewController" bundle:nil];
    if (self) {
        self.identifier = identifier;
        self.commentObject = object;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"用户评价";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    self.viewModel = [[CommentListViewModel alloc] initWithView:self.listView];
    [self.viewModel setIdentifier:self.identifier];
    [self.viewModel startUpdateDataWithType:KTCCommentTypeAll];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listView reloadSegmentHeader];
}


#pragma mark CommentListViewDataSource & CommentListViewDelegate

- (void)commentListView:(CommentListView *)listView willShowWithTag:(CommentListType)tag {
    [self.viewModel resetResultWithType:(KTCCommentType)(tag + 1)];
}

- (void)commentListView:(CommentListView *)listView DidPullDownToRefreshforViewTag:(CommentListType)tag {
    [self.viewModel startUpdateDataWithType:(KTCCommentType)(tag + 1)];
}

- (void)commentListView:(CommentListView *)listView DidPullUpToLoadMoreforViewTag:(CommentListType)tag {
    [self.viewModel getMoreDataWithType:(KTCCommentType)(tag + 1)];
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
