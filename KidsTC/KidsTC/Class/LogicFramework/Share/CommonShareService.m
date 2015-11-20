//
//  CommonShareService.m
//  KidsTC
//
//  Created by Altair on 11/20/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommonShareService.h"
#import "CommonShareObject.h"
#import "TencentManager.h"
#import "WeChatManager.h"
#import "WeiboManager.h"


NSString *const kCommonShareTypeWechatSessionKey = @"kCommonShareTypeWechatSessionKey";
NSString *const kCommonShareTypeWechatTimeLineKey = @"kCommonShareTypeWechatTimeLineKey";
NSString *const kCommonShareTypeWeiboKey = @"kCommonShareTypeWeiboKey";
NSString *const kCommonShareTypeQQKey = @"kCommonShareTypeQQKey";
NSString *const kCommonShareTypeQZoneKey = @"kCommonShareTypeQZoneKey";

static CommonShareService *_sharedInstance = nil;

@implementation CommonShareService

+ (instancetype)sharedService {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[CommonShareService alloc] init];
    });
    
    return _sharedInstance;
}

+ (NSArray<NSNumber *> *)availableShareTypes {
    NSMutableArray *availableArray = [[NSMutableArray alloc] init];
    //微信
    if ([WeChatManager canShare]) {
        [availableArray addObject:[NSNumber numberWithInteger:CommonShareTypeWechatSession]];
        [availableArray addObject:[NSNumber numberWithInteger:CommonShareTypeWechatTimeLine]];
    }
    //微博
    if ([WeiboManager canShare]) {
        [availableArray addObject:[NSNumber numberWithInteger:CommonShareTypeWeibo]];
    }
    //QQ
    if ([TencentManager canShare]) {
        [availableArray addObject:[NSNumber numberWithInteger:CommonShareTypeQQ]];
        [availableArray addObject:[NSNumber numberWithInteger:CommonShareTypeQZone]];
    }
    return [NSArray arrayWithArray:availableArray];
}

+ (NSDictionary *)shareTypeAvailablities {
    NSMutableDictionary *availableDic = [[NSMutableDictionary alloc] init];
    //微信
    BOOL canShare = [WeChatManager canShare];
    [availableDic setObject:[NSNumber numberWithBool:canShare] forKey:kCommonShareTypeWechatSessionKey];
    [availableDic setObject:[NSNumber numberWithBool:canShare] forKey:kCommonShareTypeWechatTimeLineKey];
    //微博
    canShare = [WeiboManager canShare];
    [availableDic setObject:[NSNumber numberWithBool:canShare] forKey:kCommonShareTypeWeiboKey];
    //QQ
    canShare = [TencentManager canShare];
    [availableDic setObject:[NSNumber numberWithBool:canShare] forKey:kCommonShareTypeQQKey];
    [availableDic setObject:[NSNumber numberWithBool:canShare] forKey:kCommonShareTypeQZoneKey];
    
    return [NSDictionary dictionaryWithDictionary:availableDic];
}

- (BOOL)startThirdPartyLoginWithShareType:(CommonShareType)type
                                   object:(CommonShareObject *)object
                                  Succeed:(void (^)())succeed
                                  failure:(void (^)(NSError *))failure {
    if (!object) {
        NSError *error = [NSError errorWithDomain:@"Common Share" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"无效的分享内容" forKey:kErrMsgKey]];
        if (failure) {
            failure(error);
        }
        return NO;
    }
    BOOL retValue = NO;
    switch (type) {
        case CommonShareTypeWechatSession:
        {
            WeChatWebPageShareObject *shareObject = [WeChatWebPageShareObject webPageShareObjectWithTitle:object.title description:object.shareDescription thumbImage:object.thumbImage webPageUrlString:object.webPageUrlString];
            retValue = [[WeChatManager sharedManager] sendShareRequestToScene:WechatShareSceneSession WithObject:shareObject succeed:succeed failure:failure];
        }
            break;
        case CommonShareTypeWechatTimeLine:
        {
            WeChatWebPageShareObject *shareObject = [WeChatWebPageShareObject webPageShareObjectWithTitle:object.title description:object.shareDescription thumbImage:object.thumbImage webPageUrlString:object.webPageUrlString];
            retValue = [[WeChatManager sharedManager] sendShareRequestToScene:WechatShareSceneTimeline WithObject:shareObject succeed:succeed failure:failure];
        }
            break;
        case CommonShareTypeWeibo:
        {
            WeiboWebPageShareObject *shareObject = [WeiboWebPageShareObject webPageShareObjectWithFollowingContent:object.followingContent identifier:object.identifier title:object.title urlString:object.webPageUrlString];
            shareObject.thumbnailImage = object.thumbImage;
            retValue = [[WeiboManager sharedManager] sendShareRequestWithObject:shareObject succeed:succeed failure:failure];
        }
            break;
        case CommonShareTypeQQ:
        {
            TencentWebPageShareObject *shareObject = [TencentWebPageShareObject webPageShareObjectWithTitle:object.title shareDescription:object.shareDescription pageUrlString:object.webPageUrlString thumbImage:object.thumbImage thumbImageUrlString:nil];
            retValue = [[TencentManager sharedManager] sendShareRequestToScene:TencentShareSceneQQ WithObject:shareObject succeed:succeed failure:failure];
        }
            break;
        case CommonShareTypeQZone:
        {
            TencentWebPageShareObject *shareObject = [TencentWebPageShareObject webPageShareObjectWithTitle:object.title shareDescription:object.shareDescription pageUrlString:object.webPageUrlString thumbImage:object.thumbImage thumbImageUrlString:nil];
            retValue = [[TencentManager sharedManager] sendShareRequestToScene:TencentShareSceneQZone WithObject:shareObject succeed:succeed failure:failure];
        }
            break;
        default:
            break;
    }
    return retValue;
}

@end