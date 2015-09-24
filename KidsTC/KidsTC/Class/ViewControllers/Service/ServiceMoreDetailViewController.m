//
//  ServiceMoreDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceMoreDetailViewController.h"
#import "ServiceMoreDetailView.h"
#import "AUIStairsController.h"

@interface ServiceMoreDetailViewController () <ServiceMoreDetailViewDelegate>

@property (weak, nonatomic) IBOutlet ServiceMoreDetailView *moreDetailView;

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, assign) BOOL supportStairsController;

@property (nonatomic, strong) HttpRequestClient *loadDetailRequest;

- (void)loadDetailSucceed:(NSDictionary *)data;

- (void)loadDetailFailed:(NSError *)error;

@end

@implementation ServiceMoreDetailViewController

- (instancetype)initWithServiceId:(NSString *)serviceId supportStairsController:(BOOL)support {
    self = [super initWithNibName:@"ServiceMoreDetailViewController" bundle:nil];
    if (self) {
        self.serviceId = serviceId;        self.supportStairsController = support;
        self.loadDetailRequest = [HttpRequestClient clientWithUrlAliasName:@"PRODUCT_GET_DESC"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.moreDetailView.delegate = self;
    [self.moreDetailView setSupportStairsController:self.supportStairsController];
    __weak ServiceMoreDetailViewController *weakSelf = self;
    [weakSelf.loadDetailRequest startHttpRequestWithParameter:[NSDictionary dictionaryWithObject:self.serviceId forKey:@"pid"] success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadDetailSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadDetailFailed:error];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark ServiceMoreDetailViewDelegate

- (void)didPulledAtHeaderOnServiceMoreDetailView:(ServiceMoreDetailView *)moreDetailView {
    if (self.view.stairsController) {
        [self.view.stairsController backUpstairsAnimated:YES completion:^{
        }];
    }
}

#pragma mark Privated methods

- (void)loadDetailSucceed:(NSDictionary *)data {
    NSString *dataString = [data objectForKey:@"data"];
    if ([dataString isKindOfClass:[NSString class]] && [dataString length] > 0) {
        NSString *htmlString = [NSString stringWithFormat:@"<html>%@</html>", dataString];
        [self.moreDetailView setHtmlString:htmlString];
    }
}

- (void)loadDetailFailed:(NSError *)error {
    
}

#pragma mark Super methods

- (UIView *)stairControledView {
    return self.view;
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
