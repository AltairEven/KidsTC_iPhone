//
//  StoreListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreListViewController.h"
#import "StoreListView.h"
#import "StoreListItemModel.h"
#import "StoreDetailViewController.h"

@interface StoreListViewController () <StoreListViewDataSource, StoreListViewDelegate>

@property (weak, nonatomic) IBOutlet StoreListView *listView;

@property (nonatomic, strong) NSArray *listItemModels;

@end

@implementation StoreListViewController

- (instancetype)initWithStoreListItemModels:(NSArray *)models {
    if (!models || ![models isKindOfClass:[NSArray class]]) {
        return nil;
    }
    self = [super initWithNibName:@"StoreListViewController" bundle:nil];
    if (self) {
        self.listItemModels = [NSArray arrayWithArray:models];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"门店列表";
    // Do any additional setup after loading the view from its nib.
    self.listView.dataSource = self;
    self.listView.delegate = self;
    [self.listView setEnableUpdate:NO];
    [self.listView setEnbaleLoadMore:NO];
    [self.listView reloadData];
}


#pragma mark StoreListViewDataSource & StoreListViewDelegate

- (NSUInteger)numberOfStoresInListView:(StoreListView *)listView {
    return [self.listItemModels count];
}

- (StoreListItemModel *)itemModelForStoreListView:(StoreListView *)listView atIndex:(NSUInteger)index {
    return [self.listItemModels objectAtIndex:index];
}


- (void)storeListView:(StoreListView *)listView didSelectedItemAtIndex:(NSUInteger)index {
    StoreListItemModel *model = [self.listItemModels objectAtIndex:index];
    StoreDetailViewController *controller = [[StoreDetailViewController alloc] initWithStoreId:model.identifier];
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
