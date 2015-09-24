/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：Constants.h
 * 文件标识：
 * 摘 要：定义所有在代码中出现的常量。禁止使用硬编码的方式使用常量
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：2012年9月18日
 */


#ifndef iPad51Buy_CodeConstants_h
#define iPad51Buy_CodeConstants_h
#define KEY_ALI_SOURCE          @"alipaywallet"
#define KEY_ALI_YID             @"alipayapp"

#define WTLOGIN_APPID               (700028401)
#define WTLOGIN_SUBAPPID            (1)     // 随便填的
#define LOGIN_SIGBITMAP (WLOGIN_GET_LSKEY | WLOGIN_GET_SKEY)

#define MAX_HTTP_CONNECT_COUNT      10
#define KEY_REQUEST_ID              @"reqId"
#define KEY_REQUEST_STAT            @"reqStat"
#define KEY_REQUEST_RESULT          @"reqResult"


#define SERVER_TIME_OFFSET          @"ServerTimeOffset"


#define HISTORY_COUNT               5
#define SEARCH_HISTORY_COUNT        5
#define SETCAPACITY                 10

#define kIcsonErrorDomain            @"IcsonClientErrorDomain"


// TODO:modified for ios only 2
#define APP_TYPE_ICSON_FOR_IPHONE	2




#define COMMENT_SATISFIED_TYPE              1
#define COMMENT_GENERAL_TYPE                2
#define COMMENT_UNSATISFIED_TYPE            3

#define COMMENT_SATISFIED_KEYWORD           @"satisfiedexperience"
#define COMMENT_GENERAL_KEYWORD             @"generalexperience"
#define COMMENT_UNSATISFIED_KEYWORD         @"unsatisfiedexperience"

// keys fot http post packdge
#define KEY_POST_BODY               @"postBody"
#define KEY_POST_METHOD             @"postMethod"
#define KEY_POST_HEAD               @"postHead"
//现在网络接口发送和返回的数据的编码格式都是kCFStringEncodingGB_18030_2000，这个如果以后需要改，就在这里改。
#define RETURN_DATA_ENCODING        kCFStringEncodingGB_18030_2000

#define  kUserLoginSuccessNotification         @"UserIcsonLoginSuccessNotification"
#define  kUserLogoutNotification               @"UserLogoutNotification"
//#define  kQQOrAliPayLoginSuccessNotification   @"UseQQOrAliPayLoginSuccessNotification"
#define  kRegisterAndLoginSucessNotification   @"kRegisterAndLoginSucessNotification"
//用户自动登陆是否check
#define  kIsUserAutoLoginChecked               @"kIsUserAutoLoginChecked"

#define RGBColor(_rgb, _alpha) [UIColor colorWithRed:(((_rgb) >> 16) & 0xFF)/256.0f green:(((_rgb) >> 8) & 0xFF)/256.0f blue:((_rgb) & 0xFF)/256.0f alpha:(_alpha)]


//下面的这些常量是用于keychain的封装中
//static  NSString *KeyChainSaveGenericIdentifierIcson    =  @"KeyChainSaveGenericIdentifierIcson";
//static  NSString *KeyChainSaveGenericIdentifierQQ       =  @"KeyChainSaveGenericIdentifierQQ";
//static  NSString *KeyChainSaveGenericIdentifierZhifubao =  @"KeyChainSaveGenericIdentifierZhifubao";
//
//
//static NSString *KeychainWrapperErrorDomain = @"KeychainWrapperErrorDomain";
typedef enum
{
	KeyChainErrorInputParamCanNotBeNull = -2000,
	KeyChainErrorPasswordIsNull,
	
}KeyChainErrorCode;

typedef enum
{
	KeyChainLoginNone = 1,
	KeyChainIcsonLoginInfo, //易迅
	KeyChainQQLoginInfo,    //qq
	KeyChainZhifubaoInfo,   //支付宝
	
}KeyChainSaveType;

#define kUserName     @"userName"
#define kPassword     @"password"
#define kUid          @"uid"
#define kSKey         @"skey"
#define kToken        @"token"
#define kBefore                     @"before"
//上面的这些常量是用于keychain的封装中

//下面是login相关页面的通用数据
#define   kLoginRelatedRect    CGRectMake(0.0f, 0.0f, 540.0f, 576.0f)
//上面是login相关页面的通用数据


//下面是关于用户中心，我的易迅的相关数据
#define kMyIcsonViewRect            CGRectMake(0.0f, 0.0f, 1024.0f, 704.0f)
#define kMyIcsonLeftViewRect        CGRectMake(0.0f, 0.0f, 320.0f, 704.0f)
#define kMyIcsonRightViewRect       CGRectMake(320.0f, 0.0f,704.0f,704.0f)
//上面是关于用户中心，我的易迅的相关数据

//下面是setting部分的一些数据
#define kSettingViewFrame      CGRectMake(0.0f, 0.0f, 768.0f, 704.0f)
//上面是settting部分的一些数据

//这里出现一些奇怪的东西，客户端得到的数据竟然是html格式的
#define LESS_THAN_IN_HTML   @"&lt;"
#define MORE_THAN_IN_HTML   @"&gt;"
#define LESS_THAN           @"<"
#define MORE_THAN           @">"

//下面是设置里面的一些数据
#define FEEDBACK_TITLE              @"感谢您对易迅网的热情反馈！"
#define FEEDBACK_DESCRIPTION        @"说出您的体验和意见，可以帮助我们改进本产品，以便更好的服务您和其他用户。"


//定义全局消息对象
#define NOTIFY_LOGIN                @"notifyLogin"

//保存设置节省流量的key，保存在NSUserDefaults里
#define kIsDownloadImageOrNotWhenWifi     @"kIsDownloadImageOrNotWhenWifi"
#define kIsWebImageLoadingStratrgySet     @"kIsWebImageLoadingStratrgySet"


#define kMyOrderListTitle           @"我的订单"

#define kLoadMoreButtonFont         15.0f
#define kLoadMoreButtonTag          1024
#define kLoadMore                   @"更多..."
#define kLoadMoreLoading            @"载入中..."
#define kLoadMoreNoMore             @"没有更多了"
#define kActivityWidth              20.0f
#define kActivityHeight             20.0f
#define kActivityTag                1025


#define kZone                       @"zone"
#define kSite                       @"site"

#define kCurrentPage                @"current_page"
#define kPageCount                  @"page_count"
#define kOrders                     @"orders"
#define kBefore                     @"before"
#define kCurrentPage                @"current_page"

#define kPageCount                  @"page_count"
#define kOrders                     @"orders"

#define kOrderCharId                @"order_char_id"
#define kMiddle                     @"middle"
#define kCash                       @"cash"
#define kPayType                    @"pay_type_name"
#define kBuyTotal                   @"buy_total"
#define kComment                    @"去评论"
#define kCanComment                 @"can_evaluate"
#define kOrderDate                  @"order_date"


#define kInternalSchema             @"icson"
#define kAliPaySchema               @"com51buy"


#define kDeviceToken                @"device_token"
#define kLantitude                  @"lantitude"
#define kLongitude                  @"longitude"
#define kIcsonURLPefixFromOutside   @"wap2app://app.launch/param?"
#define kBarCodeSRCTag              @"barcode"
#define kCPSTag                     @"cps"

//微信跳转过来的流量统计
#define kWeiXinOTag                  @"weixin_otag"
#define kWeixinOTagTime              @"weixin_otag_time"
#define kDefaultSplashPicURLKey     @"defaultSplashPicURL"
#define kDefaultSplashPicFileName   @"defaultSplashPic"
#define kSpecialSplashPicURLKey     @"specialSplashPicURL"
#define kSpecialSplashPicFileName   @"specialSplashPic"
#define kSpecialSplashPicDuration   @"specialSplashDuration"
#define kSpecialSplashPicStartTime  @"specialSplashStarttime"
#define kSpecialSplashPicEndTime    @"specialSplashEndTime"

#define kIsAppUsed             @"isAppUsed"
#define kIsRollUsed             @"kIsRollUsed"
#define kCPSCookieLocalKeyName            @"CPSCookieLocalKeyName"
#define kCPSTkdLocalKeyName            @"CPSTkdLocalKeyName"

//以下是接口下发的一些参数的key,第一个是默认的第一次传递的版本号，第二个是存在NSUserDefault里面的key
#define kidsTCAppSDKVersion     @"0"
#define kidsTCAppSDKVersionKey  @"kidsTCAppSDKVersionKeyNew"
#define kInterfaceBundleVersion @"kInterfaceBundleVersion"


//无货商品价格
#define kNotSoldPrice           99999900
#define kNotSoldString          @"暂不销售"
#define kNoExpireData           @"第三方预期时间不可知"
#endif
