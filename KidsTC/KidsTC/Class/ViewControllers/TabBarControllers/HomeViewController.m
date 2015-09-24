//
//  HomeViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "KTCSearchViewController.h"
#import "CategoryViewController.h"
#import "AUIFloorNavigationView.h"


@interface HomeViewController () <HomeViewDelegate, AUIFloorNavigationViewDataSource, AUIFloorNavigationViewDelegate>

@property (weak, nonatomic) IBOutlet HomeView *homeView;
@property (weak, nonatomic) IBOutlet AUIFloorNavigationView *floorNavigationView;

@property (nonatomic, strong) HomeViewModel *viewModel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.homeView.delegate = self;
    self.floorNavigationView.dataSource = self;
    self.floorNavigationView.delegate = self;
    [self.floorNavigationView setEnableCollapse:YES];
    [self.floorNavigationView setAnimateDirection:AUIFloorNavigationViewAnimateDirectionDown];
    
    self.viewModel = [[HomeViewModel alloc] initWithView:self.homeView];
    
    [self.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
        [self.floorNavigationView reloadData];
        [self.floorNavigationView setSelectedIndex:0];
    } failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
}

#pragma mark HomeViewDelegate

- (void)didClickedCategoryButtonOnHomeView:(HomeView *)homeView {
    CategoryViewController *controller = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedInputFieldOnHomeView:(HomeView *)homeView {
    KTCSearchViewController *controller = [[KTCSearchViewController alloc] initWithNibName:@"KTCSearchViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)didClickedMessageButtonOnHomeView:(HomeView *)homeView {
    
}

- (void)homeViewDidPulledDownToRefresh:(HomeView *)homeView {
    [self.viewModel refreshHomeData];
}

- (void)homeViewDidPulledUpToloadMore:(HomeView *)homeView {
    //[self.viewModel getCustomerRecommendWithSucceed:nil failure:nil];
}

- (void)homeView:(HomeView *)homeView didSelectedAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)homeView:(HomeView *)homeView didSelectedAtIndexPath:(NSIndexPath *)indexPath subIndex:(NSUInteger)subIndex {
}

- (void)homeView:(HomeView *)homeView didScrolled:(CGPoint)offset {
    [self.floorNavigationView collapse:YES];
}

- (void)homeView:(HomeView *)homeView didScrolledIntoVisionWithSectionGroupIndex:(NSUInteger)index {
    [self.floorNavigationView setSelectedIndex:index];
}

- (void)homeView:(HomeView *)homeView didEndDeDidEndDecelerating:(BOOL)downDirection {
    if (downDirection) {
        [self.floorNavigationView setSelectedIndex:0];
    } else {
        [self.floorNavigationView setSelectedIndex:[[self.viewModel sectionModelsArray] count] - 3];
    }
}

#pragma mark AUIFloorNavigationViewDataSource & AUIFloorNavigationViewDelegate

- (NSUInteger)numberOfItemsOnFloorNavigationView:(AUIFloorNavigationView *)navigationView {
    return 5;
}

- (UIView *)floorNavigationView:(AUIFloorNavigationView *)navigationView viewForItemAtIndex:(NSUInteger)index {
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [itemView setBackgroundColor:[UIColor orangeColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:itemView.frame];
    [label setText:[NSString stringWithFormat:@"孕%lu", (unsigned long)index]];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [itemView addSubview:label];
    
    itemView.layer.cornerRadius = 20;
    itemView.layer.borderWidth = 2;
    itemView.layer.borderColor = [UIColor yellowColor].CGColor;
    itemView.layer.masksToBounds = YES;
    
    return itemView;
}

- (UIView *)floorNavigationView:(AUIFloorNavigationView *)navigationView highlightViewForItemAtIndex:(NSUInteger)index {
    UIView *highlightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [highlightView setBackgroundColor:[UIColor redColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:highlightView.frame];
    [label setText:[NSString stringWithFormat:@"孕%lu", (unsigned long)index]];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [highlightView addSubview:label];
    
    highlightView.layer.cornerRadius = 20;
    highlightView.layer.borderWidth = 2;
    highlightView.layer.borderColor = [UIColor yellowColor].CGColor;
    highlightView.layer.masksToBounds = YES;
    
    return highlightView;
}

- (UIView *)floorNavigationView:(AUIFloorNavigationView *)navigationView viewForItemGapAtIndex:(NSUInteger)index {
    UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
    [gapView setBackgroundColor:[UIColor greenColor]];
    return gapView;
}

- (void)floorNavigationView:(AUIFloorNavigationView *)navigationView didSelectedAtIndex:(NSUInteger)index {
    [self.homeView scrollHomeViewToSectionGroupIndex:index];
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
