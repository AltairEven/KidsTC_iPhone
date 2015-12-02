//
//  KTCSearchViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchViewController.h"
#import "SearchViewModel.h"
#import "KTCSearchResultViewController.h"
#import "NewSearchResultViewController.h"

@interface KTCSearchViewController () <KTCSearchViewDelegate>

@property (weak, nonatomic) IBOutlet KTCSearchView *searchView;

@property (nonatomic, strong) SearchViewModel *viewModel;

@property (nonatomic, assign) KTCSearchType defaultSearchType;

@end

@implementation KTCSearchViewController

- (instancetype)initWithSearchType:(KTCSearchType)type {
    self = [super initWithNibName:@"KTCSearchViewController" bundle:nil];
    if (self) {
        self.defaultSearchType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchView.delegate = self;
    self.viewModel = [[SearchViewModel alloc] initWithView:self.searchView defaultSearchType:self.defaultSearchType];
    [self.viewModel setSearchType:self.searchView.type];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel getSearchHistory];
    [self.searchView endEditing];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchView startEditing];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.viewModel updateLocalSearchHistory];
}

#pragma mark KTCSearchViewDelegate

- (void)didClickedCategoryButtonOnKTCSearchView:(KTCSearchView *)searchView {
    
}

- (void)KTCSearchView:(KTCSearchView *)searchView didChangedToSearchType:(KTCSearchType)type {
    [self.viewModel setSearchType:type];
}

- (void)didClickedCancelButtonOnKTCSearchView:(KTCSearchView *)searchView {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didClickedSearchButtonOnKTCSearchView:(KTCSearchView *)searchView {
    NSString *kw = [self.searchView keywords];
    [self.viewModel addSearchHistoryWithType:self.searchView.type keyword:kw];
    KTCSearchCondition *condition = nil;
    switch (self.searchView.type) {
        case KTCSearchTypeService:
        {
            condition = [[KTCSearchServiceCondition alloc] init];
        }
            break;
        case KTCSearchTypeStore:
        {
            condition = [[KTCSearchStoreCondition alloc] init];
        }
            break;
        case KTCSearchTypeNews:
        {
            NewSearchResultViewController *controller = [[NewSearchResultViewController alloc] initWithKeyWord:kw];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
            break;
        default:
            break;
    }
    condition.keyWord = kw;
    
    BOOL needPush = YES;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[KTCSearchResultViewController class]]) {
            needPush = NO;
            KTCSearchResultViewController *resultVC = (KTCSearchResultViewController *)controller;
            resultVC.searchType = self.searchView.type;
            resultVC.searchCondition = condition;
            resultVC.needRefresh = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    if (needPush) {
        KTCSearchResultViewController *controller = [[KTCSearchResultViewController alloc] initWithSearchType:self.searchView.type condition:condition];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)searchView:(KTCSearchView *)searchView didSelectedHotKeyAtIndex:(NSUInteger)index {
    KTCSearchResultViewController *controller = [[KTCSearchResultViewController alloc] initWithNibName:@"KTCSearchResultViewController" bundle:nil];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchView:(KTCSearchView *)searchView didSelectedHistoryAtIndex:(NSUInteger)index {
    KTCSearchResultViewController *controller = [[KTCSearchResultViewController alloc] initWithNibName:@"KTCSearchResultViewController" bundle:nil];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedClearHistoryButtonOnKTCSearchView:(KTCSearchView *)searchView {
    
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
