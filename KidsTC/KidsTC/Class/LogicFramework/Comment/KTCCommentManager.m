//
//  KTCCommentManager.m
//  KidsTC
//
//  Created by 钱烨 on 8/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCCommentManager.h"

@interface KTCCommentManager ()

@property (nonatomic, strong) HttpRequestClient *getScoreConfigRequest;

@property (nonatomic, strong) HttpRequestClient *addCommentRequest;

@property (nonatomic, strong) HttpRequestClient *loadCommentsRequest;

- (NSDictionary *)getParamDicFromCommentRequestParam:(KTCCommentRequestParam)param;

@end

@implementation KTCCommentManager

#pragma mark Get Score Setting

- (void)getScoreConfigWithSourceType:(CommentFoundingSourceType)type succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.getScoreConfigRequest) {
        self.getScoreConfigRequest = [HttpRequestClient clientWithUrlAliasName:@"COMMENT_GET_SCORE_CFG"];
    }
    [self.getScoreConfigRequest cancel];
    
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    
    __weak KTCCommentManager *weakSelf = self;
    [weakSelf.getScoreConfigRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)stopGettingScoreConfig {
    
}

#pragma mark Add

- (void)addCommentWithObject:(KTCCommentObject *)object succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.addCommentRequest) {
        self.addCommentRequest = [HttpRequestClient clientWithUrlAliasName:@"COMMENT_ADD"];
    }
    [self.addCommentRequest cancel];
    
    __weak KTCCommentManager *weakSelf = self;
    [weakSelf.addCommentRequest startHttpRequestWithParameter:[object addCommentRequestParam] success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)stopAdding {
    [self.addCommentRequest cancel];
}

#pragma mark Load

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

@implementation KTCCommentObject

- (NSString *)uploadImagesCombinedString {
    if (self.uploadImageStrings && [self.uploadImageStrings isKindOfClass:[NSArray class]]) {
        return [self.uploadImageStrings componentsJoinedByString:@","];
    }
    return @"";
}

- (NSString *)identifier {
    if (!_identifier) {
        return @"";
    }
    return _identifier;
}

- (NSString *)commentIdentifier {
    if (!_commentIdentifier) {
        return @"";
    }
    return _commentIdentifier;
}

- (NSString *)content {
    if (!_content) {
        return @"";
    }
    return _content;
}

- (NSString *)orderId {
    if (!_orderId) {
        return @"";
    }
    return _orderId;
}

- (NSString *)scoreCombinedString {
    if (self.scoresDetail && [self.scoresDetail isKindOfClass:[NSDictionary class]]) {
        if ([self.scoresDetail count] > 0) {
            NSString *jsonString = [GToolUtil jsonFromObject:self.scoresDetail];
            if (!jsonString) {
                jsonString = @"";
            }
            return jsonString;
        }
    }
    return nil;
}

- (NSDictionary *)addCommentRequestParam {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  self.identifier, @"relationSysNo",
                                  [NSNumber numberWithInteger:self.relationType], @"relationType",
                                  [NSNumber numberWithBool:self.isAnonymous], @"isAnonymous",
                                  [NSNumber numberWithBool:self.isComment], @"isComment",
                                  self.content, @"content", nil];
    if (!self.isComment && [self.commentIdentifier length] > 0) {
        [param setObject:self.commentIdentifier forKey:@"commentSysNo"];
    }
    if ([self.orderId length] > 0) {
        [param setObject:self.orderId forKey:@"orderNo"];
    }
    if (self.totalScore > 0) {
        [param setObject:[NSNumber numberWithInteger:self.totalScore] forKey:@"overallScore"];
    }
    if ([[self scoreCombinedString] length] > 0) {
        [param setObject:[self scoreCombinedString] forKey:@"scoreDetail"];
    }
    if ([[self uploadImagesCombinedString] length] > 0) {
        [param setObject:[self uploadImagesCombinedString] forKey:@"image"];
    }
    return param;
}


@end
