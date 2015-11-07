//
//  KTCCommentManager.h
//  KidsTC
//
//  Created by 钱烨 on 8/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KTCCommentTypeNone,
    KTCCommentTypeAll,
    KTCCommentTypeGood,
    KTCCommentTypeNormal,
    KTCCommentTypeBad,
    KTCCommentTypePicture
}KTCCommentType;

typedef enum {
    CommentRelationTypeNone = 0,
    CommentRelationTypeServiceProduct = 1,
    CommentRelationTypeActivityProduct = 2,
    CommentRelationTypeRealProduct = 3,
    CommentRelationTypeStore = 10,
    CommentRelationTypeStrategy = 11,
    CommentRelationTypeStrategyDetail = 12,
    CommentRelationTypeNews = 13
}CommentRelationType;

typedef struct {
    CommentRelationType relationType;
    KTCCommentType commentType;
    NSUInteger pageIndex;
    NSUInteger pageSize;
}KTCCommentRequestParam;


@interface KTCCommentManager : NSObject

- (void)loadCommentsWithIdentifier:(NSString *)identifier RequestParam:(KTCCommentRequestParam)param succeed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

- (void)stopLoading;

@end