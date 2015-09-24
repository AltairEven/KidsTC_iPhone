//
//  ServiceListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceListViewController.h"
#import "ServiceListView.h"
#import "ServiceListItemModel.h"
#import "ServiceDetailViewController.h"

@interface ServiceListViewController () <ServiceListViewDataSource, ServiceListViewDelegate>

@property (weak, nonatomic) IBOutlet ServiceListView *listView;

@property (nonatomic, strong) NSArray *listItemModels;

@end

@implementation ServiceListViewController

- (instancetype)initWithListItemModels:(NSArray *)models {
    if (!models || ![models isKindOfClass:[NSArray class]]) {
        return nil;
    }
    self = [super initWithNibName:@"ServiceListViewController" bundle:nil];
    if (self) {
        self.listItemModels = [NSArray arrayWithArray:models];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"服务列表";
    // Do any additional setup after loading the view from its nib.
    self.listView.dataSource = self;
    self.listView.delegate = self;
    [self.listView setEnableUpdate:NO];
    [self.listView setEnbaleLoadMore:NO];
    [self.listView reloadData];
}

#pragma mark ServiceListViewDataSource & ServiceListViewDelegate

- (NSUInteger)numberOfServiceInListView:(ServiceListView *)listView {
    return [self.listItemModels count];
}

- (ServiceListItemModel *)itemModelForServiceListView:(ServiceListView *)listView atIndex:(NSUInteger)index {
    return [self.listItemModels objectAtIndex:index];
}

- (void)serviceListView:(ServiceListView *)listView didSelectedItemAtIndex:(NSUInteger)index {
    ServiceListItemModel *model = [self.listItemModels objectAtIndex:index];
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:model.identifier channelId:model.channelId];
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
