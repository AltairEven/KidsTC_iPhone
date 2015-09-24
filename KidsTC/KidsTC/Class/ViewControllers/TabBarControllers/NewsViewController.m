//
//  NewsViewController.m
//  KidsTC
//
//  Created by 钱烨 on 9/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsViewModel.h"
#import "KTCWebViewController.h"

@interface NewsViewController () <NewsViewDelegate>

@property (weak, nonatomic) IBOutlet NewsView *newsView;

@property (nonatomic, strong) NewsViewModel *newsViewModel;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.newsView.delegate = self;
    
    self.newsViewModel = [[NewsViewModel alloc] initWithView:self.newsView];
    [self.newsViewModel startUpdateDataWithSucceed:nil failure:nil];
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

#pragma mark NewsViewDelegate

- (void)newsView:(NewsView *)newsView didClickedSegmentControlWithNewsViewTag:(NewsViewTag)viewTag {
    
}

- (void)newsView:(NewsView *)newsView didSelectedItem:(NewsListItemModel *)item {
    KTCWebViewController *controller = [[KTCWebViewController alloc] init];
    [controller setWebUrlString:item.linkUrl];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)newsView:(NewsView *)newsView needRefreshTableWithNewsViewTag:(NewsViewTag)viewTag {
    
}

- (void)newsView:(NewsView *)newsView needLoadMoreWithNewsViewTag:(NewsViewTag)viewTag {
    
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
