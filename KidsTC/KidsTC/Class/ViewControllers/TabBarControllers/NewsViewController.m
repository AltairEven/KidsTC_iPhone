//
//  NewsViewController.m
//  KidsTC
//
//  Created by 钱烨 on 9/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsViewController.h"
#import "KTCWebViewController.h"
#import "NewsListTagFilterViewController.h"
#import "KTCSearchViewController.h"

@interface NewsViewController () <NewsViewDelegate>

@property (weak, nonatomic) IBOutlet NewsView *newsView;

@property (nonatomic, strong) NewsViewModel *newsViewModel;

@property (nonatomic, assign) NSUInteger preselectedTagType;

@property (nonatomic, copy) NSString *preselectedTagId;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIdentifier = @"pv_main_found";
    // Do any additional setup after loading the view from its nib.
    self.newsView.delegate = self;
    
    self.newsViewModel = [[NewsViewModel alloc] initWithView:self.newsView];
    if (self.preselectedTagType == 0) {
        [self.newsViewModel refreshNewsWithViewTag:NewsViewTagRecommend newsTagIndex:self.newsViewModel.currentNewsTagIndex];
        [self.newsView resetRoleTypeWithImage:[KTCUserRole smallImageWithUserRole:[KTCUser currentUser].userRole]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (self.preselectedTagType != 0) {
        [self.newsView setCurrentViewTag:NewsViewTagMore];
        [self.newsViewModel activateNewsListViewWithTagType:self.preselectedTagType tagId:self.preselectedTagId];
        NewsTagItemModel *itemModel = [[NewsTagItemModel alloc] init];
        itemModel.type = self.preselectedTagType;
        [self.newsView resetRoleTypeWithImage:[KTCUserRole smallImageWithUserRole:[itemModel relatedUserRole]]];
        //清空
        self.preselectedTagType = 0;
        self.preselectedTagId = @"0";
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.newsViewModel stopUpdateData];
}

#pragma mark NewsViewDelegate

- (void)newsView:(NewsView *)newsView didClickedSegmentControlWithNewsViewTag:(NewsViewTag)viewTag {
    [self.newsViewModel resetNewsViewWithViewTag:viewTag newsTagIndex:self.newsViewModel.currentNewsTagIndex];
    if (viewTag == NewsViewTagRecommend) {
        _pageIdentifier = @"pv_found_recommends";
    } else {
        _pageIdentifier = @"pv_found_kbs";
    }
}

- (void)newsView:(NewsView *)newsView didChangedNewsTagIndex:(NSUInteger)index {
    [self.newsViewModel resetNewsViewWithViewTag:NewsViewTagMore newsTagIndex:index];
    NewsTagItemModel *model = [[self.newsViewModel tagItemModels] objectAtIndex:index];
    [self.newsView resetRoleTypeWithImage:[KTCUserRole smallImageWithUserRole:[model relatedUserRole]]];
}

- (void)newsView:(NewsView *)newsView didSelectedItem:(NewsListItemModel *)item {
    KTCWebViewController *controller = [[KTCWebViewController alloc] init];
    [controller setWebUrlString:item.linkUrl];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)newsView:(NewsView *)newsView needRefreshTableWithNewsViewTag:(NewsViewTag)viewTag tagIndex:(NSUInteger)index {
    [self.newsViewModel refreshNewsWithViewTag:viewTag newsTagIndex:index];
}

- (void)newsView:(NewsView *)newsView needLoadMoreWithNewsViewTag:(NewsViewTag)viewTag tagIndex:(NSUInteger)index {
    [self.newsViewModel getMoreNewsWithViewTag:viewTag newsTagIndex:index];
}

- (void)didClickedUserRoleButton {
    NewsListTagFilterViewController *controller = [[NewsListTagFilterViewController alloc] initWithNewsTagTypeModels:[self.newsViewModel tagTypeModels]];
    [controller setSelectedTagType:[self.newsViewModel currentTagType] - 1];
    [controller setCompletionBlock:^(NewsTagItemModel *itemModel) {
        [self.newsViewModel setTagItemModelsWithModel:itemModel];
        [self.newsView resetRoleTypeWithImage:[KTCUserRole smallImageWithUserRole:[itemModel relatedUserRole]]];
    }];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedSearchButton {
    KTCSearchViewController *controller = [[KTCSearchViewController alloc] initWithSearchType:KTCSearchTypeNews];
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark Public methods

- (void)setSelectedTagType:(NSUInteger)type andTagId:(NSString *)tagId {
    self.preselectedTagType = type;
    self.preselectedTagId = tagId;
}

- (void)setSelectedViewTag:(NewsViewTag)viewTag {
    [self.newsView setCurrentViewTag:viewTag];
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
