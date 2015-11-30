//
//  GGlobal.h
//  iphone51buy
//
//  Created by icson apple on 12-6-28.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import "KTCLocation.h"
#import "AUITheme.h"

//#define DEBUG 0

//#if DEBUG == 0
//#define NSLog(...) {}
//#endif

#define WX_DEBUG 0


//static NSString *const kAppEnterForegroundNotification = @"enterForeground";

// Apple Id in App Store
static NSString * const kAppIDInAppStore = @"557825088";
//static NSString * const kWeChatAppID = @"wx6964eb0b10aa369b";
//#if WX_DEBUG
//static NSString * const kWeChatAppID = @"wxf8b4f85f3a794e77";
//#else
//static NSString * const kWeChatAppID = @"wx75fa1a06d38fde4e";
//#endif //WX_DEBUG

//static NSString *const kWeChatSourceKey = @"comefrom";
//static NSString *const kWeChatSourceValue = @"weixin";

static NSString *const kCustomerServicePhoneNumber = @"15000168321";

static NSString *const UserRoleHasChangedNotification = @"UserRoleHasChangedNotification";

static NSString *const kErrMsgKey = @"kErrMsgKey";

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_GREATER_THAN_IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) //ios9.0 以上系统

#define PRODUCT_TAB_HEIGHT 39.0
#define PRODUCT_TAB_MARGIN 5.0
#define PRODUCT_SCROLL_TOP 5.0
#define PRODUCT_SCROLL_BOTTOM 48.0

#define SEARCH_DEFAULT_SIZE 10

#define TABBAR_ICO_WIDTH 30.0
#define TABBAR_ICO_HEIGHT 30.0
#define TABBAR_ICO_MARGIN_TOP 3.0
#define TABBAR_ICO_MARGIN_BOTTOM 2.0

#define TABBAR_TITLE_FONT_SIZE 11.0

#define PRODUCT_PIC_SCROLL_WIDTH 165.0
#define PRODUCT_PIC_SCROLL_HEIGHT 165.0
#define PRODUCT_PIC_SCROLL_MARGIN 20.0

#define PRODUCT_TABLE_VIEW_CELL_HEIGHT 98.0
#define PROMO_TABLE_VIEW_CELL_HEIGHT   44.0
#define ENERGY_SUBSIDY_INTRO_CELL_HEIGHT 330.0f

#define TOOLBAR_COLOR RGBA(49.0, 124.0, 228.0, 1.0)
#define TOOLBAR_TEXT_COLOR_NORMAL RGBA(68.0, 68.0, 68.0, 1.0)

#define COLOR_BLUE (RGBA(51.0, 130.0, 239.0, 1.0))
#define COLOR_EBLACK (RGBA(51.0, 51.0, 51.0, 1.0))
#define COLOR_PRICE_BLACK (RGBA(102.0, 102.0, 102.0, 1.0))
#define COLOR_GREEN (RGBA(168.0, 211.0, 137.0, 1.0))
#define COLOR_GRAY (RGBA(188.0, 188.0, 188.0, 188.0))
#define COLOR_WHITE (RGBA(240.0, 240.0, 240.0, 255.0))
#define COLOR_DARKBLUE (RGBA(29.0, 74.0, 137.0, 188.0))
#define COLOR_COUNTDOWN_BG (RGBA(76.0, 76.0, 76.0, 1))
#define COLOR_HOME_GRAY RGBA(241, 241, 241, 1.0f)
#define COLOR_MYISCONGRAY (RGBA(153.0, 153.0, 153.0, 1.0))
#define COLOR_MYISCONSEPERATE (RGBA(223.0, 225.0, 230.0, 1.0))

#define BORDER_WIDTH (0.5)

#define DEFAULT_IMAGE ([UIImage imageNamed:@"default_placeholder"])

#define COLOR_BG_QIANG RGBA(119, 168, 235, 1)
#define COLOR_BG_TUAN RGBA(18, 192, 123, 1)
#define COLOR_BG_MORNING RGBA(247, 191, 42, 1)
#define COLOR_BG_NIGHT RGBA(2, 45, 87, 1)
#define COLOR_BG_ACTIONSHEETMASK [UIColor colorWithRed:223/255.0 green:225/255.0 blue:218/255.0 alpha:1]

#define ORDER_STATUS_COLOR_GREEN	(RGBA(95.0, 184.0, 64.0, 1.0))
#define ORDER_STATUS_COLOR_YELLOW	(RGBA(255.0, 192.0, 0.0, 1.0))
#define ORDER_STATUS_COLOR_DARK		(RGBA(51.0, 51.0, 51.0, 1.0))

#define NAVBAR_BG RGBA(49.0, 124.0, 228.0, 1.0)
#define NAVBAR_BG_IMG LOADIMAGE(@"topbar", @"png")

#define BUTTON_STRONG_BG (RGBA(51.0, 139.0, 255.0, 1.0))
#define BUTTON_STRONG_BG_LOW (RGBA(50.0, 127.0, 233.0, 1.0))
#define BUTTON_STRONG_SHADOW_COLOR (RGBA(139.0, 139.0, 139.0, 1.0))
#define BUTTON_STRONG_BORDER_COLOR (RGBA(51.0, 130.0, 239.0, 1.0))
#define  COLOR_BTN (RGBA(122.0, 142.0, 162.0, 255.0))
#define  COLOR_PAYTYPEBODER (RGBA(255.0, 216.0, 190.0, 255.0))


#define BUTTON_WEAK_BG (RGBA(230.0, 230.0, 230.0, 1.0))
#define BUTTON_WEAK_SHADOW_COLOR (RGBA(139.0, 139.0, 139.0, 1.0))
#define BUTTON_WEAK_BORDER_COLOR (RGBA(181.0, 181.0, 181.0, 1.0))
#define BUTTON_WEAK_TITLE_COLOR (RGBA(68.0, 68.0, 68.0, 1.0))

#define BUTTON_DISABLED_TITLE_COLOR (RGBA(153.0, 153.0, 153.0, 1.0))
#define PLACEHOLDER_TEXT_COLOR (RGBA(153.0, 153.0, 153.0, 1.0))
#define OC_TEXT_COLOR (RGBA(68.0, 68.0, 68.0, 1.0))
#define OC_PRICE_COLOR (RGBA(191.0, 40.0, 0.0, 1.0))

// TODO:modified for ios only 2 
#define APP_TYPE_ICSON_FOR_IPHONE	2

#define APP_WANGGOU_TYPE_MODE       5

// key for NSUerDefault
static NSString *const kAppVersionCodeKey = @"AppVersionCodeKey";
static NSString *const kUpdateImmunePeriodKey = @"UpdateImmunePeriodKey";
static NSString *const kForceUpdateInfoKey = @"ForceUpdateInfoKey";
static NSString *const kLastOrderInfoKey = @"LastOrderInfoKey";
static NSString *const kAppEnvInfoKey = @"AppEnvInfoKey";

// Update immune period time threshold
static const NSTimeInterval kUpdateImmuneTimeThreshold = 60.0f * 60 * 24 * 3;
//static const NSTimeInterval kUpdateImmuneTimeThreshold = 60.0f * 3;


// ****** ------ URL ------ ****** /
#define URL_ADDRESS_GETDETAILS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ADDRESS_GETDETAILS"]
#define URL_ADDRESS_GETTOWNS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ADDRESS_GETTOWNS"]

#define URL_APP_STORE_UPDATE ([NSString stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8", kAppIDInAppStore])

#define URL_ADD_PRODUCT_NONMEMBER [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ADD_PRODUCT_NONMEMBER"]
#define URL_ALIPAY_LOGIN [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ALIPAY_LOGIN"]
#define URL_ORDER_SHIP_PAYTYPE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_SHIP_PAYTYPE"]
#define URL_EVENT_TUAN [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_EVENT_TUAN"]
#define URL_INVOICE_GETLIST [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_INVOICE_GETLIST"]
#define URL_INTEREST_PRODUCTS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_INTEREST_PRODUCTS"]
#define URL_CART_UPDATE_PRODUCT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CART_UPDATE_PRODUCT"]
#define URL_PRODUCT_INTRO [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_PRODUCT_INTRO"]
#define URL_ADDRESS_GETLIST [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ADDRESS_GETLIST"]
#define URL_MB_USER_PROFILE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_USER_PROFILE"]
#define URL_MB_USER_POINTS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_USER_POINTS"]
#define URL_MB_USER_BALANCE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_USER_BALANCE"]
#define URL_SEARCH [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SEARCH"]
#define URL_PREORDER_SHIPPINGTYPE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_PREORDER_SHIPPINGTYPE"]
#define URL_USERINFO_UPDATE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_USERINFO_UPDATE"]
#define URL_FAVOR_ADDNEW [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FAVOR_ADDNEW"]
#define URL_ADD_PRODUCT_NOTICE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ADD_PRODUCT_NOTICE"]
#define URL_PV_STAT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_PV_STAT"]
#define URL_CART_GET_PRODUCT_LIST [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CART_GET_PRODUCT_LIST"]
#define URL_HOT_PORDUCTS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_HOT_PORDUCTS"]
#define URL_GET_SMS_CODE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_GET_SMS_CODE"]
#define URL_BIND_PONE_TO_USER [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_BIND_PONE_TO_USER"]
#define URL_ORDER_GETCOUPON [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_GETCOUPON"]
#define URL_ADDRESS_MODIFY [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ADDRESS_MODIFY"]
#define URL_DISPATCH_SITE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_DISPATCH_SITE"]
#define URL_SEARCH_FILTER [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SEARCH_FILTER"]
#define URL_PAY_TRADE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_PAY_TRADE"]
#define URL_GET_USER_COUPON [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_GET_USER_COUPON"]
#define URL_QUERY_SUGGEST [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_QUERY_SUGGEST"]
#define URL_AREA_JS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_AREA_JS"]
#define URL_INVOICE_DELETE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_INVOICE_DELETE"]
#define URL_INVOICE_MODIFY [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_INVOICE_MODIFY"]
#define URL_VIRTUAL_ORDER_DETAIL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_VIRTUAL_ORDER_DETAIL"]
#define URL_ORDER_CANCEL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_CANCEL"]
#define URL_CANCEL_ORDER [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CANCEL_ORDER"]
//add for Qiang
#define URL_ORDER_QIANG_PRODUCT_GET [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_QIANG_PRODUCT_GET"]
#define URL_ORDRE_QIANG_SUBMIT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDRE_QIANG_SUBMIT"]
#define URL_ORDER_QIANG_CHECK [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_QIANG_CHECK"]

#define URL_EVENT_MARKET [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_EVENT_MARKET"]
#define URL_ADD_COMMENT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ADD_COMMENT"]
#define URL_COUPON_GET_EVENT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_COUPON_GET_EVENT"]
#define URL_CART_ADD_PRODUCTS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CART_ADD_PRODUCTS"]
#define URL_CART_REMOVE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CART_REMOVE"]
#define URL_CART_REMOVE_PRODUCT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CART_REMOVE_PRODUCT"] //add by xiaomanwang new cart remove interface


#define URL_RECOMMEND_PRODUCTS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_RECOMMEND_PRODUCTS"]
#define URL_ADDRESS_DELETE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ADDRESS_DELETE"]
#define URL_EVENT_QIANG [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_EVENT_QIANG"]
#define URL_RECHARGE_MOBILE_PAYMENT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_RECHARGE_MOBILE_PAYMENT"]
#define URL_CHECK_USER_COUPON [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CHECK_USER_COUPON"]
#define URL_EVENT_QIANG_NEXT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_EVENT_QIANG_NEXT"]
#define URL_ORDER_DETAIL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_DETAIL"]
#define URL_LIST_CART_NONMEMBER [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_LIST_CART_NONMEMBER"]
#define URL_PRODUCT_DETAIL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_PRODUCT_DETAIL"]
#define URL_INVOICE_ADDNEW [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_INVOICE_ADDNEW"]
#define URL_GET_3C_VOTE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_GET_3C_VOTE"]
#define URL_EVENT_HOME [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_EVENT_HOME"]

#define URL_ALERT_INFO [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ALERT_INFO"]
#define URL_RECHARGE_MOBILE_MONEY [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_RECHARGE_MOBILE_MONEY"]
#define URL_HOT_SEARCH_WORDS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_HOT_SEARCH_WORDS"]
#define URL_PRODUCT_PARAMETERS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_PRODUCT_PARAMETERS"]
#define URL_RECHARGE_MOBILE_INFO [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_RECHARGE_MOBILE_INFO"]
#define URL_RECHARGE_INFO [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_RECHARGE_INFO"]
#define URL_COUPON_CAN_GET [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_COUPON_CAN_GET"]
#define URL_APP_LOGIN [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_APP_LOGIN"]
#define URL_FAVOR_GETLIST [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FAVOR_GETLIST"]
#define URL_LIST_ORDER_ONEKEYBUY [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_LIST_ORDER_ONEKEYBUY"]
#define URL_ADDRESS_ADDNEW [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ADDRESS_ADDNEW"]
#define URL_WT_LOGIN [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_WT_LOGIN"]

//2015-5-25
#define URL_TX_LOGIN [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_TX_LOGIN"]

#define URL_WECHAT_LOGIN [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_WECHAT_LOGIN"]
#define URL_ORDER_GETDETAIL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_GETDETAIL"]
#define URL_FAVOR_DELETE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FAVOR_DELETE"]
#define URL_PUSHNOTIFY_GET [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_PUSHNOTIFY_GET"]
#define URL_PRODUCT_REVIEWS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_PRODUCT_REVIEWS"]
#define URL_FEEDBACK_ADD [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FEEDBACK_ADD"]
//#define URL_GET_USER_POINT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_GET_USER_POINT"] 已废弃
#define URL_GET_USER_CAN_USE_POINT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_GET_USER_CAN_USE_POINT"]
#define URL_ROLL_INFO [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ROLL_INFO"]
#define URL_ROLL_ROLL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ROLL_ROLL"]
#define URL_ROLL_REWARD [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ROLL_REWARD"]
#define URL_CHECK_VERSION_UPDATE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CHECK_VERSION_UPDATE"]
#define URL_EVENT_PAGE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_EVENT_PAGE"]
#define URL_CATEGORY_TREE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CATEGORY_TREE"]
#define URL_APP_RECOMMEND [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_APP_RECOMMEND"]
#define URL_FLASH_INFO_URL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FLASH_INFO_URL"]
#define URL_ORDER_CONFIRM [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_CONFIRM"]
#define URL_GET_MESSAGES [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_GET_MESSAGES"]
#define URL_SET_MESSAGE_STATUS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SET_MESSAGE_STATUS"]
#define URL_SUBMIT_ORDER [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SUBMIT_ORDER"]
#define URL_ORDER_GETLIST [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_GETLIST"]
#define URL_ORDER_GETFLOW [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_GETFLOW"]
#define URL_ORDER_GETTRACE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_GETTRACE"]
#define URL_LOGIN_GETSTATUS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_LOGIN_GETSTATUS"]
#define URL_ORDER_CONFIRM_NEW [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_CONFIRM_NEW"]

// after sale service
#define URL_SERVICE_CANCEL_ORDER [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SERVICE_CANCEL_ORDER"]
#define URL_SERVICE_APPLY_LIST [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SERVICE_APPLY_LIST"]
#define URL_SERVICE_APPLY_DETAIL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SERVICE_APPLY_DETAIL"]
#define URL_SERVICE_APPLY [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SERVICE_APPLY"]
#define URL_SERVICE_SUGGEST [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SERVICE_SUGGEST"]

// new search and category interface
#define URL_CATEGORY_NEW [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_CATEGORY_NEW"]
#define URL_SEARCH_NEW [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SEARCH_NEW"]

/* ------ For roll ------ */
#define URL_MB_ROLL_CODE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_ROLL_CODE"]
#define URL_MB_ROLL_INFO [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_ROLL_INFO"]
#define URL_MB_ROLL_ROLL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_ROLL_ROLL"]
#define URL_SLOT_ROLL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SLOT_ROLL"]
#define URL_MB_ROLL_SHARE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_ROLL_SHARE"]
#define URL_MB_ROLL_HISTORY [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_ROLL_HISTORY"]
#define URL_REWARD_HISTORY [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_REWARD_HISTORY"]
#define URL_MB_ROLL_NOTE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_ROLL_NOTE"]
#define URL_MB_ROLL_LOGIN_NOTICE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_MB_ROLL_LOGIN_NOTICE"]

// feedback image upload
#define URL_FB_IMAGE_UPLOAD [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FB_IMAGE_UPLOAD"]
#define URL_SERIVCE_UPLOAD_IMG [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_SERIVCE_UPLOAD_IMG"]
#define URL_FB_ADD_NEW [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FB_ADD_NEW"]
#define URL_FB_GET_HISTORY [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FB_GET_HISTORY"]
#define URL_FB_GET_TYPE [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FB_GET_TYPE"]

//#define URL_PRODUCT_GUI @"http://m.51buy.com/touch-gui.html?source=gui"//ivy 修改：把m.51buy.com改成m.yixun.com
#define URL_PRODUCT_GUI @"http://m.yixun.com/touch-gui.html?source=gui"
#define URL_PRODUCT_PRICE @"http://m.yixun.com/touch-gui.html?source=price"

// for aftersale

#define URL_AFTERSALE_ORDER_LIST [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_AFTERSALE_ORDER_LIST"]
#define URL_AFTERSALE_ORDER_DETAIL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_AFTERSALE_ORDER_DETAIL"]
#define URL_AFTERSALE_ORDER_PROMPT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_AFTERSALE_ORDER_PROMPT"]

// new returnAndChange application
#define URL_ARETURNCHANGE_GETTYPES [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ARETURNCHANGE_GETTYPES"]
#define URL_ARETURNCHANGE_ADDRESSINFO [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ARETURNCHANGE_ADDRESSINFO"]
#define URL_ARETURNCHANGE_PAYBACKINFO [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ARETURNCHANGE_PAYBACKINFO"]
#define URL_ARETURNCHANGE_CREATEORDER [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ARETURNCHANGE_CREATEORDER"]

//ivyadd  验证码图片url
#define URL_VCODEIMG_URL [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_VCODEIMG_URL"]
//ivyadd  登录提交新地址
#define URL_VCODE_LOGIN [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_VCODE_LOGIN"]


#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define URL_FULL_DISTRICT [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_FULL_DISTRICT"]
#define URL_GUIDE_GETCOUPON [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_GUIDE_GETCOUPON"]
#define URL_GUIDE_PLANIMG [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_GUIDE_PLANIMG"]
#define URL_ORDER_REPORTGIS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_ORDER_REPORTGIS"]
#define URL_REDRESS_GIS [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_REDRESS_GIS"]
//ivy 2015-3-13
#define URL_VISIT_KEY [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_VISIT_KEY"]



#define PLACEHOLDERIMAGE_SMALL ([UIImage imageNamed:@"placeholder_200_200"])
#define PLACEHOLDERIMAGE_BIG ([UIImage imageNamed:@"placeholder_400_400"])

typedef enum{
	GOrderStatusPartlyReturn = -5,
	GOrderStatusReturn = -4,
	GOrderStatusManagerCancel = -3,
	GOrderStatusCustomerCancel = -2,
	GOrderStatusEmployeeCancel = -1,
	GOrderStatusOrigin = 0,
	GOrderStatusWaitingOutStock = 1,
	GOrderStatusWaitingPay = 2,
	GOrderStatusWaitingManagerAudit = 3,
	GOrderStatusOutStock = 4,
} GOrderStatus;

#define G_DB_NAME @"icson.sqlite"
#define GLOBAL_CACHE_KEY_UID @"global_cache_key_uid"
#define GLOBAL_CACHE_KEY_LAST_UID @"global_cache_key_last_uid"
#define GLOBAL_CACHE_KEY_QQ @"global_cache_key_qq"
#define GLOBAL_CACHE_KEY_LAST_QQ @"global_cache_key_last_qq"
#define GLOBAL_CACHE_KEY_SKEY @"global_cache_key_skey"
#define GLOBAL_CACHE_KEY_LOGIN_TYPE @"global_cache_key_login_type"
#define GLOBAL_CACHE_KEY_SITEID @"global_cache_key_site_id"
#define GLOBAL_CACHE_KEY_TOKEN @"global_cache_key_token"
#define GLOBAL_CACHE_KEY_SITE_SC @"global_cache_key_site_sc"
#define GLOBAL_CACHE_KEY_SET_ZONE @"global_cache_key_set_zone"
#define GLOBAL_CACHE_KEY_SET_PROVINCE @"global_cache_key_set_province"
#define GLOBAL_CACHE_KEY_SET_CITY @"global_cache_key_set_city"
#define GLOBAL_CACHE_KEY_SET_DISTRICT @"global_cache_key_set_district"

#define GLOBAL_COOKIE_NAME_UID @"uid"
#define GLOBAL_COOKIE_NAME_SKEY @"skey"
#define GLOBAL_COOKIE_NAME_LSKEY @"lskey"
#define GLOBAL_COOKIE_NAME_TOKEN @"token"
#define GLOBAL_COOKIE_NAME_WSID @"wsid"
#define GLOBAL_COOKIE_NAME_DISTID @"districtid"
#define GLOBAL_COOKIE_NAME_ENV @"env"
#define GLOBAL_COOKIE_NAME_SITE_SC @"ws_c"
#define GLOBAL_COOKIE_NAME_DEVICE_ID @"deviceid"

#define GLOBAL_COOKIE_NAME_CPSCOOKIES @"cps_cookies"
#define GLOBAL_COOKIE_NAME_CPSTKD @"cps_tkd"

typedef enum {
	GSITE_ID_SH = 1,
	GSITE_ID_SZ = 1001,
	GSITE_ID_BJ = 2001,
	GSITE_ID_WH = 3001
} GSITE_ID;

typedef enum {
	INVOICE_TYPE_RETAIL_PERSONAL = 1,
    INVOICE_TYPE_VAT = 2,
	INVOICE_TYPE_RETAIL_COMPANY = 3,
    INVOICE_TYPE_GUANGDONG_NORMAL = 4,
} INVOICE_TYPE;

static NSString * const kPersonalInvoiceTypeName = @"个人商业零售发票";
static NSString * const kCompanyInvoiceTypeName = @"单位商业零售发票";
static NSString * const kVATSpecialInvoiceName = @"增值税专用发票";

static NSString * const kGuangdongNormalTypeName = @"普通发票";
// 用户pin存本地，MTADES加密
#define USER_PIN_KEY                    @"this is the pinaddress key apoaffffe"
typedef enum {
    // from app
    AppLaunchPageActionDefault = 0,
} AppLaunchPageActionID;

//typedef enum {
//    // from message
//    AppLaunchPageActionMsgUnKnown = 0,
//    AppLaunchPageActionMsgArrived = 1,
//    AppLaunchPageActionMsgHome = 1001,
//    AppLaunchPageActionMsgCharge = ,
//    AppLaunchPageActionMsgCoupon = 1003,
//    AppLaunchPageActionMsgEvent = 1004,
//    AppLaunchPageActionMsgWebPage = 1005,
//    AppLaunchPageActionMsgMessageCenter = 1006,
//    AppLaunchPageActionMsgProductDetail = 1007,
//    AppLaunchPageActionMsgRoll = 1008,
//    AppLaunchPageActionMsgCommnentReminder = 2001,
//    AppLaunchPageActionMsgCommnentDeadLine = 2002,
//    AppLaunchPageActionMsgGuijiupeiAccepted = 3001,
//    AppLaunchPageActionMsgGuijiupeiRefuse = 3002,
//    AppLaunchPageActionMsgPriceGuardMatch = 3003,
//    AppLaunchPageActionMsgPriceGuardAccepted = 3004,
//    AppLaunchPageActionMsgPriceGuardRefuse = 3005,
//    AppLaunchPageActionMsgApproach = 3006,
//    AppLaunchPageActionMsgFreshManCoupon = 4001,
//} AppLaunchMessagePageActionID;

typedef enum {
    AppLaunchPageActionCPSWochacha = 1001,
} AppLaunchCPSPageActionID;

typedef enum {
    AppLaunchPageActionWechatPublic = 1001,
    AppLaunchPageActionWechatShare = 1002,
} AppLaunchWechatPageActionID;

typedef enum {
    AppLaunchPageActionTouch = 1001,
} AppLaunchTouchPageActionID;

typedef enum {
    /* ------ level 0 buy-path page ------ */
    GPageIDLaunchFromApp = 0,
    GPageIDLaunchFromMessage = 100000,
    GPageIDLaunchFromCPS = 100001,
    GPageIDLaunchFromWeixin = 100002,
    GPageIDLaunchFromTouch = 100003,
    /* ----------------------------------- */

    GPageIDRoot = 0,
    GPageIDTabBar = 199000,             //导航

    /* ------ level 1 buy-path page ------ */
    GPageIDHome = 1000,               //首页
    /* ----------------------------------- */
    
    GPageIDUserCenter = 11649770,       //我的易迅
    GPageIDCategory = 120000020,         //分类目录(本来是三个子页面，后来与cookie讨论之后改为一个，左滑与右滑各一个事件id)
    GPageIDShoppingCart = 220,     //购物车
    GPageIDMoreInfo = 770,         //更多
    GPageIDSearch = 103620100,               //搜索
    GPageIDSearchList = 210,       //分类商品
    GPageIDCommonFilter = 3200,     //筛选条件（基类）
    GPageIDSearchFilter = 199017,     //分类筛选
    GPageIDOneOrder = 199018,                //我的订单（单个订单）
    GPageIDItemCommnet = 199019,             //评价商品
    GPageIDSearchSubFilter = 199021,     //子筛选
    GPageIDScan         = 300,       // 二维码扫描
    GPageIDScanResult = 120000300,//二维码扫描结果
    GPageIDQiang = 780,                //抢购
//    GPageIDQiangNext = 199032,            //下期抢购
    GPageIDTuan = 170,                 //团购
//    GPageIDTuanPreview = 1210,
//    GPageIDTuanList = 1220,
    GPageIDEventMorning = 120,         //早市
    GPageIDEventTHH = 150,             //天黑黑
    GPageIDEventWeeked = 160,          //周末清仓
    GPageIDEventHotProduct = 130,      //热销榜
    GPageIDEventInterestedProduct = 140,//猜你喜欢
    GPageIDEvent = 199050,                //运营馆起始ID
    GPageIDEventAppleProduct = 199051,      //苹果
    GPageIDEventSingle = 199052,                //运营馆单列模式
    GPageIDEvent2 = 199053,                //运营馆2列模式
    GPageIDEventWirelssProduct = 199072,  //无线专区
    GPageIDEventMobileAndDigitProduct = 199053, //手机数码
    GPageIDEventComputer = 199064,           //电脑
    GPageIDHouseAppliances = 199065,         //生活家电
    GPageIDAutoPartsPage = 199056,           //汽车配件

    /* ------ level 3 buy-path page ------ */
    GPageIDProduct = 199081,          // 商品详情
    /* ----------------------------------- */
    
    GPageIDProductComment = 120001110,          //商品评论
    GPageIDProductParam = 120001210,          //商品参数
    GPageIDProductDetail = 120001310,          //商品图文详情
    GPageIDProductPic = 120001410,           //商品大图
    GPageIDLottery = 199091,        //抽奖
    GPageIDPhoneCharge = 720,             //手机充值
    GPageIDCouponList = 11708430,       //优惠券
    GPageIDMessageCenter = 120000050,         // 消息中心
    GPageIDRoll = 730, // 天天摇
    GPageIDWeb = 6000, //Web
    GPageIDIcsonEvent = 199099,         // 易抢
    GPageIDIntegral = 199100,           // 我的积分
    GPageIDBalance =  199101,            // 账户余额
    GPageIDGetCoupon = 1402,               //领取优惠券
    GPageIDLogin = 11703230,                   //登陆
    GPageIDLoginIcson = 11703260,                   //登陆易讯
    GPageIDLoginQQ = 11703250,                   //登陆QQ
    GPageIDLoginAlipay = 11703270,                   //登陆Alipay
    GPageIDRegister = 2200,                //注册
    GPageIDRegisterProtocolInfo = 2210,    //注册协议
    GPageIDOrders = 11594060,                  //我的订单列表
    GPageIDFavors = 11703220,                  //我的收藏
    GPageIDAddressList = 11709000,      //收货地址列表
    GPageIDAddressEditor = 2510,    //管理收货地址
    GPageIDCouponSelector = 11708430,   //选择优惠券
    GPageIDFilterOption = 3400,     //筛选选项
    
    GPageIDOrderConfirm = 250,     //订单确认
    GPageIDInvoiceEditor = 120001250,    //发票编辑
    GPageIDInvoiceList = 120002250,      //发票列表
    GPageIDOrderConfirmSelectCoupon = 120003250, //下单页面选择发票
    
    GPageIDVisitHistory = 750,     //浏览历史
    GPageAppRecommend = 120000110,  //应用推荐
    GPageIDFeedback = 120001740,                //意见反馈
    GPageIDAboutUs = 120000180,                 //关于我们
    
    GPageIDUnknow = 9999,           // 未知页面（非GViewControll）
    GPageIDFBHistory = 740,        // 意见反馈历史
    GPageIDFBOrderPicker = 5002,    // 意见反馈订单选择
    GPageIDCommonList = 5003,    // 通用列表页
    
    GPageAfterSaleCenter = 600,       // 服务中心
    GPageReturnAndChangeList = 120003740,   //报修退换货列表
    GPageReturnAndChangeDetail = 120005740, // 报修退换货详情
    GPageCancelOrderList = 3009,   //取消订单列表
    GPageCancelOrderDetail = 3010,   //取消订单详情
    
    GPageReturnOrderList = 120006740,    //申请报修退换货 - 订单选择
    GPageReturnProductList = 120007740,  //申请报修退换货 - 商品选择
    GPageReturnNewApplication = 120004740,   //新报修/退换货申请
    GPageFBImgViewer = 120008740,   //反馈照片页
}GPageID;

typedef enum {
    GPageCommonActionLogin = 90000, //登陆（自动登陆）
    GPageCommonActionBackPage = 19999, //页面返回
    GPageCommonActionUnknow = 99999 //
}GPageCommonAction;

typedef enum {
    GEventListProductPriceTypeNone,
    GEventListProductPriceTypeNormal,
    GEventListProductPriceTypeSoldOut,
    GEVEntListProductPriceTypeNoSale
}GEventListProductPriceType;

typedef enum {
    GEventListProductReferPriceTypeIcson,
    GEventListProductReferPriceTypeMarket,
    GEventListProductReferPriceTypeReduce,
    GEventListProductReferPriceTypeSnap,
    GEventListProductReferPriceTypeNone
}GEventListProductReferPriceType;

typedef enum {
    GEventListProductStatusSoldOut = 0,
    GEventListProductStatusOnSale = 1,
    GEventListProductStatusNoSale = 3,
    GEventListProductStatusUnKnow
}GEventListProductStatus;

typedef enum {
    GEventTemplateSingleColumn,
    GEventTemplateDoubleColumn
}GEventTemplateType;


typedef enum {
    SMSValidateTypeRegister = 1,
    SMSValidateTypeFindPassword
}SMSValidateType;

static const int kInvalidShowPrice = 99999900;

@class GConfig;
@class ATCountDown;

@interface GConfig : NSObject
{
	NSLock *_lock;
}
@property (nonatomic, strong) NSString *      envInfo;
@property (nonatomic, strong) NSLock   *      lock;
@property (nonatomic, strong) KTCLocation *currentLocation;
@property (nonatomic, strong) ATCountDown *smsCodeCountDown;
@property (nonatomic, copy) NSString *currentSMSCodeKey;

+ (GConfig *)sharedConfig;
- (void)load;
- (void)refresh:(NSDictionary*)dic;
- (NSDictionary*)getAllConfigURL;
- (NSString *)getURLStringWithAliasName:(NSString *)aliasName;

- (BOOL)loadWebImage;

- (void)setLoadWebImage:(BOOL)bLoad;

- (NSString *)currentLocationCoordinateString;

- (void)startSMSCodeCountDownWithLeftTime:(void(^)(NSTimeInterval currentTimeLeft))left  completion:(void(^)())completion;


+ (NSString *)getInvoiceTypeName:(INVOICE_TYPE)invoiceType;
- (NSString *)getInvoiceDesc:(NSDictionary *)_invoice;
- (INVOICE_TYPE)invoiceTypeStrToTypeID:(NSString *)typeStr;
- (HttpRequestMethod)getURLSendDataMethodWithAliasName:(NSString *)aliasName;
+ (NSString *)getCurrentAppVersionCode;
- (BOOL)getIsAutoResume; // 是否需要对用户自动续票

// update immune period
+ (BOOL)isInUpdateImmunePeriod:(NSDate *) today;
+ (void)restartUpdateImmunePeriod;

// force update flag
+ (NSDictionary *)getForceUpdateInfo;
+ (void)setForceUpdateInfo:(NSDictionary *)versionInfo;

+ (NSDictionary *)getLastOrderInfo;
+ (void)setLastOrderInfo:(NSDictionary *)orderInfo;

//+ (NSInteger)getZoneIDWithDistrictID:(NSInteger)districtID;
//+ (void)setAreaByDistrictID:(NSInteger)districtIDToBeFind;
//+ (void)setDistrictItemWithDistrictID:(NSInteger)districtID;
//+ (NSInteger)getProvinceIDWithDistrictID:(NSInteger)districtID;

// search history list
+ (NSArray*)getSearchHistory;
+ (void)addSearchHistory:(NSString*)str;
+ (void)clearAllSearchHistory;

/**
 *  获取当前时间
 */
+ (NSString *)getNowDateTS;

+ (id)getObjectFromNibWithView:(UIView *)view;

+ (CGFloat)heightForLabelWithWidth:(CGFloat)width LineBreakMode:(NSLineBreakMode)mode Font:(UIFont *)font topGap:(CGFloat)tGap bottomGap:(CGFloat)bGap andText:(NSString *)text;
+ (CGFloat)heightForLabelWithWidth:(CGFloat)width LineBreakMode:(NSLineBreakMode)mode Font:(UIFont *)font topGap:(CGFloat)tGap bottomGap:(CGFloat)bGap maxLine:(NSUInteger)line andText:(NSString *)text;

+ (void)resetLineView:(UIView *)view withLayoutAttribute:(NSLayoutAttribute)attribute;

+ (NSString *)generateSMSCodeKey;

@end
