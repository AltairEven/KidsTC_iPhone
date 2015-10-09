//
//  ParentingStrategyDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailViewController.h"
#import "ParentingStrategyDetailViewModel.h"

@interface ParentingStrategyDetailViewController ()

@property (weak, nonatomic) IBOutlet ParentingStrategyDetailView *detailView;

@property (nonatomic, strong) ParentingStrategyDetailViewModel *viewModel;

@property (nonatomic, copy) NSString *strategyId;

@end

@implementation ParentingStrategyDetailViewController

- (instancetype)initWithStrategyIdentifier:(NSString *)identifier {
    self = [super initWithNibName:@"ParentingStrategyDetailViewController" bundle:nil];
    if (self) {
        self.strategyId = identifier;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewModel = [[ParentingStrategyDetailViewModel alloc] initWithView:self.detailView];
    [self.viewModel startUpdateDataWithStrategyIdentifier:self.strategyId Succeed:nil failure:nil];
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
