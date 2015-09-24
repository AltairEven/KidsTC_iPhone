//
//  StoreMoreDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreMoreDetailViewController.h"
#import "StoreMoreDetailView.h"

@interface StoreMoreDetailViewController ()

@property (weak, nonatomic) IBOutlet StoreMoreDetailView *moreDetailView;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) HttpRequestClient *loadDetailRequest;

- (void)loadDetailSucceed:(NSDictionary *)data;

- (void)loadDetailFailed:(NSError *)error;

@end

@implementation StoreMoreDetailViewController

- (instancetype)initWithStoreId:(NSString *)storeId {
    self = [super initWithNibName:@"ServiceMoreDetailViewController" bundle:nil];
    if (self) {
        self.storeId = storeId;
        self.loadDetailRequest = [HttpRequestClient clientWithUrlAliasName:@"STORE_GET_DESC"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"门店详情";
    // Do any additional setup after loading the view from its nib.
    __weak StoreMoreDetailViewController *weakSelf = self;
    [weakSelf.loadDetailRequest startHttpRequestWithParameter:[NSDictionary dictionaryWithObject:self.storeId forKey:@"storeno"] success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadDetailSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadDetailFailed:error];
    }];
}

- (void)loadDetailSucceed:(NSDictionary *)data {
    NSString *dataString = [data objectForKey:@"data"];
    if ([dataString isKindOfClass:[NSString class]] && [dataString length] > 0) {
        NSString *htmlString = [NSString stringWithFormat:@"<html>%@</html>", dataString];
        [self.moreDetailView setHtmlString:htmlString];
    }
}

- (void)loadDetailFailed:(NSError *)error {
    
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
