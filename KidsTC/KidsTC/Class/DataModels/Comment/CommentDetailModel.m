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
        
        switch (self.modelSource) {
            case CommentDetailViewSourceStrategyDetail:
            {
                self.headerCellHeight = [((ParentingStrategyDetailCellModel *)self.headerModel) cellHeight] + 40;
            }
                break;
            case CommentDetailViewSourceService:
            case CommentDetailViewSourceStore:
            {
                CGFloat height = 50 + 30;
                //Label
                NSString *comments = ((CommentListItemModel *)headerModel).comments;
                CGFloat labelHeight = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 andText:comments];
                
                CGFloat imageHeight = 0;
                CGFloat imageSlideSize = SCREEN_WIDTH - 20;
                NSUInteger count = [((CommentListItemModel *)headerModel).originalPhotoUrlStringsArray count];
                if (count > 0) {
                    imageHeight = count * imageSlideSize + (count - 1) * 5;
                }
                self.headerCellHeight = height + labelHeight + imageHeight;
            }
                break;
            default:
                break;
        }
    }
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
