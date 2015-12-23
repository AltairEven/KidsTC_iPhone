/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：CommonParser.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-18-2012
 */

#import "CommonParser.h"
#import "Constants.h"
#import "GToolUtil.h"
#import "UIDevice+IdentifierAddition.h"
#import "UserWrapper.h"
#import "ASIDataProvider.h"



@implementation CommonParser

- (id) init
{
    self = [super init];
    if (self != nil) {
        _reqGetDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"iPhone", @"appSource", [GConfig getCurrentAppVersionCode], @"appVersion", nil];
        _reqPostDict = [[NSMutableDictionary alloc] init];
        
        _enableUrlKeyMapping = YES;
    }
    
    return self;
}

- (NSDictionary*) userInfo {
    return nil;
}

- (NSString*) requestGroup {
    return @"JsonGroup";
}

- (NSTimeInterval) timeoutDuration {
    return 10;
}

- (NSString*) udid {
    return [UIDevice currentDevice].uniqueDeviceIdentifier;
}

- (NSNumber*) uid {
    return [NSNumber numberWithInteger:[UserWrapper shareMasterUser].uid];
}

- (NSMutableArray*) cookiesForUrl:(NSURL*)url
{
    if ([url host] == nil) {
        return nil;
    }
//    NSError *error = NULL;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\.]+\\.(51buy|yixun)\\.com" options:NSRegularExpressionCaseInsensitive  error:&error];
//	NSUInteger numberOfMatches = [regex numberOfMatchesInString:[url host] options:0 range:NSMakeRange(0, [[url host] length])];
//    
//	if( numberOfMatches < 1){
//		return nil;
//	}
    
    return [HttpCookieWrapper icsonCookies];
}

- (NSString*) keyForUrl:(NSString*)urlStr
{
    if (urlStr) {
        if (_enableCoocieSiteUrlKey && _enableCoocieUserUrlKey) {
            return [urlStr stringByAppendingFormat:@"&%@", [HttpCookieWrapper identifyStrForUserAndSite]];
        }
        if (_enableCoocieSiteUrlKey) {
            return [urlStr stringByAppendingFormat:@"&%@", [HttpCookieWrapper identifyStrForSite]];
        }
        if (_enableCoocieUserUrlKey) {
            return [urlStr stringByAppendingFormat:@"&%@", [HttpCookieWrapper identifyStrForUser]];
        }
        return [urlStr stringByAppendingFormat:@"&%@", [HttpCookieWrapper identifyStrDefault]];
    }

    return urlStr;
}

- (NSOperationQueuePriority)priority {
    return NSOperationQueuePriorityNormal;
}

- (DownloadOption*) downloadOption {
    return DownloadOptionPost;
}


#pragma mark - Download logic

- (void)preprocessRequest:(ASIHTTPRequest*)request
{
    // add post data if needed
    if ([request isKindOfClass:[ASIFormDataRequest class]]) {
        ASIFormDataRequest * postReq = (ASIFormDataRequest*)request;
        [postReq setStringEncoding:CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)];
        if (_reqPostDict.count > 0) {
            for (id k in _reqPostDict) {
                [postReq setPostValue: [_reqPostDict objectForKey: k] forKey: k];
            }
        }
    }
 
    request.queuePriority = [self priority];
    
    [request setTimeOutSeconds:[self timeoutDuration]];
    
    NSDictionary * userInfo = [self userInfo];
    if (userInfo) [request setUserInfo:userInfo];
    
    NSMutableArray * cookies = [self cookiesForUrl:request.url];
    if (cookies) {
        [request setUseCookiePersistence:NO];
        [request setRequestCookies:cookies];
    }
}

- (void)nocacheRequestWithURL:(NSString *)url completion:(void (^)(NSDictionary *))completion fail:(void (^)(NSError *))fail withName:(NSString*)name
{
    if (nil == url || url.length == 0) {
        fail(nil);
        return;
    }
	
	BOOL b = [GToolUtil filterBlackList:url];
	if(!b)
	{
		fail(nil);
		return ;
	}
	
    
    if (!NetWorkConnected) {
        if (fail) {
            fail(ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_COMMON, ERRCODE_DATA_INVALID, @"无法连接服务器，请检查网络连接"));
        }
        return;
    }

    NSString * newUrl = url;
    if (_reqGetDict.count > 0) {
        newUrl = [GToolUtil addQueryStringToUrl:url params:_reqGetDict];
    }
    
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
    __weak typeof(request) weakReq = request;
    
    [self preprocessRequest:request];
    
//    MTAAppMonitorStat * mtaStat = nil;
//    if (name) {
//        mtaStat = [[MTAAppMonitorStat alloc] init];
//        [mtaStat setInterface:name];
//    }
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];

    [request setCompletionBlock:^{
//        if (mtaStat) {
//            mtaStat.consumedMilliseconds = (uint64_t)(([NSDate timeIntervalSinceReferenceDate]-startTime) *1000);
//            mtaStat.responsePackageSize = [weakReq.responseData length];
//            [mtaStat setResultType:MTA_SUCCESS];
//            [MTA reportAppMonitorStat:mtaStat];
//        }
        NSError * err = weakReq.error;
        if (weakReq.responseStatusCode == HttpStatusOK || weakReq.responseStatusCode == HttpStatusNotModified) {
            if (weakReq.responseData) {
                NSDictionary * allDict = [weakReq.responseData toJSONObjectFO];
                if (allDict && [allDict isKindOfClass:[NSDictionary class]]) {
                    NSInteger errNo = [[allDict objectForKey: @"errno"] integerValue];
                    NSDictionary * dataDict = [allDict objectForKey: @"data"];
                    if (0 == errNo) {
                        if (completion) completion(_needRawData ? allDict : (dataDict ? dataDict : allDict));
                        return;
                    } else {
                        // 重新激活QQ用户登录态
                        if (errNo == 500) {
                            [[UserWrapper shareMasterUser] logout];
                        }
                        
                        if (fail) fail(ERROR_WITH_TYPE_AND_CODE_AND_USERINFO(ERR_COMMON, errNo, allDict));
                    }
                } else {
                    if (fail) fail(ERROR_WITH_TYPE_AND_CODE(ERR_COMMON, ERRCODE_JSON_INVALID));
                }
            } else {
                if (fail) fail(ERROR_WITH_TYPE_AND_CODE(ERR_COMMON, ERRCODE_DATA_INVALID));
            }

        } else {
            if (fail) fail(err);
        }
    }];
    
    [request setFailedBlock:^{
        NSError * err = weakReq.error;
        if (fail) {
            fail(err);
        }
//        if (mtaStat) {
//            mtaStat.consumedMilliseconds = (uint64_t)(([NSDate timeIntervalSinceReferenceDate]-startTime) *1000);
//            mtaStat.responsePackageSize = [weakReq.responseData length];
//            [mtaStat setResultType:MTA_FAILURE];
//            mtaStat.returnCode = err.code;
//            [MTA reportAppMonitorStat:mtaStat];
//        }
    }];

    [[ASIDataProvider sharedASIDataProvider] addASIRequest:request withGroup:[self requestGroup]];
}

- (void)requestWithURL:(NSString *)url completion:(void (^)(NSDictionary *))completion fail:(void (^)(NSError *))fail withName:(NSString*)name
{
    [self requestWithURL:url completion:completion fail:fail expireDuration:0 withName:name];
}

- (void)requestWithURL:(NSString *)url completion:(void (^)(NSDictionary *))completion fail:(void (^)(NSError *))fail expireDuration:(NSTimeInterval)expire withName:(NSString*)name
{
    if (nil == url || url.length == 0) {
        fail(nil);
        return;
    }
    
    NSString * newUrl = url;
    if (_reqGetDict.count > 0) {
        newUrl = [GToolUtil addQueryStringToUrl:url params:_reqGetDict];
    }

    keyMakersBlock kBlock = nil;
    if (_enableUrlKeyMapping) {
        kBlock = ^NSString *(NSString * url) {
            return [self keyForUrl:url];
        };
    }
    
    DownloadOption *option = [self downloadOption];
    
    NSString * localUrl = nil;
    if (expire > 30 && eDownLoadStatComplete == [[DownLoadManager sharedDownLoadManager] urlStat:newUrl keyMaker:kBlock withLocalUrl:&localUrl] && localUrl) {
        NSDictionary * info = [DownLoadManager fileStatForPath:localUrl];
        
        NSDate * modifyDate = [info objectForKey:@"modifyDate"];
        if (!modifyDate || fabs([modifyDate timeIntervalSinceNow]) > expire) {
            option.callbackOption = eCallbackNewDataIfExist;
        } else {
            option.callbackOption = eCallbackOldDataNoFetchNew;
        }
    }
    
//    MTAAppMonitorStat * mtaStat = nil;
//    if (name) {
//        mtaStat = [[MTAAppMonitorStat alloc] init];
//        [mtaStat setInterface:name];
//    }
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    [[DownLoadManager sharedDownLoadManager] downloadWithUrl:newUrl group:[self requestGroup] successBlock:^(NSData * data) {
//        if (mtaStat) {
//            mtaStat.consumedMilliseconds = (uint64_t)(([NSDate timeIntervalSinceReferenceDate]-startTime) *1000);
//            mtaStat.responsePackageSize = [data length];
//            [mtaStat setResultType:MTA_SUCCESS];
//            [MTA reportAppMonitorStat:mtaStat];
//        }
        if (data) {
            NSDictionary * allDict = [data toJSONObjectFO];
            if (allDict && [allDict isKindOfClass:[NSDictionary class]]) {
                NSInteger errNo = [[allDict objectForKey: @"errno"] integerValue];
                NSDictionary * dataDict = [allDict objectForKey: @"data"];
                if (0 == errNo) {
                    if (completion) completion(_needRawData ? allDict : (dataDict ? dataDict : allDict));
//                    if (completion) completion(dataDict ? dataDict : allDict);
                    return;
                } else {
                    if (fail) fail(ERROR_WITH_TYPE_AND_CODE_AND_USERINFO(ERR_COMMON, errNo, (dataDict ? dataDict : allDict)));
                }
            } else {
                if (fail) fail(ERROR_WITH_TYPE_AND_CODE(ERR_COMMON, ERRCODE_JSON_INVALID));
            }
        } else {
            if (fail) fail(ERROR_WITH_TYPE_AND_CODE(ERR_COMMON, ERRCODE_DATA_INVALID));
        }
        // 如果数据正确，之前就返回了
		[[DownLoadManager sharedDownLoadManager] removeByUrl:newUrl keyMaker:kBlock];

    } failureBlock:^(NSError * err) {
        if (fail) {
            fail(err);
        }
//        if (mtaStat) {
//            mtaStat.consumedMilliseconds = (uint64_t)(([NSDate timeIntervalSinceReferenceDate]-startTime) *1000);
//            [mtaStat setResultType:MTA_FAILURE];
//            mtaStat.returnCode = err.code;
//            [MTA reportAppMonitorStat:mtaStat];
//        }
    } option:option preporcessBlock:^(ASIHTTPRequest * request) {
        [self preprocessRequest:request];
    } keyMaker:kBlock];
}

+ (BOOL) checkValidData:(id)data forRule:(NSDictionary*)rule
{
    //NSDictionary * ruleSample = @{@"data": [NSArray class], @"subs": [NSArray class], @"condition": [NSArray class]};
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dataDict = (NSDictionary*)data;
        [dataDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
        }];
    }
    return YES;
}

@end
