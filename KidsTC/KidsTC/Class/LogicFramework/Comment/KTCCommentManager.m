//
//  KTCCommentManager.m
//  KidsTC
//
//  Created by 钱烨 on 8/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCCommentManager.h"

@interface KTCCommentManager ()

@property (nonatomic, strong) HttpRequestClient *loadCommentsRequest;

- (NSDictionary *)getParamDicFromCommentRequestParam:(KTCCommentRequestParam)param;

@end

@implementation KTCCommentManager

- (void)loadCommentsWithIdentifier:(NSString *)identifier
                      RequestParam:(KTCCommentRequestParam)param
                           succeed:(void (^)(NSDictionary *))succeed
                           failure:(void (^)(NSError *))failure {
    NSDictionary *paramDic = [self getParamDicFromCommentRequestParam:param];
    if (!paramDic) {
        return;
    }
    if (!self.loadCommentsRequest) {
        self.loadCommentsRequest = [HttpRequestClient clientWithUrlAliasName:@"COMMENT_GET_NEWS"];
    }
    [self.loadCommentsRequest cancel];
    
    NSMutableDictionary *finalParam = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [finalParam setObject:identifier forKey:@"relationSysNo"];
    [self.loadCommentsRequest startHttpRequestWithParameter:[NSDictionary dictionaryWithDictionary:finalParam] success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)stopLoading {
    [self.loadCommentsRequest cancel];
}


- (NSDictionary *)getParamDicFromCommentRequestParam:(KTCCommentRequestParam)param {
    if (param.relationType == CommentRelationTypeNone || param.commentType == KTCCommentTypeNone) {
        return nil;
    }
    if (param.pageSize == 0) {
        return nil;
    }
    NSDictionary *retDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:param.relationType], @"relationType",
                            [NSNumber numberWithInteger:param.commentType], @"commentType",
                            [NSNumber numberWithInteger:param.pageIndex], @"page",
                            [NSNumber numberWithInteger:param.pageSize], @"pageCount", nil];
    return retDic;
}

@end
