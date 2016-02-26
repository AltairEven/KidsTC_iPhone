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

- (void)searchWithKeyword:(NSString *)kw saveHistory:(BOOL)save;

- (void)resetHotSearchKeyWord;

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
    _pageIdentifier = @"pv_search";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetHotSearchKeyWord) name:kSearchHotKeysHasChangedNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    self.searchView.delegate = self;
    self.viewModel = [[SearchViewModel alloc] initWithView:self.searchView defaultSearchType:self.defaultSearchType];
    [self.viewModel setSearchType:self.searchView.type];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
    [self resetHotSearchKeyWord];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSearchHotKeysHasChangedNotification object:nil];
}

#pragma mark KTCSearchViewDelegate

- (void)didClickedCategoryButtonOnKTCSearchView:(KTCSearchView *)searchView {
    
}

- (void)KTCSearchView:(KTCSearchView *)searchView didChangedToSearchType:(KTCSearchType)type {
    [self.viewModel setSearchType:type];
    [self resetHotSearchKeyWord];
}

- (void)didClickedCancelButtonOnKTCSearchView:(KTCSearchView *)searchView {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didClickedSearchButtonOnKTCSearchView:(KTCSearchView *)searchView {
    NSString *kw = [self.searchView keywords];
    if ([kw length] == 0) {
        KTCSearchCondition *condition = [[KTCSearchService sharedService] mostHotSearchConditionOfSearchType:self.viewModel.searchType];
        kw = condition.keyWord;
        [self searchWithKeyword:kw saveHistory:NO];
    } else {
        [self searchWithKeyword:kw saveHistory:YES];
    }
}

- (void)searchView:(KTCSearchView *)searchView didSelectedHotKeyAtIndex:(NSUInteger)index {
    NSDictionary *searchParam = [[[KTCSearchService sharedService] hotSearchConditionsOfSearchType:self.viewModel.searchType] objectAtIndex:index];
    BOOL needPush = YES;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[KTCSearchResultViewController class]]) {
            needPush = NO;
            KTCSearchResultViewController *resultVC = (KTCSearchResultViewController *)controller;
            resultVC.searchType = self.searchView.type;
            resultVC.searchCondition = [searchParam objectForKey:kSearchHotKeyCondition];
            resultVC.needRefresh = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        } else if ([controller isKindOfClass:[NewSearchResultViewController class]]) {
            needPush = NO;
            NewSearchResultViewController *resultVC = (NewSearchResultViewController *)controller;
            resultVC.searchCondition = [searchParam objectForKey:kSearchHotKeyCondition];
            resultVC.needRefresh = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    if (needPush) {
        if (self.viewModel.searchType == KTCSearchTypeNews) {
            NewSearchResultViewController *controller = [[NewSearchResultViewController alloc] initWithSearchCondition:[searchParam objectForKey:kSearchHotKeyCondition]];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            KTCSearchResultViewController *controller = [[KTCSearchResultViewController alloc] initWithSearchType:self.searchView.type condition:[searchParam objectForKey:kSearchHotKeyCondition]];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)searchView:(KTCSearchView *)searchView didSelectedHistoryAtIndex:(NSUInteger)index {
    NSString *kw = [[self.viewModel searchHistory] objectAtIndex:index];
    [self searchWithKeyword:kw saveHistory:NO];
}

- (void)didClickedClearHistoryButtonOnKTCSearchView:(KTCSearchView *)searchView {
    [self.viewModel clearSearchHistory];
}

#pragma mark Private methods

- (void)searchWithKeyword:(NSString *)kw saveHistory:(BOOL)save {
    if (save) {
        [self.viewModel addSearchHistoryWithType:self.searchView.type keyword:kw];
    }
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
            condition = [[KTCSearchNewsCondition alloc] init];
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
        } else if ([controller isKindOfClass:[NewSearchResultViewController class]]) {
            needPush = NO;
            NewSearchResultViewController *resultVC = (NewSearchResultViewController *)controller;
            resultVC.searchCondition = (KTCSearchNewsCondition *)condition;
            resultVC.needRefresh = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    if (needPush) {
        if (self.viewModel.searchType == KTCSearchTypeNews) {
            NewSearchResultViewController *controller = [[NewSearchResultViewController alloc] initWithSearchCondition:(KTCSearchNewsCondition *)condition];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            KTCSearchResultViewController *controller = [[KTCSearchResultViewController alloc] initWithSearchType:self.searchView.type condition:condition];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)resetHotSearchKeyWord {
    KTCSearchServiceCondition *hotSearchCondition = (KTCSearchServiceCondition *)[[KTCSearchService sharedService] mostHotSearchConditionOfSearchType:self.viewModel.searchType];
    NSString *hotSearchKeyWord = @"";
    if (hotSearchCondition) {
        hotSearchKeyWord = hotSearchCondition.name;
    }
    if ([hotSearchKeyWord length] == 0) {
        hotSearchKeyWord = @"请输入关键词";
    }
    [self.searchView setTopInputFiledContent:hotSearchKeyWord isPlaceHolder:YES];
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
