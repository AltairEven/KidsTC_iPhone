//
//  KTCSearchViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchViewController.h"
#import "KTCSearchView.h"
#import "KTCSearchResultViewController.h"

@interface KTCSearchViewController () <KTCSearchViewDataSource, KTCSearchViewDelegate>

@property (weak, nonatomic) IBOutlet KTCSearchView *searchView;

@end

@implementation KTCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchView.dataSource = self;
    self.searchView.delegate = self;
    [self.searchView setCategoryArray:[NSArray arrayWithObjects:@"服务", @"门店", nil]];
    [self.searchView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
}

#pragma mark

- (NSArray *)hotKeysArrayForKTCSearchView:(KTCSearchView *)searchView {
    return [NSArray arrayWithObjects:@"户外", @"儿童摄影", @"室外", @"生日派对", @"宝宝理发", @"家政月嫂", nil];
}

- (NSArray *)historiesArrayForKTCSearchView:(KTCSearchView *)searchView {
    return [NSArray arrayWithObjects:@"户外", @"儿童摄影", @"室外", @"生日派对", @"宝宝理发", @"家政月嫂", nil];
}

- (void)didClickedCategoryButtonOnKTCSearchView:(KTCSearchView *)searchView {
    
}

- (void)didClickedCancelButtonOnKTCSearchView:(KTCSearchView *)searchView {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didClickedSearchButtonOnKTCSearchView:(KTCSearchView *)searchView {
    NSString *kw = [self.searchView keywords];
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
        default:
            break;
    }
    condition.keyWord = kw;
    KTCSearchResultViewController *controller = [[KTCSearchResultViewController alloc] initWithSearchType:self.searchView.type condition:condition];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
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
