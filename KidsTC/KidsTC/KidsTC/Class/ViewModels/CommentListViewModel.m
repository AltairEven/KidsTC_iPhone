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

@property (nonatomic, assign) CommentListViewTag currentTag;

@property (nonatomic, assign) NSUInteger currentAllPage;

@property (nonatomic, assign) NSUInteger currentGoodPage;

@property (nonatomic, assign) NSUInteger currentNormalPage;

@property (nonatomic, assign) NSUInteger currentBadPage;

@property (nonatomic, assign) NSUInteger currentPicturePage;

- (void)clearDataForTag:(CommentListViewTag)tag;

- (void)loadCommentsSucceedWithData:(NSDictionary *)data segmmentTag:(CommentListViewTag)tag;

- (void)loadCommentsFailedWithError:(NSError *)error segmmentTag:(CommentListViewTag)tag;

- (void)loadMoreCommentsSucceedWithData:(NSDictionary *)data segmmentTag:(CommentListViewTag)tag;

- (void)loadMoreCommentsFailedWithError:(NSError *)error segmmentTag:(CommentListViewTag)tag;

- (void)reloadCommentListViewWithData:(NSDictionary *)data forSegmmentTag:(CommentListViewTag)tag;

@end

@implementation CommentListViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (CommentListView *)view;
        self.view.dataSource = self;
        self.commentManager = [[KTCCommentManager alloc] init];
        self.currentTag = CommentListViewTagAll;
        self.currentAllPage = 1;
        self.currentGoodPage = 1;
        self.currentNormalPage = 1;
        self.currentBadPage = 1;
        self.currentPicturePage = 1;
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListViewTagAll];
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListViewTagGood];
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListViewTagNormal];
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListViewTagBad];
        [self.view hideLoadMoreFooter:YES forViewTag:CommentListViewTagPicture];
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

- (NSUInteger)numberOfCommentsOnCommentListView:(CommentListView *)list withTag:(CommentListViewTag)tag {
    NSUInteger number = 0;
    switch (tag) {
        case CommentListViewTagAll:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyAll] integerValue];
        }
            break;
        case CommentListViewTagGood:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyGood] integerValue];
        }
            break;
        case CommentListViewTagNormal:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyNormal] integerValue];
        }
            break;
        case CommentListViewTagBad:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyBad] integerValue];
        }
            break;
        case CommentListViewTagPicture:
        {
            number = [[self.numbersDic objectForKey:CommentListTabNumberKeyPicture] integerValue];
        }
            break;
        default:
            break;
    }
    return number;
}

- (NSArray *)commentListItemModelsOfCommentListView:(CommentListView *)listView withTag:(CommentListViewTag)tag {
    switch (tag) {
        case CommentListViewTagAll:
        {
            return [NSArray arrayWithArray:self.allResultArray];
        }
            break;
        case CommentListViewTagGood:
        {
            return [NSArray arrayWithArray:self.goodResultArray];
        }
            break;
        case CommentListViewTagNormal:
        {
            return [NSArray arrayWithArray:self.normalResultArray];
        }
            break;
        case CommentListViewTagBad:
        {
            return [NSArray arrayWithArray:self.badResultArray];
        }
            break;
        case CommentListViewTagPicture:
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

- (void)clearDataForTag:(CommentListViewTag)tag {
    switch (tag) {
        case CommentListViewTagAll:
        {
            [self.allResultArray removeAllObjects];
        }
            break;
        case CommentListViewTagGood:
        {
            [self.goodResultArray removeAllObjects];
        }
            break;
        case CommentListViewTagNormal:
        {
            [self.normalResultArray removeAllObjects];
        }
            break;
        case CommentListViewTagBad:
        {
            [self.badResultArray removeAllObjects];
        }
            break;
        case CommentListViewTagPicture:
        {
            [self.pictureResultArray removeAllObjects];
        }
            break;
        default:
            break;
    }
}

- (void)loadCommentsSucceedWithData:(NSDictionary *)data segmmentTag:(CommentListViewTag)tag {
    [self clearDataForTag:tag];
    [self reloadCommentListViewWithData:data forSegmmentTag:tag];
}

- (void)loadCommentsFailedWithError:(NSError *)error segmmentTag:(CommentListViewTag)tag {
    [self.view endRefresh];
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
    [self clearDataForTag:tag];
    [self reloadCommentListViewWithData:nil forSegmmentTag:tag];
}

- (void)loadMoreCommentsSucceedWithData:(NSDictionary *)data segmmentTag:(CommentListViewTag)tag {
    switch (tag) {
        case CommentListViewTagAll:
        {
            self.currentAllPage ++;
        }
            break;
        case CommentListViewTagGood:
        {
            self.currentGoodPage ++;
        }
            break;
        case CommentListViewTagNormal:
        {
            self.currentNormalPage ++;
        }
            break;
        case CommentListViewTagBad:
        {
            self.currentBadPage ++;
        }
            break;
        case CommentListViewTagPicture:
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

- (void)loadMoreCommentsFailedWithError:(NSError *)error segmmentTag:(CommentListViewTag)tag {
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

- (void)reloadCommentListViewWithData:(NSDictionary *)data forSegmmentTag:(CommentListViewTag)tag {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        [self.view hideLoadMoreFooter:NO forViewTag:tag];
        for (NSDictionary *singleItem in dataArray) {
            CommentListItemModel *model = [[CommentListItemModel alloc] initWithRawData:singleItem];
            if (model) {
                switch (tag) {
                    case CommentListViewTagAll:
                    {
                        [self.allResultArray addObject:model];
                    }
                        break;
                    case CommentListViewTagGood:
                    {
                        [self.goodResultArray addObject:model];
                    }
                        break;
                    case CommentListViewTagNormal:
                    {
                        [self.normalResultArray addObject:model];
                    }
                        break;
                    case CommentListViewTagBad:
                    {
                        [self.badResultArray addObject:model];
                    }
                        break;
                    case CommentListViewTagPicture:
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
    if (self.currentTag == tag) {
        [self.view reloadDataforViewTag:tag];
        [self.view endRefresh];
        [self.view endLoadMore];
    }
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
    [self.view endRefresh];
    [self.view endLoadMore];
    self.currentTag = (CommentListViewTag)type;
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
    KTCCommentType type = (KTCCommentType)self.currentTag;
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
