//
//  UserWrapper.h
//  iphone
//
//  Created by icson apple on 12-2-17.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HttpCookieWrapper.h"
#import "HttpRequestWrapper.h"
//#import <WTLoginSDK/WloginErrInfo.h>
//#import <WTLoginSDK/WloginCallbackProtocol_v2.h>

@class AdministrativeDivision;

typedef void (^LoginSuccessBlock)(NSInteger uid);

@protocol UserWrapperDelegate <NSObject>

@optional
- (void)icsonLoginSuccess:(NSInteger) uid;
- (void)icsonLoginFailed:(NSError *) error;

- (void)qqLoginSuccess:(NSInteger) uid;
- (void)qqLoginFailed:(NSError *) error;

- (void)wechatLoginSuccess:(NSInteger) uid;
- (void)wechatLoginFailed:(NSError *)error;

@end

typedef enum {
    LoginNotLogin,
    LoginYiXunUser,
    LoginQQUser,
    LoginAliipay,
    LoginWechatUser,
} LoginUserType;

@interface UserWrapper : NSObject <ASIHTTPRequestDelegate>
{
    
}

@property (nonatomic, strong) HttpRequestWrapper *icsonLoginRequest;
@property (nonatomic, strong) HttpRequestWrapper *qqLoginRequest;
@property (nonatomic, strong) HttpRequestWrapper *dispatchSiteRequest;
@property (nonatomic, strong) HttpRequestWrapper *loginStatusCheckRequest;
@property (nonatomic, strong) HttpRequestWrapper *wechatLoginRequest;

@property (nonatomic, strong) NSString *qqAccount;
@property (nonatomic, strong) NSString *lastQqAccount;
@property (nonatomic, strong) NSString *skey, *token;
@property (nonatomic) NSInteger siteID;         //站点id
@property (nonatomic) NSInteger uid;
@property (nonatomic) NSInteger lastUid;
@property (nonatomic) LoginUserType loginUserType;
@property (weak, nonatomic) id<UserWrapperDelegate> delegate;

@property (nonatomic, strong) NSArray  *dispatchData;

@property (nonatomic) BOOL      isQQQuickLoginFuckingFail;
@property (nonatomic, copy) LoginSuccessBlock   sucBlock;
//add by Altail, 20150529
@property (nonatomic, strong) AdministrativeDivision *currentDivision;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *districtId;
@property (nonatomic, strong) NSString *countyId;
@property (nonatomic, copy) NSString * visitKey;

//- (BOOL)canQuickLogin;
//- (BOOL)quickLogin;
//- (void)handleQQQuickLoginResult:(NSURL *)url;

//- (BOOL)loginQQNormal;
- (void)loginQQ_v2:(NSString*)accessToken andOpenId:(NSString*)openId;
//- (void)loginQQ:(NSString*)qq andSkey:(NSString*)wtSkey andLSkey:(NSString*)lskey;
- (void)login:(NSString*) account withPassword:(NSString*) password withVerifyingCode:(NSString*)verifyingCode;
- (void)loginWeixin:(NSString *)code;
- (BOOL)isLogin;
- (void)logout;
- (void)logoutManual;
- (void)initUser;

- (void)setActiveAccount:(NSInteger)uid forSkey:(NSString*) skey forToken:(NSString*) token;
- (void)localSave;
//- (void)goBackController:(id)sender;
+ (UserWrapper *) shareMasterUser;

//- (void)getDispatchSiteDataFromServer;
- (NSString*) skey;
- (NSString*) token;
- (NSString*) qqAccount;
- (NSString*) lastQqAccount;
- (NSString *) getExToken;

- (NSString *) getQQSkey;
- (NSString *) getQQLSkey;
- (NSString *) getLastQQ;

- (void) removeDelegate:(id)deleg;

@end
