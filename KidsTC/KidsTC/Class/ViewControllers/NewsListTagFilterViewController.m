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

@property (nonatomic, strong) HttpRequestClient *loadNewsTagRequest;

- (void)getNewsTags;

- (void)parseTagsWithData:(NSDictionary *)data;

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
    _pageIdentifier = @"pv_found_kbs_filter";
    // Do any additional setup after loading the view from its nib.
    self.filterView.dataSource = self;
    self.filterView.delegate = self;
    [self.filterView reloadData];
    [self.filterView setSelectedTagIndex:self.selectedTagType];
    if ([self.typeModels count] == 0) {
        [self getNewsTags];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
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

#pragma mark Private methods

#pragma mark Private methods

- (void)getNewsTags {
    if (!self.loadNewsTagRequest) {
        self.loadNewsTagRequest = [HttpRequestClient clientWithUrlAliasName:@"ARTICLE_GET_KNOWLEDGE"];
    } else {
        [self.loadNewsTagRequest cancel];
    }
    __weak NewsListTagFilterViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [weakSelf.loadNewsTagRequest startHttpRequestWithParameter:nil success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf parseTagsWithData:responseData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

- (void)parseTagsWithData:(NSDictionary *)data {
    self.typeModels = nil;
    
    NSArray *array = [data objectForKey:@"data"];
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *singleTypeElem in array) {
            NewsTagTypeModel *typeModel = [[NewsTagTypeModel alloc] initWithRawData:singleTypeElem];
            if (typeModel) {
                [tempArray addObject:typeModel];
            }
        }
        self.typeModels = [NSArray arrayWithArray:tempArray];
    }
    [self.filterView reloadData];
    [self.filterView setSelectedTagIndex:self.selectedTagType];
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
