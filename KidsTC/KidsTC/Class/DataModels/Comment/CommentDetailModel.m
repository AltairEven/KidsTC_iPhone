//
//  CommentDetailModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentDetailModel.h"

@implementation CommentDetailModel

- (void)setHeaderModel:(id)headerModel {
    _headerModel = headerModel;
    if (headerModel) {
        self.identifier = ((CommentListItemModel *)headerModel).identifier;
    }
}

- (CGFloat)headerCellHeight {
    CGFloat height = 0;
    switch (self.modelSource) {
        case CommentDetailViewSourceStrategyDetail:
        {
            height = [((ParentingStrategyDetailCellModel *)self.headerModel) cellHeight] + 40;
        }
            break;
        case CommentDetailViewSourceService:
        case CommentDetailViewSourceStore:
        {
            height = [((CommentListItemModel *)self.headerModel) contentHeight];
        }
            break;
        default:
            break;
    }
    return height;
}

- (void)fillWithReplyRawData:(NSArray *)dataArray {
    if (!dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
        return;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.replyModels];
    for (NSDictionary *singleEle in dataArray) {
        CommentReplyItemModel *model = [[CommentReplyItemModel alloc] initWithRawData:singleEle];
        if (model) {
            [tempArray addObject:model];
        }
    }
    self.replyModels = [NSArray arrayWithArray:tempArray];
}

@end
