//
//  CommentListViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CommentListViewModel.h"
#import "KTCCommentManager.h"

#define PageSize (10)

@interface CommentListViewModel () <CommentListViewDataSource>

@property (nonatomic, weak) CommentListView *view;

@property (nonatomic, strong) KTCCommentManager *commentManager;

@property (nonatomic, strong) NSMutableArray *allResultArray;

@property (nonatomic, strong) NSMutableArray *goodResultArray;

@property (nonatomic, strong) NSMutableArray *normalResultArray;

@property (nonatomic, strong) NSMutableArray *badResultArray;

@property (nonatomic, strong) NSMutableArray *pictureResultArray;

@property (nonatomic, assign) CommentListType currentTag;

@property (nonatomic, assign) NSUInteger currentAllPage;

@property (nonatomic, assign) NSUInteger currentGoodPage;

@property (nonatomic, assign) NSUInteger currentNormalPage;

@property (nonatomic, assign) NSUInteger currentBadPage;

@property (nonatomic, assign) NSUInteger currentPicturePage;

- (void)clearDataForTag:(CommentListType)tag;

- (void)loadCommentsSucceedWithData:(NSDictionary *)data segmmentTag:(CommentListType)tag;

- (void)loadCommentsFailedWithError:(NSError *)error segmmentTag:(CommentListType)tag;

- (void)loadMoreCommentsSucceedWithData:(NSDictionary *)data segmmentTag:(CommentListType)tag;

- (void)loadMoreCommentsFailedWithError:(NSError *)error segmmentTag:(CommentListType)tag;

- (void)reloadCommentListViewWithData:(NSDictionary *)data forSegmmentTag:(CommentListType)tag;

@end

@implementation CommentListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (CommentListView *)view;
        self.view.dataSource = self;
        self.commentManager = [[KTCCommentManager alloc] init];
        self.currentTag = CommentListTypeAll;
        self.currentAllPage = 1;
        self.currentGoodPage = 1;
        self.currentNormalPage = 1;
        self.currentBadPage = 1;
        self.currentPicturePage = 1;
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListTypeAll];
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListTypeGood];
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListTypeNormal];
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListTypeBad];
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListTypePicture];
        self.allResultArray = [[NSMutableArray alloc] init];
        self.goodResultArray = [[NSMutableArray alloc] init];
        self.normalResultArray = [[NSMutableArray alloc] init];
        self.badResultArray = [[NSMutableArray alloc] init];
        self.pictureResultArray = [[NSMutableArray alloc] init];
        
        [self.view reloadSegmentHeader];
    }
    return self;
}

#pragma mark CommentListViewDataSource

- (NSUInteger)numberOfCommentsOnCommentListView:(CommentListView *)list withTag:(CommentListType)tag {
    NSUInteger number = 0;
    switch (tag) {
        case CommentListTypeAll:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyAll] integerValue];
        }
            break;
        case CommentListTypeGood:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyGood] integerValue];
        }
            break;
        case CommentListTypeNormal:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyNormal] integerValue];
        }
            break;
        case CommentListTypeBad:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyBad] integerValue];
        }
            break;
        case CommentListTypePicture:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyPicture] integerValue];
        }
            break;
        default:
            break;
    }
    return number;
}

- (NSArray *)commentListItemModelsOfCommentListView:(CommentListView *)listView withTag:(CommentListType)tag {
    switch (tag) {
        case CommentListTypeAll:
        {
            return [NSArray arrayWithArray:self.allResultArray];
        }
            break;
        case CommentListTypeGood:
        {
            return [NSArray arrayWithArray:self.goodResultArray];
        }
            break;
        case CommentListTypeNormal:
        {
            return [NSArray arrayWithArray:self.normalResultArray];
        }
            break;
        case CommentListTypeBad:
        {
            return [NSArray arrayWithArray:self.badResultArray];
        }
            break;
        case CommentListTypePicture:
        {
            return [NSArray arrayWithArray:self.pictureResultArray];
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark Private methods

- (void)clearDataForTag:(CommentListType)tag {
    switch (tag) {
        case CommentListTypeAll:
        {
            [self.allResultArray removeAllObjects];
        }
            break;
        case CommentListTypeGood:
        {
            [self.goodResultArray removeAllObjects];
        }
            break;
        case CommentListTypeNormal:
        {
            [self.normalResultArray removeAllObjects];
        }
            break;
        case CommentListTypeBad:
        {
            [self.badResultArray removeAllObjects];
        }
            break;
        case CommentListTypePicture:
        {
            [self.pictureResultArray removeAllObjects];
        }
            break;
        default:
            break;
    }
}

- (void)loadCommentsSucceedWithData:(NSDictionary *)data segmmentTag:(CommentListType)tag {
    [self clearDataForTag:tag];
    [self reloadCommentListViewWithData:data forSegmmentTag:tag];
}

- (void)loadCommentsFailedWithError:(NSError *)error segmmentTag:(CommentListType)tag {
    [self clearDataForTag:tag];
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -1003:
        {
            //没有数据
            [self.view noMoreData:YES forViewTag:tag];
        }
            break;
        default:
            break;
    }
    [self reloadCommentListViewWithData:nil forSegmmentTag:tag];
    [self.view endRefresh];
}

- (void)loadMoreCommentsSucceedWithData:(NSDictionary *)data segmmentTag:(CommentListType)tag {
    switch (tag) {
        case CommentListTypeAll:
        {
            self.currentAllPage ++;
        }
            break;
        case CommentListTypeGood:
        {
            self.currentGoodPage ++;
        }
            break;
        case CommentListTypeNormal:
        {
            self.currentNormalPage ++;
        }
            break;
        case CommentListTypeBad:
        {
            self.currentBadPage ++;
        }
            break;
        case CommentListTypePicture:
        {
            self.currentPicturePage ++;
        }
            break;
        default:
            break;
    }
    [self reloadCommentListViewWithData:data forSegmmentTag:tag];
    [self.view endLoadMore];
}

- (void)loadMoreCommentsFailedWithError:(NSError *)error segmmentTag:(CommentListType)tag {
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -1003:
        {
            //没有数据
            [self.view noMoreData:YES forViewTag:tag];
        }
            break;
        default:
            break;
    }
    [self reloadCommentListViewWithData:nil forSegmmentTag:tag];
    [self.view endLoadMore];
}

- (void)reloadCommentListViewWithData:(NSDictionary *)data forSegmmentTag:(CommentListType)tag {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        [self.view hideLoadMoreFooter:NO forViewTag:tag];
        for (NSDictionary *singleItem in dataArray) {
            CommentListItemModel *model = [[CommentListItemModel alloc] initWithRawData:singleItem];
            if (model) {
                switch (tag) {
                    case CommentListTypeAll:
                    {
                        [self.allResultArray addObject:model];
                    }
                        break;
                    case CommentListTypeGood:
                    {
                        [self.goodResultArray addObject:model];
                    }
                        break;
                    case CommentListTypeNormal:
                    {
                        [self.normalResultArray addObject:model];
                    }
                        break;
                    case CommentListTypeBad:
                    {
                        [self.badResultArray addObject:model];
                    }
                        break;
                    case CommentListTypePicture:
                    {
                        [self.pictureResultArray addObject:model];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        if ([dataArray count] < PageSize) {
            [self.view noMoreData:YES forViewTag:tag];
        } else {
            [self.view noMoreData:NO forViewTag:tag];
        }
    }
    [self.view reloadDataforViewTag:tag];
    [self.view endRefresh];
    [self.view endLoadMore];
}

#pragma mark Public methods

- (void)startUpdateDataWithType:(KTCCommentType)type {
    KTCCommentRequestParam param;
    param.relationType = self.relationType;
    param.commentType = type;
    param.pageSize = PageSize;
    switch (type) {
        case KTCCommentTypeAll:
        {
            param.pageIndex = self.currentAllPage;
        }
            break;
        case KTCCommentTypeGood:
        {
            param.pageIndex = self.currentGoodPage;
        }
            break;
        case KTCCommentTypeNormal:
        {
            param.pageIndex = self.currentNormalPage;
        }
            break;
        case KTCCommentTypeBad:
        {
            param.pageIndex = self.currentBadPage;
        }
            break;
        case KTCCommentTypePicture:
        {
            param.pageIndex = self.currentPicturePage;
        }
            break;
        default:
            break;
    }
    
    __weak CommentListViewModel *weakSelf = self;
    [weakSelf.commentManager loadCommentsWithIdentifier:self.identifier RequestParam:param succeed:^(NSDictionary *data) {
        [weakSelf loadCommentsSucceedWithData:data segmmentTag:weakSelf.currentTag];
    } failure:^(NSError *error) {
        [weakSelf loadCommentsFailedWithError:error segmmentTag:weakSelf.currentTag];
    }];
}

- (void)getMoreDataWithType:(KTCCommentType)type {
    KTCCommentRequestParam param;
    param.relationType = self.relationType;
    param.commentType = type;
    param.pageSize = PageSize;
    switch (type) {
        case KTCCommentTypeAll:
        {
            param.pageIndex = self.currentAllPage + 1;
        }
            break;
        case KTCCommentTypeGood:
        {
            param.pageIndex = self.currentGoodPage + 1;
        }
            break;
        case KTCCommentTypeNormal:
        {
            param.pageIndex = self.currentNormalPage + 1;
        }
            break;
        case KTCCommentTypeBad:
        {
            param.pageIndex = self.currentBadPage + 1;
        }
            break;
        case KTCCommentTypePicture:
        {
            param.pageIndex = self.currentPicturePage + 1;
        }
            break;
        default:
            break;
    }
    
    __weak CommentListViewModel *weakSelf = self;
    [weakSelf.commentManager loadCommentsWithIdentifier:self.identifier RequestParam:param succeed:^(NSDictionary *data) {
        [weakSelf loadCommentsSucceedWithData:data segmmentTag:weakSelf.currentTag];
    } failure:^(NSError *error) {
        [weakSelf loadCommentsFailedWithError:error segmmentTag:weakSelf.currentTag];
    }];
}

- (void)resetResultWithType:(KTCCommentType)type {
    self.currentTag = (CommentListType)(type - 1);
    [self stopUpdateData];
    switch (type) {
        case KTCCommentTypeAll:
        {
            if ([self.allResultArray count] > 0) {
                [self.view reloadDataforViewTag:self.currentTag];
            } else {
                [self startUpdateDataWithType:type];
            }
        }
            break;
        case KTCCommentTypeGood:
        {
            if ([self.goodResultArray count] > 0) {
                [self.view reloadDataforViewTag:self.currentTag];
            } else {
                [self startUpdateDataWithType:type];
            }
        }
            break;
        case KTCCommentTypeNormal:
        {
            if ([self.normalResultArray count] > 0) {
                [self.view reloadDataforViewTag:self.currentTag];
            } else {
                [self startUpdateDataWithType:type];
            }
        }
            break;
        case KTCCommentTypeBad:
        {
            if ([self.badResultArray count] > 0) {
                [self.view reloadDataforViewTag:self.currentTag];
            } else {
                [self startUpdateDataWithType:type];
            }
        }
            break;
        case KTCCommentTypePicture:
        {
            if ([self.pictureResultArray count] > 0) {
                [self.view reloadDataforViewTag:self.currentTag];
            } else {
                [self startUpdateDataWithType:type];
            }
        }
            break;
        default:
            break;
    }
}

- (NSArray *)resultOfCurrentType {
    NSArray *array = nil;
    KTCCommentType type = self.currentTag + 1;
    switch (type) {
        case KTCCommentTypeAll:
        {
            array = [NSArray arrayWithArray:self.allResultArray];
        }
            break;
        case KTCCommentTypeGood:
        {
            array = [NSArray arrayWithArray:self.goodResultArray];
        }
            break;
        case KTCCommentTypeNormal:
        {
            array = [NSArray arrayWithArray:self.normalResultArray];
        }
            break;
        case KTCCommentTypeBad:
        {
            array = [NSArray arrayWithArray:self.badResultArray];
        }
            break;
        case KTCCommentTypePicture:
        {
            array = [NSArray arrayWithArray:self.pictureResultArray];
        }
            break;
        default:
            break;
    }
    return array;
}


#pragma mark Super methods

- (void)stopUpdateData {
    [self.commentManager stopLoading];
    [self.view endRefresh];
    [self.view endLoadMore];
}


@end
