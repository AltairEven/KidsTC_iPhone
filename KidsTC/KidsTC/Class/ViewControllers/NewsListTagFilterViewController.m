//
//  NewsListTagFilterViewController.m
//  KidsTC
//
//  Created by Altair on 11/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsListTagFilterViewController.h"
#import "NewsListTagFilterView.h"

@interface NewsListTagFilterViewController () <NewsListTagFilterViewDataSource, NewsListTagFilterViewDelegate>

@property (weak, nonatomic) IBOutlet NewsListTagFilterView *filterView;

@property (nonatomic, strong) NSArray<NewsTagTypeModel *> *typeModels;

@end

@implementation NewsListTagFilterViewController

- (instancetype)initWithNewsTagTypeModels:(NSArray<NewsTagTypeModel *> *)models {
    self = [super initWithNibName:@"NewsListTagFilterViewController" bundle:nil];
    if (self) {
        self.typeModels = models;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"知识库";
    // Do any additional setup after loading the view from its nib.
    self.filterView.dataSource = self;
    self.filterView.delegate = self;
    [self.filterView reloadData];
}

#pragma mark NewsListTagFilterViewDataSource & NewsListTagFilterViewDelegate

- (NSArray<NewsTagTypeModel *> *)modelsForFilterView:(NewsListTagFilterView *)filterView {
    return self.typeModels;
}

- (void)newsListTagFilterView:(NewsListTagFilterView *)filterView didSelectedNewsTag:(NewsTagItemModel *)itemModel {
    if (self.completionBlock) {
        self.completionBlock(itemModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
