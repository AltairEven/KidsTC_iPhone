/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：Constants.h
 * 文件标识：
 * 摘 要：定义所有在代码中出现的枚举常量。禁止使用硬编码的方式使用常量
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：2012年9月18日
 */

#ifndef iPad51Buy_EnumConstants_h
#define iPad51Buy_EnumConstants_h

//typedef enum
//{
//	QQLogin = 1,
//	AliLogin,
//	
//}LoginType;

typedef enum {
	HttpRequestMethodGET = 0,
	HttpRequestMethodPOST = 1
} HttpRequestMethod;

typedef enum {
	HttpRequestStatusInitialize = 0, // initialize
	HttpRequestStatusLoading = 1, // loading
	HttpRequestStatusCompleted = 2, // completed
} HttpRequestStatus;


typedef enum{
    GProductActionProductTab = 20000, //itemID =  GProductActionProductTab + itemIndex -1;
    GProductActionProductDetial = 20001,
    GProductActionProductInfo = 20002,
    GProductActionProductParam = 20003,
    GProductActionProductDiscuss = 20004,
    GProductActionImage = 30001,
    GProductActionAddress = 31001,
    GProductActionCount = 32001,
    GProductActionBuy = 41001,
    GProductActionShoppingCart = 42000,
    GProductActionToPay = 42001,
    GProductActionToShopping = 42002,
    GProductActionFavors = 43003,
    GProductActionBrowseList = 50001,
    GProductActionBuyList = 60001
    
} GProductAction;


typedef enum{
    GPushBizNone = 30000,
    GPushBizArrived = 30001,
    GPushBizHomepage = 31001,
    GPushBizCharge = 31002,
    GPushBizChannelEvent = 31004,
    GPushBizMessageCenter = 31006,
    GPushBizProductDetail = 31007,
    GPushBizCommentReminder = 32001,
    GPushBizCommentDeadline = 32002,
    GPushBizBizGuijiupeiAccepted = 33001,
    GPushBizBizGuijiupeiRefuse = 33002,
    GPushBizBizPriceGuardMatch = 33003,
    GPushBizPriceGuardAccepted = 33004,
    GPushBizPriceGuardRefuse = 33005,
    GPushBizFreshManCoupon = 34003,
    GPushBizRoll = 31008,
    GPushFeedbak = 30016,
    GPushBizReturnAndChangeDetail = 30017,
    
} GPushAction;



typedef enum  {
    HomeIDUnDefined = -1,
    
    /* event invariability */
    HomeEventIDQiang = 31415,
    HomeEventIDTuan = 31416,
    HomeEventIDReXiao = 31417,
    HomeEventIDMorning = 1,
    HomeEventIDEvening = 2,
    HomeEventIDWeekEnd = 3,
    
    /* This event is allways on the banner and will trigger a webview, you can show anything you want according to the web url */
    HomeEventIDUniversalOnBanner = 99,
    
    /* event link to local controller */
    HomeEventIDCategory = 200,
    HomeEventIDCoupon = 201,
    HomeEventIDShip = 202,
    HomeEventIDTelCharge = 203,
    HomeEventIDHistory = 204,
    HomeEventIDLike = 205,
    HomeEventIDFeedback = 206,
    HomeEventIDAfterSale = 207,
    HomeEventIDLotteryTicket = 208,
    HomeEventIDDefault = 220,
} HOME_EVENT_ID;

typedef enum {
    EventItemTypeLink = 5
    
}EventItemType;

typedef enum {
    BannerFetchCoupon = 1,
    BannerDrawLottery = 2,
    BannerBusinessChannel = 3,
    BannerSingleProduct = 4,
    BannerExternalLink = 5,
} BannerType;

typedef enum {
    RollFinishedTaskItemModeCoupon      = 1,    //优惠券
    RollFinishedTaskItemModeLottery     = 2,    //抽奖
//    RollFinishedTaskItemModeCannel      = 3,    //运营馆频道
    RollFinishedTaskItemModeProduct     = 4,    //商品详情
    RollFinishedTaskItemModeSafari      = 5,    //浏览器
    RollFinishedTaskItemModeTuan        = 6,    //团购
    RollFinishedTaskItemModeMorning     = 7,    //早市
    RollFinishedTaskItemModeNight       = 8,    //晚市
    RollFinishedTaskItemModeWeekend     = 9,    //周末清仓
    RollFinishedTaskItemModeCharge      = 10,    //充值
    RollFinishedTaskItemModeWeb         = 11,    //web页
    RollFinishedTaskItemModeQiang       = 13,    //抢购
    RollFinishedTaskItemModeEvent       = 14,    //运营馆
    RollFinishedTaskItemModeHotProduct  = 15    //热销榜
}RollFinishedTaskItemMode;

#endif
