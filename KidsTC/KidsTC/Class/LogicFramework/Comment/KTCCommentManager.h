//
//  KTCCommentManager.h
//  KidsTC
//
//  Created by 钱烨 on 8/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KTCCommentObjectNULL = -1,
    KTCCommentObjectService,
    KTCCommentObjectStore
}KTCCommentObject;

typedef enum {
    KTCCommentTypeNone,
    KTCCommentTypeAll,
    KTCCommentTypeGood,
    KTCCommentTypeNormal,
    KTCCommentTypeBad,
    KTCCommentTypePicture
}KTCCommentType;

typedef struct {
    KTCCommentObject object;
    KTCCommentType type;
    NSUInteger pageIndex;
    NSUInteger pageSize;
}KTCCommentRequestParam;


@interface KTCCommentManager : NSObject

- (void)loadCommentsWithIdentifier:(NSString *)identifier RequestParam:(KTCCommentRequestParam)param succeed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

- (void)stopLoading;

@end