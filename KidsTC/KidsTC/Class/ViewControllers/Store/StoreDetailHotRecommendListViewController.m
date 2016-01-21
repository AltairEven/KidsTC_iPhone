//
//  StoreDetailHotRecommendListViewController.m
//  KidsTC
//
//  Created by Altair on 1/21/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "StoreDetailHotRecommendListViewController.h"
#import "StoreDetailHotRecommendCell.h"
#import "ServiceDetailViewController.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface StoreDetailHotRecommendListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) StoreDetailHotRecommendModel *hotRecommendModel;

@end

@implementation StoreDetailHotRecommendListViewController

- (instancetype)initWithHotRecommendModel:(StoreDetailHotRecommendModel *)model {
    if (!model || ![model isKindOfClass:[StoreDetailHotRecommendModel class]]) {
        return nil;
    }
    self = [super initWithNibName:@"StoreDetailHotRecommendListViewController" bundle:nil];
    if (self) {
        self.hotRecommendModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = self.hotRecommendModel.title;
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([StoreDetailHotRecommendCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.hotRecommendModel.recommendItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreDetailHotRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreDetailHotRecommendCell" owner:nil options:nil] objectAtIndex:0];
    }
    StoreDetailHotRecommendItem *model = [self.hotRecommendModel.recommendItems objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [StoreDetailHotRecommendCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoreDetailHotRecommendItem *model = [self.hotRecommendModel.recommendItems objectAtIndex:indexPath.row];
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
