//
//  CommentDetailViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/29/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentDetailViewModel.h"

@interface CommentDetailViewModel () <CommentDetailViewDataSource>

@property (nonatomic, weak) CommentDetailView *view;

@property (nonatomic, strong) HttpRequestClient *loadReplyRequest;

@property (nonatomic, strong) NSMutableArray *itemModelsArray;

@property (nonatomic, assign) NSUInteger currentPage;

- (NSDictionary *)requestParamWithPageIndex:(NSUInteger)index;;

- (void)loadReplyListSucceed:(NSDictionary *)data;
- (void)loadReplyListFailed:(NSError *)error;
- (void)loadMoreReplyListSucceed:(NSDictionary *)data;
- (void)loadMoreReplyListFailed:(NSError *)error;

- (void)reloadListViewWithData:(NSDictionary *)data;

@end

@implementation CommentDetailViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (CommentDetailView *)view;
        self.view.dataSource = self;
        self.itemModelsArray = [[NSMutableArray alloc] init];
        self.detailModel = [[CommentDetailModel alloc] init];
    }
    return self;
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadReplyRequest) {
        self.loadReplyRequest = [HttpRequestClient clientWithUrlAliasName:@"COMMENT_GET_NEWS"];
    }
    [self.loadReplyRequest cancel];
    self.currentPage = 1;
    NSDictionary *param = [self requestParamWithPageIndex:self.currentPage];
    __weak CommentDetailViewModel *weakSelf = self;
    [weakSelf.loadReplyRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadReplyListSucceed:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadReplyListFailed:error];
        if (failure) {
            failure(error);
        }
        if (weakSelf.netErrorBlock) {
            weakSelf.netErrorBlock(error);
        }
    }];
}


- (void)stopUpdateData {
    [self.loadReplyRequest cancel];
    [self.view endLoadMore];
}


#pragma mark CommentDetailViewDataSource

- (CommentDetailModel *)detailModelForCommentDetailView:(CommentDetailView *)detailView {
    return self.detailModel;
}


#pragma mark Private methods

- (NSDictionary *)requestParamWithPageIndex:(NSUInteger)index {
    if (!self.detailModel.identifier) {
        self.detailModel.identifier = @"";
    }
    CommentRelationType relattionType = CommentRelationTypeNone;
    CommentListType listType = CommentListTypeAll;
    switch (self.detailModel.modelSource) {
        case CommentDetailViewSourceStrategy:
        {
            relattionType = CommentRelationTypeStrategy;
        }
            break;
        case CommentDetailViewSourceStrategyDetail:
        {
            relattionType = CommentRelationTypeStrategyDetail;
        }
            break;
        case CommentDetailViewSourceService:
        {
            relattionType = CommentRelationTypeServiceProduct;
        }
        case CommentDetailViewSourceStore:
        {
            relattionType = CommentRelationTypeStore;
        }
        default:
            break;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.detailModel.identifier, @"relationSysNo",
                           [NSNumber numberWithInteger:relattionType], @"relationType",
                           [NSNumber numberWithInteger:listType], @"commentType",
                           [NSNumber numberWithInteger:index], @"page",
                           [NSNumber numberWithInteger:[self.view pageSize]], @"pageCount", nil];
    return param;
}

- (void)loadReplyListSucceed:(NSDictionary *)data {
    [self.itemModelsArray removeAllObjects];
    self.detailModel.replyModels = nil;
    [self reloadListViewWithData:data];
    [self.view endRefresh];
}

- (void)loadReplyListFailed:(NSError *)error {
    [self.itemModelsArray removeAllObjects];
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -2001:
        {
            //没有数据
            [self.view noMoreData:YES];
        }
            break;
        default:
            break;
    }
    [self reloadListViewWithData:nil];
    [self.view endRefresh];
}

- (void)loadMoreReplyListSucceed:(NSDictionary *)data {
    self.currentPage ++;
    [self reloadListViewWithData:data];
    [self.view endLoadMore];
}

- (void)loadMoreReplyListFailed:(NSError *)error {
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -2001:
        {
            //没有数据
            [self.view noMoreData:YES];
        }
            break;
        default:
            break;
    }
    [self.view endLoadMore];
}

- (void)reloadListViewWithData:(NSDictionary *)data {
    if ([data count] > 0) {
        NSArray *dataArray = [data objectForKey:@"data"];
        if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
            [self.view hideLoadMoreFooter:NO];
            [self.detailModel fillWithReplyRawData:dataArray];
            if ([dataArray count] < [self.view pageSize]) {
                [self.view noMoreData:YES];
            }
        } else {
            [self.view noMoreData:YES];
            [self.view hideLoadMoreFooter:YES];
        }
    } else {
        [self.view hideLoadMoreFooter:YES];
    }
    [self.view reloadData];
    [self stopUpdateData];
}

#pragma mark Public methods

- (NSArray *)resutlItemModels {
    return [NSArray arrayWithArray:self.itemModelsArray];
}

- (void)getMoreReplies {
    if (!self.loadReplyRequest) {
        self.loadReplyRequest = [HttpRequestClient clientWithUrlAliasName:@"COMMENT_GET_NEWS"];
    }
    [self.loadReplyRequest cancel];
    NSUInteger nextPage = self.currentPage + 1;
    NSDictionary *param = [self requestParamWithPageIndex:nextPage];
    __weak CommentDetailViewModel *weakSelf = self;
    [weakSelf.loadReplyRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreReplyListSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreReplyListFailed:error];
    }];
}

@end
