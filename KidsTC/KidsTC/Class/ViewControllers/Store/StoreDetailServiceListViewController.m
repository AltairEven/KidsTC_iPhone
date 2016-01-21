//
//  StoreDetailServiceListViewController.m
//  KidsTC
//
//  Created by Altair on 1/21/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "StoreDetailServiceListViewController.h"
#import "StoreDetailServiceCell.h"
#import "ServiceDetailViewController.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface StoreDetailServiceListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *listModels;

@end

@implementation StoreDetailServiceListViewController

- (instancetype)initWithListItemModels:(NSArray<StoreOwnedServiceModel *> *)models {
    if (!models || ![models isKindOfClass:[NSArray class]]) {
        return nil;
    }
    self = [super initWithNibName:@"StoreDetailServiceListViewController" bundle:nil];
    if (self) {
        self.listModels = [NSMutableArray arrayWithArray:models];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"优惠服务";
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailServiceCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listModels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreDetailServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailServiceCell" owner:nil options:nil] objectAtIndex:0];
    }
    StoreOwnedServiceModel *model = [self.listModels objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [StoreDetailServiceCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoreOwnedServiceModel *model = [self.listModels objectAtIndex:indexPath.row];
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:model.serviceId channelId:model.channelId];
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
