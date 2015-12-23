//
//  CategoryViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryViewModel.h"
#import "KTCSearchResultViewController.h"

@interface CategoryViewController () <CategoryViewDelegate>

@property (weak, nonatomic) IBOutlet CategoryView *categoryView;

@property (nonatomic, strong) CategoryViewModel *viewModel;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationTitle = @"全部分类";
    _pageIdentifier = @"pv_category";
    // Do any additional setup after loading the view from its nib.
    self.categoryView.delegate = self;
    self.viewModel = [[CategoryViewModel alloc] initWithView:self.categoryView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

#pragma mark CategoryViewDataSource & CategoryViewDelegate


- (void)CategoryView:(CategoryView *)view didClickedAtLevel1Index:(NSUInteger)level1Index subIndex:(NSUInteger)subIndex {
    NSDictionary *searchData = [self.viewModel searchUrlAndParamsOfLevel1Index:level1Index level2Index:subIndex];
    KTCSearchResultViewController *controller = [[KTCSearchResultViewController alloc] initWithSearchType:KTCSearchTypeService condition:[searchData objectForKey:kSearchParamKey]];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
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
