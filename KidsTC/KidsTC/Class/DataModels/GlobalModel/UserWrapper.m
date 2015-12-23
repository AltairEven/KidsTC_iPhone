//
//  UserWrapper.m
//  iphone
//
//  Created by icson apple on 12-2-17.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "UserWrapper.h"
#import "GPageCache.h"
#import "GErrCode.h"
#import "Constants.h"
#import "UIDevice+IdentifierAddition.h"
#import "AppDelegate.h"
#import "HttpRequestWrapper.h"
#import "AddressManager.h"
#import "HttpIcsonCookieManager.h"

NSString *const kLocalKeyDistrictId = @"districtId";

static NSString * const qqScheme = @"qq2icson";     // 手q返回scheme

static NSString * const kDefaultSiteName = @"上海";

@interface UserWrapper ()
@property (nonatomic, weak) ASIHTTPRequest *icsonLoginASIRequest;
@property (nonatomic, weak) ASIHTTPRequest *qqLoginASIRequest;
@property (nonatomic, weak) ASIHTTPRequest *wechatLoginASIRequest;
@end

@implementation UserWrapper
@synthesize uid, skey, token, delegate, siteID,lastUid;
@synthesize icsonLoginRequest = _icsonLoginRequest;
@synthesize dispatchSiteRequest = _dispatchSiteRequest;
@synthesize qqLoginRequest = _qqLoginRequest;
@synthesize wechatLoginRequest = _wechatLoginRequest;
@synthesize icsonLoginASIRequest;
@synthesize qqLoginASIRequest;
@synthesize wechatLoginASIRequest;
@synthesize provinceId = _provinceId, districtId = _districtId;
@synthesize currentDivision = _currentDivision;


static UserWrapper* _shareMasterUser = nil;
static NSArray *_gsProvices = nil; //所有省份的名字
static NSDictionary *_gsDeliveryDic = nil; //送货省份和站点id，以及区域id


#pragma mark - login related
+ (UserWrapper *)shareMasterUser
{
    @synchronized([UserWrapper class])
    {
        if (!_shareMasterUser) {
            _shareMasterUser = [[self alloc] init];
        }
        
        // ...
        return _shareMasterUser;
    }
    
    return nil;
}

- (id) init {
    self = [super init];
    if (self)
    {
         //本次版本后，url换成了这个： ivy 2015-5-19
//        _icsonLoginRequest = [[HttpRequestWrapper alloc] initWithUrl:URL_APP_LOGIN
//                                                              method:[[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_APP_LOGIN"]
//                                                        urlAliasName:@"URL_APP_LOGIN"];
        //NSString *urlString =@"http://mb.51buy.com/json.php?mod=login&act=loginIcsonVcode";
        
        NSString *urlString =URL_VCODE_LOGIN;
        _icsonLoginRequest = [[HttpRequestWrapper alloc] initWithUrl:urlString
                                                              method:HttpRequestMethodPOST
                                                        urlAliasName:@"URL_VCODE_LOGIN"];
        
        _qqLoginRequest = [[HttpRequestWrapper alloc] initWithUrl:URL_TX_LOGIN
                                                           method:[[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_TX_LOGIN"]
                                                     urlAliasName:@"URL_TX_LOGIN"];
       /* _qqLoginRequest = [[HttpRequestWrapper alloc] initWithUrl:@"http://app.51buy.com/json.php?login=alogin&act=txlogin"                                                           method:[[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_WT_LOGIN"]
                                                     urlAliasName:@"URL_WT_LOGIN"];
       */ _dispatchSiteRequest = [[HttpRequestWrapper alloc] initWithUrl:URL_DISPATCH_SITE
                                                                method:[[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_DISPATCH_SITE"]
                                                          urlAliasName:@"URL_DISPATCH_SITE"];
        
        _wechatLoginRequest = [[HttpRequestWrapper alloc] initWithUrl:URL_WECHAT_LOGIN
                                                               method:[[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_WECHAT_LOGIN"]
                                                         urlAliasName:@"URL_WECHAT_LOGIN"];
    }
    
    return self;
}

- (void) removeDelegate:(id)deleg
{
    if (delegate == deleg) {
        delegate = nil;
    }
}

- (void)initUser
{
    //获取本地存储的当前地址信息
    self.districtId = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalKeyDistrictId];
    //user login information
    NSString * suid = [GPageCache get: GLOBAL_CACHE_KEY_UID];
    self.skey = suid == nil ? nil : [GPageCache get: GLOBAL_CACHE_KEY_SKEY];
    self.token = self.skey == nil ? nil : [GPageCache get: GLOBAL_CACHE_KEY_TOKEN];
    self.loginUserType = [[GPageCache get: GLOBAL_CACHE_KEY_LOGIN_TYPE] intValue];
    self.qqAccount = [GPageCache get: GLOBAL_CACHE_KEY_QQ];
    self.lastQqAccount = [GPageCache get: GLOBAL_CACHE_KEY_LAST_QQ];
    
    //cookie expired
    if( !suid || !self.skey || !self.token  ){
        //clear stored data
        self.uid =  0;
        NSString * sLastUid = [GPageCache get: GLOBAL_CACHE_KEY_LAST_UID];
        self.lastUid = [sLastUid intValue];
        self.skey = self.token = nil;
        return;
    }
    

    self.uid = [suid integerValue];
    self.lastUid = self.uid;
    [GPageCache set:GLOBAL_CACHE_KEY_LAST_UID forValue: [NSString stringWithFormat:@"%ld", (long)uid]];
    
    
    [[HttpIcsonCookieManager sharedManager] setupCookies]; //设置cookie
    
    if(self.loginStatusCheckRequest == nil)
    {
        self.loginStatusCheckRequest = [[HttpRequestWrapper alloc] initWithUrl:URL_LOGIN_GETSTATUS
                                                                        method:[[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_LOGIN_GETSTATUS"]
                                                                  urlAliasName:URL_LOGIN_GETSTATUS];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:suid, @"uid",nil];
    [self.loginStatusCheckRequest startProcess:param target:self onSuccess:@selector(loginCheckStatusFinished:) onFailed:@selector(loginCheckStatusFailed:)];
}

- (void)loginCheckStatusFinished:(NSDictionary*)result
{
    AsyncUserDeviceInfoLogin;
    NSLog(@"%@",result);
//    [[HttpIcsonCookieManager sharedManager] setIcsonCookiesWithNamesAndValues:kHttpIcsonCookieKeyUid, [NSString stringWithFormat:@"%ld", (long)uid], kHttpIcsonCookieKeySkey, skey, kHttpIcsonCookieKeyToken, token, nil];
}

- (void)loginCheckStatusFailed:(NSError*)error
{
    NSLog(@"%@",error);
    [self logout];
}

- (void)dealloc
{
    [_icsonLoginRequest cancel];
    [_qqLoginRequest cancel];
    [_dispatchSiteRequest cancel];
    [_wechatLoginRequest cancel];
}

- (void)readLoginCookieFromResponse:(NSArray*)cookie {
    
    //当用户从新登陆的时候，我们需要清掉启动来源
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.yid = @"";
    appDelegate.loginSource = @"";
    appDelegate.accessToken = @"";
    NSArray *values = [HttpCookieWrapper getValues:[NSArray arrayWithObjects:GLOBAL_COOKIE_NAME_UID, GLOBAL_COOKIE_NAME_SKEY, GLOBAL_COOKIE_NAME_TOKEN, nil] forCookie:cookie];
    
    if( [GToolUtil isEmpty:[values objectAtIndex:0]] || [GToolUtil isEmpty:[values objectAtIndex:1]]  || [GToolUtil isEmpty:[values objectAtIndex:2]]  ){
        uid = 0;
        skey = token = nil;
    }
    
    self.uid = [ [values objectAtIndex:0] integerValue];
    self.lastUid = self.uid;
    self.skey = [values objectAtIndex:1];
    self.token = [values objectAtIndex:2];
}

- (void)loginIcsonSuccess:(NSDictionary *)data
{
    AsyncUserDeviceInfoLogin;
    //当用户从新登陆的时候，我们需要清掉启动来源
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.yid = @"";
    appDelegate.loginSource = @"";
    appDelegate.accessToken = @"";
    
    NSArray *values = [data objectForKey:@"data"];
    if (values.count == 3) {
        self.uid = [ [values objectAtIndex:0] integerValue];
        self.lastUid = self.uid;
        self.skey = [values objectAtIndex:1];
        self.token = [values objectAtIndex:2];
        self.loginUserType = LoginYiXunUser;
        [self localSave];
    }
    
    if (values.count == 4) {
        self.uid = [ [values objectAtIndex:0] integerValue];
        self.lastUid = self.uid;
        self.skey = [values objectAtIndex:1];
        self.token = [values objectAtIndex:2];
        self.loginUserType = LoginYiXunUser;
        [self localSave];
    }
    
    
    
    if (uid != 0)
    {
        if (delegate)
        {
//            AsyncUserDeviceInfoLogin
            [delegate icsonLoginSuccess:uid];
        }
    }
    else
    {
        if (delegate)
        {
            [delegate icsonLoginFailed:nil];
        }
    }
}

- (void)loginIcsonFailed:(NSError *)error returnStr:(NSData *)retStr
{
    NSDictionary * ret = [retStr toJSONObjectFO];
    if (ret) {
        self.uid = [[ret objectForKey:GLOBAL_COOKIE_NAME_UID] integerValue];
        self.skey = [ret objectForKey:GLOBAL_COOKIE_NAME_SKEY];
        self.token = [ret objectForKey:GLOBAL_COOKIE_NAME_TOKEN];
        
        NSString * str = [ret objectForKey:@"data"];
        if ([str isKindOfClass:[NSString class]]) {
            error = ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_LOGIN, [[ret objectForKey:@"errno"] integerValue], str);
        }
    } else {
        NSInteger errNo = [error code];
        NSString *errMsg = @"对不起登录失败，请稍候重试！";
        if (errNo - 100000 == 1028)
        {
            errMsg = @"帐号或密码错误";
        }
        error = ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_LOGIN, error.code, errMsg);
    }
    
    if (delegate)
    {
        [delegate icsonLoginFailed: error];
    }
}

//- (BOOL)canQuickLogin
//{
//    WloginSdk_v2 * wtLoginSdk = ((AppDelegate*)([UIApplication sharedApplication].delegate)).wtLoginSdk;
//    return [wtLoginSdk canQuickLogin_v2:qqScheme];
//}
//
//- (BOOL)quickLogin
//{
//    WloginSdk_v2 * wtLoginSdk = ((AppDelegate*)([UIApplication sharedApplication].delegate)).wtLoginSdk;
//    BOOL bQuickLogin = [wtLoginSdk quickLogin_v2:WTLOGIN_APPID subAppid:WTLOGIN_SUBAPPID scheme:qqScheme];
//    if (bQuickLogin == NO) {
//        NSLog(@"qq quickLogin err!!!");
//    }
//    return bQuickLogin;
//}
//
//- (void)handleQQQuickLoginResult:(NSURL *)url;
//{
//    WloginSdk_v2 * sdk = ((AppDelegate*)([UIApplication sharedApplication].delegate)).wtLoginSdk;
//    WTLOGIN_QUICKLOGIN_ACTION action;
//    uint64_t uin;
//    RETURN_VALUES_V2 ret = [sdk quickLoginResult_v2:url outAction:&action outUin:&uin];
//    NSLog(@"url:%@", url);
//    NSLog(@"uin:%llu", uin);
//    
//    if (action == WTLOGIN_QUICKLOGIN_CANCEL) {
//        [[iToast makeText:@"快速登陆已经取消"] show];
//    } else if (action == WTLOGIN_QUICKLOGIN_CONFORM) {
//        if (ret == WLOGIN_V2_SECCESS) {
//            NSString* uinStr = [NSString stringWithFormat:@"%llu",uin];
//            self.isQQQuickLoginFuckingFail = NO;
//            if (self.delegate) {
//                [sdk getUserSigAndBasicInfoByLogin_v2:uinStr andAppid:WTLOGIN_APPID andSigBitmap:LOGIN_SIGBITMAP  andPwd:nil andLoginFlag:LOGIN_V2_WITH_PASSWD_SIG_GEN andDelegate:self.delegate];
//            } else {
//                [sdk getUserSigAndBasicInfoByLogin_v2:uinStr andAppid:WTLOGIN_APPID andSigBitmap:LOGIN_SIGBITMAP  andPwd:nil andLoginFlag:LOGIN_V2_WITH_PASSWD_SIG_GEN andDelegate:self];
//            }
//        } else {
//            [[[iToast makeText:[NSString stringWithFormat:@"快速登录失败了：0x%x", ret]] setDuration:iToastDurationNormal] show];
//            self.isQQQuickLoginFuckingFail = YES;
//        }
//    } else {
//        [[iToast makeText:@"快速登陆因为未知的原因失败"] show];
//        self.isQQQuickLoginFuckingFail = YES;
//    }
//}


- (void)login:(NSString*)account withPassword:(NSString*) password withVerifyingCode:(NSString*)verifyingCode
{
    //from app//&act=page
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account", password, @"password", @"app", @"from", [[UIDevice currentDevice] uniqueDeviceIdentifier],@"device_id",verifyingCode,@"codeNum", nil];
    
    self.icsonLoginASIRequest = [self.icsonLoginRequest startProcess:params target:self onSuccess:@selector(loginIcsonSuccess:) onFailed:@selector(loginIcsonFailed:returnStr:) onLoading:nil autoStart:NO];
    [[ASIDataProvider sharedASIDataProvider] addASIRequest:self.icsonLoginASIRequest];
}

//- (BOOL)loginQQNormal
//{
//    NSArray * sigArray = WTSharedService.sigArray;
//    WloginUserInfo * userInfo = WTSharedService.userInfo;
//    
//    NSString * qq = [NSString stringWithFormat:@"%u", userInfo.dwUserUin];
//    NSString * qqskey = nil;
//    NSString * qqlskey = nil;
//    for (MemSig * sig in sigArray) {
//        if ([sig.sigName isEqualToString:@"SKEY"]) {
//            qqskey = [[NSString alloc] initWithData:sig.sig encoding:NSUTF8StringEncoding];
//        } else if ([sig.sigName isEqualToString:@"LSKEY"]) {
//            qqlskey = [[NSString alloc] initWithData:sig.sig encoding:NSUTF8StringEncoding];
//        }
//    }
//    
//    if (qq.length > 0 && (qqskey.length > 0 || qqlskey.length > 0)) {
//        [self loginQQ:qq andSkey:qqskey andLSkey:qqlskey];
//        return YES;
//    }
//    return NO;
//}
- (void)loginQQ_v2:(NSString*)accessToken andOpenId:(NSString *)openId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (accessToken) {
        [params setObject:accessToken forKey:@"accessToken"];
    }
    if (openId) {
        [params setObject:openId forKey:@"openid"];
    }
    [params setObject:@"101164963" forKey:@"appid"];
    [self.qqLoginRequest setUrl:[NSString stringWithFormat:@"%@",URL_TX_LOGIN]];
    //[self.qqLoginRequest setUrl:@"http://app.51buy.com/json.php?mod=alogin&act=txlogin"];
    self.qqLoginASIRequest = [self.qqLoginRequest startProcess:params target:self onSuccess:@selector(loginQQSuccess:) onFailed:@selector(loginQQFailed:returnStr:) onLoading:nil autoStart:NO];
    [[ASIDataProvider sharedASIDataProvider] addASIRequest:self.qqLoginASIRequest];
    
}
//
//- (void)loginQQ:(NSString*)qq andSkey:(NSString*)wtSkey andLSkey:(NSString*)lskey
//{
//    self.qqAccount = qq;
//    self.lastQqAccount = qq;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if (wtSkey) {
//        [params setObject:wtSkey forKey:@"skey"];
//    }
//    if (lskey) {
//        [params setObject:lskey forKey:@"lskey"];
//    }
//    [self.qqLoginRequest setUrl:[NSString stringWithFormat:@"%@%@",URL_WT_LOGIN,qq]];
//    self.qqLoginASIRequest = [self.qqLoginRequest startProcess:params target:self onSuccess:@selector(loginQQSuccess:) onFailed:@selector(loginQQFailed:returnStr:) onLoading:nil autoStart:NO];
//    [[ASIDataProvider sharedASIDataProvider] addASIRequest:self.qqLoginASIRequest];
//}

- (void)loginWeixin:(NSString *)code
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (code.length)
    {
        [params setObject:code forKey:@"code"];
    }
    
//    @"http://mb.51buy.com/json.php?mod=login&act=weixinlogin"
    
    //[self.wechatLoginRequest setUrl:[NSString stringWithFormat:@"%@%@%@", URL_WECHAT_LOGIN, @"&code=", code]];
//    [self.wechatLoginRequest setUrl:[NSString stringWithFormat:@"%@", URL_WECHAT_LOGIN]];
    [self.wechatLoginRequest setUrl: @"http://mb.51buy.com/json.php?mod=login&act=weixinlogin"];
    self.wechatLoginASIRequest = [self.wechatLoginRequest startProcess:params target:self onSuccess:@selector(loginWeixinSuccess:) onFailed:@selector(loginWeixinFailed:returnStr:) onLoading:nil autoStart:NO];
    [[ASIDataProvider sharedASIDataProvider] addASIRequest:self.wechatLoginASIRequest];
}

- (void)loginQQSuccess:(NSDictionary *)data
{
    
    AsyncUserDeviceInfoLogin;
    //当用户从新登陆的时候，我们需要清掉启动来源
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.yid = @"";
    appDelegate.loginSource = @"";
    appDelegate.accessToken = @"";
    NSInteger errorNo = [[data objectForKey:@"errno"] integerValue];
    if (errorNo == 0) {
        NSArray * dataArr = [data objectForKey:@"data"];
        //dataArr = [NSArray arrayWithObjects:@"75661326", @"ixA6B70DD7", @"1106d07e77ee7c255163fe6214f9df56", nil];
        if (dataArr.count >= 3) {
//            [MTA reportQQ:self.qqAccount];
            [self readLoginCookieFromResponse:dataArr];
            if (uid > 0) {
//                AsyncUserDeviceInfoLogin
                self.loginUserType = LoginQQUser;
                [self localSave];
            }
            if (delegate) {
                [delegate qqLoginSuccess:uid];
            } else if (_sucBlock) {
                _sucBlock(uid);
            }
            _sucBlock = nil;
            return;
        }
    
        }

    NSError *error = ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_LOGIN, errorNo, [data objectForKey:@"data"]);
    if (delegate)
    {
        [delegate qqLoginFailed: error];
    }
    _sucBlock = nil;
}


- (void)loginQQFailed:(NSError *)error returnStr:(NSData *)retStr
{
    [[GAlertLoadingView sharedAlertLoadingView] show];
    NSDictionary * ret = [retStr toJSONObjectFO];
    NSLog(@"%@",ret);
    if (ret) {
        //add by michaelxiao 2015/1/10
        self.uid = [[ret objectForKey:GLOBAL_COOKIE_NAME_UID] integerValue];
        self.skey = [ret objectForKey:GLOBAL_COOKIE_NAME_SKEY];
        self.token = [ret objectForKey:GLOBAL_COOKIE_NAME_TOKEN];
        
        NSString * str = [ret objectForKey:@"data"];
        if ([str isKindOfClass:[NSString class]]) {
            error = ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_LOGIN, [[ret objectForKey:@"errno"] integerValue], str);
        }
    }
    
//    NSString *errMsg = [NSString stringWithFormat:@"qq登陆失败，失败信息:%@", retStr];
//    [MTA trackError:errMsg];
    if (delegate)
    {
        [delegate qqLoginFailed:error];
    }
    _sucBlock = nil;
}

- (void)loginWeixinSuccess:(NSDictionary *)data
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.yid = @"";
    appDelegate.loginSource = @"";
    appDelegate.accessToken = @"";
    NSInteger errorNo = [[data objectForKey:@"errno"] integerValue];
    if (errorNo == 0) {
        NSDictionary * dataDic = [data objectForKey:@"data"];
        if (dataDic.count >= 3) {
            self.loginUserType = LoginWechatUser;
            self.uid = [[dataDic objectForKey:GLOBAL_COOKIE_NAME_UID] integerValue];
            self.lastUid = self.uid;
            self.skey = [dataDic objectForKey:GLOBAL_COOKIE_NAME_SKEY];
            self.token = [dataDic objectForKey:GLOBAL_COOKIE_NAME_TOKEN];
            [self localSave];
            if (delegate)
            {
                [delegate wechatLoginSuccess:uid];
            }
            
            return;
        }
    }
    
    NSError *error = ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_LOGIN, errorNo, [data objectForKey:@"data"]);
    if (delegate)
    {
        [delegate wechatLoginFailed:error];
    }
}

- (void)loginWeixinFailed:(NSError *)error returnStr:(NSData *)retStr
{
    NSDictionary * ret = [retStr toJSONObjectFO];
    NSLog(@"%@",ret);
    if (ret) {
        self.uid = [[ret objectForKey:GLOBAL_COOKIE_NAME_UID] integerValue];
        self.skey = [ret objectForKey:GLOBAL_COOKIE_NAME_SKEY];
        self.token = [ret objectForKey:GLOBAL_COOKIE_NAME_TOKEN];
        
        NSString * str = [ret objectForKey:@"data"];
        if ([str isKindOfClass:[NSString class]]) {
            error = ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_LOGIN, [[ret objectForKey:@"errno"] integerValue], str);
        }
    }
    
//    NSString *errMsg = [NSString stringWithFormat:@"微信登陆失败，失败信息:%@", retStr];
//    [MTA trackError:errMsg];
    if (delegate)
    {
        [delegate wechatLoginFailed:error];
    }
}

- (BOOL)isLogin {
    return uid != 0 && skey != nil && token != nil;
}

- (void)setActiveAccount:(NSInteger)suid forSkey:(NSString*) sskey forToken:(NSString*) stoken {
    uid = suid;
    self.lastUid = self.uid;
    skey = sskey;
    token = stoken;
}

- (void)localSave {
    
    if( uid != 0 && skey != nil && token != nil ) {

        [GPageCache set:GLOBAL_CACHE_KEY_LAST_UID forValue: [NSString stringWithFormat:@"%ld", (long)uid]];
        [GPageCache set:GLOBAL_CACHE_KEY_UID forValue: [NSString stringWithFormat:@"%ld", (long)uid]];
        [GPageCache set:GLOBAL_CACHE_KEY_SKEY forValue: skey];
        [GPageCache set:GLOBAL_CACHE_KEY_TOKEN forValue: token];
        [GPageCache set:GLOBAL_CACHE_KEY_LOGIN_TYPE forValue:INT2STRING(self.loginUserType)];
        [GPageCache set:GLOBAL_CACHE_KEY_QQ forValue:IDTOSTRING(_qqAccount)];
        [GPageCache set:GLOBAL_CACHE_KEY_LAST_QQ forValue:IDTOSTRING(_lastQqAccount)];
//        
//        [[HttpIcsonCookieManager sharedManager] setIcsonCookiesWithNamesAndValues:kHttpIcsonCookieKeyUid, [NSString stringWithFormat:@"%ld", (long)uid], kHttpIcsonCookieKeySkey, skey, kHttpIcsonCookieKeyToken, token, kHttpIcsonCookieKeyUin, _qqAccount, nil];
    }
}


- (void)logout
{
    [self logoutManual:NO];
}

- (void)logoutManual
{
    [self logoutManual:YES];
}

- (void)logoutManual:(BOOL)isManual
{
    AsyncUserDeviceInfoLogout
    
    uid = 0;
    if( skey ) {
        skey = nil;
    }
    
    if( token ) {
        token = nil;
    }
    [self localSave];
    _qqAccount = @"";
    
    [GPageCache remove:GLOBAL_CACHE_KEY_QQ];
    [GPageCache remove:GLOBAL_CACHE_KEY_UID];
    [GPageCache remove:GLOBAL_CACHE_KEY_SKEY];
    [GPageCache remove:GLOBAL_CACHE_KEY_TOKEN];
    [GPageCache remove:GLOBAL_CACHE_KEY_LOGIN_TYPE];
    
    //clear session cookie
    [ASIHTTPRequest clearSession];
    [GConfig setLastOrderInfo:nil];
    
    BOOL loginSuccess = NO;
    BOOL isAutoResume = [[GConfig sharedConfig] getIsAutoResume];
    AppDelegate *appdelegate  = (AppDelegate*)([UIApplication sharedApplication].delegate);
    if (!isManual && self.loginUserType == LoginQQUser && isAutoResume)
    {
//        WloginSdk_v2 * sdk = ((AppDelegate*)([UIApplication sharedApplication].delegate)).wtLoginSdk;
//        NSString *userAccount = [sdk lastLoginUser];
//        if (![sdk isNeedLoginWithPasswd_v2:userAccount andAppid:WTLOGIN_APPID]) {
//            if ([sdk checkLocalSigValid_v2:userAccount andAppid:WTLOGIN_APPID andSigType:LOGIN_SIGBITMAP]) {
//                WTSharedService.sigArray = [sdk getMemUserSig_v2:userAccount andAppid:WTLOGIN_APPID andSigBitmap:LOGIN_SIGBITMAP];
//                WTSharedService.userInfo = [sdk getBasicUserInfo_v2:userAccount];
//                loginSuccess = [self loginQQNormal];
//            }
//        }
    }
    
    if (!loginSuccess) {
//        [appdelegate.wtLoginSdk clearUserLoginData_v2:[appdelegate.wtLoginSdk lastLoginUser]];
//        [WTSharedService reset];
        self.loginUserType = LoginNotLogin;
    }
}


static NSString* dispatchCacheFileName = @"dispatchCacheFile";
static NSString* dispatchCacheFileFullName = @"dispatchCacheFile.plist";

- (NSString*)dispatchDataCachePath
{
    NSString*fileName = [NSString stringWithFormat:@"plist/%@",dispatchCacheFileFullName];
    return FILE_CACHE_PATH(fileName);
}

- (void)loadDispatchCacheToMem
{
    self.dispatchData = [NSArray arrayWithContentsOfFile:[self dispatchDataCachePath]];
    if(self.dispatchData == nil || ![self.dispatchData isKindOfClass:[NSArray class]] || self.dispatchData.count == 0)
    {
        NSString *pathForBundle = [[NSBundle mainBundle] pathForResource:dispatchCacheFileName ofType:@"plist"];
        self.dispatchData = [NSArray arrayWithContentsOfFile:pathForBundle];
    }
}

- (void)writeDispatchDataToLocal
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSString*path = [self dispatchDataCachePath];
        NSArray*array = self.dispatchData;
        
        NSMutableArray*arrayTemp = [NSMutableArray arrayWithArray:array];
        NSArray*keys = @[@"siteId", @"provinceid",@"district",@"name",@"cityid",@"id"];
        for (int i = 0; i < [array count]; i++)
        {
            NSDictionary*item = [array objectAtIndex:i];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:item];
            for (NSString*key in keys)
            {
                id value = [item objectForKey:key];
                if([value isKindOfClass:[NSNull class]])
                {
                    value = @"";
                    [mutableDic setObject:value forKey:key];
                }
            }
            item = [NSDictionary dictionaryWithDictionary:mutableDic];
            [arrayTemp replaceObjectAtIndex:i withObject:item];
        }
        self.dispatchData = [NSArray arrayWithArray:arrayTemp];
        NSLog(@"dispatch cache file path:%@",path);
        if([self.dispatchData isKindOfClass:[NSArray class]] && self.dispatchData.count > 0)
            [self.dispatchData writeToFile:path atomically:YES];
    });
}

- (void)parseRawDispatchData
{
    //    if (!self.dispatchData)
    //    {
    [self  loadDispatchCacheToMem];
    //    }
    if(!self.dispatchData)
    {
        [self getDispatchSiteDataFromServer];
    }
    NSArray*rawData = self.dispatchData;
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:[rawData count]];
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:[rawData count]];
    for (NSDictionary *dataItem in rawData)
    {
        [tmpArr addObject:[dataItem objectForKey:@"name"]];
        [tmpDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[dataItem objectForKey:@"name"],@"zone",
                           [NSString stringWithFormat:@"%@", [dataItem objectForKey:@"siteId"]],@"site",
                           [NSString stringWithFormat:@"%@", [dataItem objectForKey:@"provinceid"]],@"provinceid",
                           [NSString stringWithFormat:@"%@", [dataItem objectForKey:@"district"]],@"district",
                           [NSString stringWithFormat:@"%@", [dataItem objectForKey:@"cityid"]],@"cityid",
                           [NSString stringWithFormat:@"%@", [dataItem objectForKey:@"id"]],@"id",
                           nil]
                   forKey:[NSString stringWithFormat:@"%@", [dataItem objectForKey:@"id"]]];
    }
    
    if(_gsDeliveryDic != nil)
    {
        _gsDeliveryDic = nil;
    }
    _gsDeliveryDic = tmpDic;
    if(_gsProvices != nil)
    {
        _gsProvices = nil;
    }
    _gsProvices = tmpArr;
}

- (void)getDispatchSiteDataFromServer
{
    if(self.dispatchSiteRequest)
    {
        [self.dispatchSiteRequest setUrl:URL_DISPATCH_SITE];
    }
    [self.dispatchSiteRequest startProcess:nil target:self onSuccess:@selector(dispatchSiteDataGetSuccess:) onFailed:nil];
}

- (void)dispatchSiteDataGetSuccess:(NSDictionary *)dispatchData
{
    if ([[dispatchData objectForKey:@"errno"] intValue] == 0)
    {
        // if success, update the data file
        self.dispatchData = [[dispatchData objectForKey:@"data"] objectForKey:@"dispatches"];
        if([self.dispatchData isKindOfClass:[NSArray class]])
        {
            [self writeDispatchDataToLocal];
        }
        [self parseRawDispatchData];
    }
}

#pragma mark Address Related


- (NSInteger)siteID {
    return 1;
}

- (void)setCurrentDivision:(AdministrativeDivision *)currentDivision {
    if (!currentDivision) {
        return;
    }
    _currentDivision = currentDivision;
    //provinceId
    AdminLevel level = [_currentDivision.adminLevel integerValue];
    AdministrativeDivision *upperAD = _currentDivision;
    for (AdminLevel l = AdminLevelProvince; l < level; l ++) {
        upperAD = [upperAD getUpperLevelAD];
    }
    if (upperAD) {
        self.provinceId = [NSString stringWithFormat:@"%@", upperAD.uniqueId];
    }
    //districtId
    self.districtId = [NSString stringWithFormat:@"%@", _currentDivision.uniqueId];
    //countyId
    if ([currentDivision.adminLevel integerValue] == AdminLevelTown) {
        self.countyId = [NSString stringWithFormat:@"%ld", (long)[((IcsonTown *)currentDivision).county.uniqueId integerValue]];
    } else if ([currentDivision.adminLevel integerValue] == AdminLevelCounty) {
        self.countyId = [NSString stringWithFormat:@"%ld", (long)[currentDivision.uniqueId integerValue]];
    }
    //缓存到本地
    [[NSUserDefaults standardUserDefaults] setObject:self.districtId forKey:kLocalKeyDistrictId];
}



- (NSString *)provinceId {
    if (!_provinceId) {
        _provinceId = @"";
    }
    return _provinceId;
}




- (NSString *)districtId {
    if (!_districtId) {
        _districtId = @"";
    }
    return _districtId;
}


- (NSString *)countyId {
    if (!_countyId || [_countyId isEqualToString:@""]) {
        //默认上海徐汇区
        _countyId = @"29357";
    }
    return _countyId;
}



#pragma mark- Get Login Data
- (void)saveActiveAccount {}

- (NSString*) skey {
    return skey ? skey : @"";
}

- (NSString*) token {
    return token ? token : @"";
}

- (NSString*) qqAccount {
    if ([self isLogin] || _loginUserType == LoginQQUser) {
        return _qqAccount ? _qqAccount : @"";
    }
    return @"";
}

- (NSString*) lastQqAccount {
    if ([self isLogin]) {
        if (_loginUserType == LoginQQUser) {
            _lastQqAccount = _qqAccount;
            return _lastQqAccount;
        } else {
            return @"0";
        }
    }
    return _lastQqAccount ? _lastQqAccount : @"0";
}

- (NSString *) getExToken
{
    const char *s = [self.token cStringUsingEncoding:NSASCIIStringEncoding];
    if ((self.skey  == nil ) || [skey isEqualToString:@""]) {
        return @"";
    }
    long hash = 5381;
    NSInteger length = [skey length];
    for (int i = 0; i < length; i++)
    {
        hash += (hash << 5) + s[i];
    }
    return [NSString stringWithFormat:@"%ld", hash & 0x7fffffff];
}

- (NSString *) getQQSkey
{
    NSString * wkey = @"";
//    AppDelegate *appdelegate  = (AppDelegate*)([UIApplication sharedApplication].delegate);
//    if (self.loginUserType == LoginQQUser)
//    {
//        NSArray * signArr = [appdelegate.wtLoginSdk getMemUserSig_v2:[appdelegate.wtLoginSdk lastLoginUser] andAppid:WTLOGIN_APPID andSigBitmap:WLOGIN_GET_SKEY];
//        
//        for (MemSig * sig in signArr) {
//            if ([sig.sigName isEqualToString:@"SKEY"]) {
//                wkey = [[NSString alloc] initWithData:sig.sig encoding:NSUTF8StringEncoding];
//                break;
//            }
//        }
//    }
    
    NSLog(@"get wtlogin skey = %@", wkey);
    return wkey;
}

- (NSString *) getQQLSkey
{
    NSString * wkey = @"";
//    AppDelegate *appdelegate  = (AppDelegate*)([UIApplication sharedApplication].delegate);
//    if (self.loginUserType == LoginQQUser)
//    {
//        NSArray * signArr = [appdelegate.wtLoginSdk getMemUserSig_v2:[appdelegate.wtLoginSdk lastLoginUser] andAppid:WTLOGIN_APPID andSigBitmap:WLOGIN_GET_LSKEY];
//        
//        for (MemSig * sig in signArr) {
//            if ([sig.sigName isEqualToString:@"LSKEY"]) {
//                wkey = [[NSString alloc] initWithData:sig.sig encoding:NSUTF8StringEncoding];
//                break;
//            }
//        }
//    }
    
    NSLog(@"get wtlogin lskey = %@", wkey);
    return wkey;
}

- (NSString *) getLastQQ
{
    NSString * qq = @"";
    AppDelegate *appdelegate  = (AppDelegate*)([UIApplication sharedApplication].delegate);
    if (self.loginUserType == LoginQQUser)
    {
        //qq = [appdelegate.wtLoginSdk lastLoginUser];
    }
    
    return qq;
}



//#pragma wtlogin sdk delegate
//
//-(void)loginSuccessSig_v2:(WloginSdk_v2 *)sdk andSig:(NSMutableArray *)sigArray andBaseInfo:(WloginUserInfo *)userInfo tag:(long)tag
//{
//    WTSharedService.sigArray = sigArray;
//    WTSharedService.userInfo = userInfo;
//    
//    [self loginQQNormal];
//}
//
//-(void)loginFailed_v2:(WloginSdk_v2 *)sdk andRst:(RETURN_VALUES_V2)result withErrInfo:(WloginErrInfo *)errInfo tag:(long)tag
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errInfo.sErrorTitle
//                                                        message:errInfo.sErrorMsg
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//    });
//}
//
//
//#pragma fucking not used wtlogin interface
//
//-(void)showPicture_v2:(WloginSdk_v2 *)sdk andPicData:(NSData *)pictureData andWording:(NSDictionary *)wordingDic tag:(long)tag{}
//-(void)inputPassword_v2:(WloginSdk_v2 *)sdk andAccount:(NSString *)account {}
//-(void)showPicture_v2:(WloginSdk_v2 *)sdk andPicData:(NSData *)pictureData{}
//-(void)showPicture_v2:(WloginSdk_v2 *)sdk andPicData:(NSData *)pictureData andWording:(NSDictionary *)wordingDic{}
//-(void)loginSuccessSig_v2:(WloginSdk_v2 *)sdk andSig:(NSMutableArray *)sigArray andBaseInfo:(WloginUserInfo *)userInfo{}
//-(void)loginFailed_v2:(WloginSdk_v2 *)sdk andRst:(RETURN_VALUES_V2)result withErrInfo:(WloginErrInfo *)errInfo{}
//
//-(void)inputPassword_v2:(WloginSdk_v2 *)sdk andAccount:(NSString *)account tag:(long)tag{}
//-(void)inputSmsCode_v2:(WloginSdk_v2 *)sdk andNextTime:(uint32_t)wNextRefreshTime andTimeout:(uint32_t)dwTimeout andPhoneNo:(NSString *)phone tag:(long)tag{}
//-(void)inputSmsCodeError_v2:(WloginSdk_v2 *)sdk errMsg:(NSString *)errorMsg tag:(long)tag{}
//-(void)quickLoginEnd_v2:(WloginSdk_v2 *)sdk andUrl:(NSURL *)url tag:(long)tag{}


@end
