//
//  CommentDetailModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentListItemModel.h"
#import "ParentingStrategyDetailModel.h"
#import "CommentReplyItemModel.h"
#import "KTCCommentManager.h"

typedef enum {
    CommentDetailViewSourceUnknow,
    CommentDetailViewSourceStrategy,
    CommentDetailViewSourceStrategyDetail,
    CommentDetailViewSourceServiceOrStore
}CommentDetailSource;

@interface CommentDetailModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *relationIdentifier;

@property (nonatomic, strong) id headerModel;

@property (nonatomic, strong) NSArray<CommentReplyItemModel *> *replyModels;

@property (nonatomic, assign) CommentDetailSource modelSource;

@property (nonatomic, assign) CommentRelationType relationType;

@property (nonatomic, assign) CGFloat headerCellHeight;

@property (nonatomic, assign) NSUInteger totalReplyCount;

- (void)fillWithReplyRawData:(NSArray *)dataArray;

@end
