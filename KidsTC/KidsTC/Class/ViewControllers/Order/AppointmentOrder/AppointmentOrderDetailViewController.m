//
//  AppointmentOrderDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppointmentOrderDetailViewController.h"
#import "AppointmentOrderDetailViewModel.h"

@interface AppointmentOrderDetailViewController () <AppointmentOrderDetailViewDelegate>

@property (weak, nonatomic) IBOutlet AppointmentOrderDetailView *detailView;

@property (nonatomic, strong) AppointmentOrderDetailViewModel *viewModel;

@property (nonatomic, strong) AppointmentOrderModel *orderModel;

@end

@implementation AppointmentOrderDetailViewController

- (instancetype)initWithAppointmentOrderModel:(AppointmentOrderModel *)model {
    if (!model) {
        return nil;
    }
    self = [super initWithNibName:@"AppointmentOrderDetailViewController" bundle:nil];
    if (self) {
        self.orderModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"预约订单";
    // Do any additional setup after loading the view from its nib.
    self.detailView.delegate = self;
    self.viewModel = [[AppointmentOrderDetailViewModel alloc] initWithView:self.detailView];
    [self.viewModel setOrderModel:self.orderModel];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

#pragma mark

- (void)didClickedStoreOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView {
    
}

- (void)didClickedCommentButtonOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView {
    
}

- (void)didClickedCancelButtonOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView {
    
}

- (void)didClickedGetCodeButtonOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView {
    
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
