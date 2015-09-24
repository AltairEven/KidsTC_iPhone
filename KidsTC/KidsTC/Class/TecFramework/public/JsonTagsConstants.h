/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：Constants.h
 * 文件标识：
 * 摘 要：定义所有在网络请求回来的json数据中使用到的tag。禁止使用硬编码的方式使用常量
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：2012年9月18日
 */
#ifndef iPad51Buy_JsonTagsConstants_h
#define iPad51Buy_JsonTagsConstants_h


//define all the tags in response json data
#define ERRNO_TAG                   @"errno"
#define DATA_TAG                    @"data"
#define EVENT_TAG                   @"event"
#define PIC_URL_TAG                 @"pic_url"
#define EVENT_ID_TAG                @"event_id"
#define TEMPLATE_ID_TAG             @"template_id"
#define TIME_LIMIT_TAG              @"time_limit"
#define NOW_TAG                     @"now"
#define BEGIN_TAG                   @"begin"
#define END_TAG                     @"end"
#define PRODUCTS_TAG                @"products"
#define NAME_TAG                    @"name"
#define PRODUCT_CHAR_ID_TAG         @"product_char_id"
#define PRODUCT_ID_TAG              @"product_id"
#define SHOW_PRICE_TAG              @"show_price"
#define MARKET_PRICE_TAG            @"market_price"
#define SALE_TYPE_TAG               @"sale_type"
#define GIFT_COUNT_TAG              @"gift_count"
#define GIFTS_TAG                   @"gifts"
#define PROMOTION_WORD_TAG          @"promotion_word"
#define SALE_COUNT_TAG              @"sale_count"

// product gift additions
#define SHOW_ORDER_TAG              @"show_order"
//#define GIFT_TYPE_TAG               @"type"

// product detail
#define PRODUCT_GIFTS_TAG           @"gifts"
#define MULTI_PRICE_TAG             @"multiPrice"
#define NUM_LIMIT_TAG               @"num_limit"
#define PIC_NUM_TAG                 @"pic_num"
#define REVIEW_TAG                  @"review"
#define RULES_TAG                   @"rules"
#define STOCK_TAG                   @"stock"
#define T_COLOR_BLOCK_TAG           @"t_color_block"
#define T_SIZE_BLOCK_TAG            @"t_size_block"

// product list 
#define PAGE_INFO_TAG               @"page"
#define CUR_PAGE_TAG                @"current_page"
#define PAGE_COUNT_TAG              @"page_count"
#define TOTAL_ITEM_TAG              @"total"
#define CATEGORY_ID_TAG             @"cid"
#define CLASSSES_TAG                @"classes"
#define C3ID_TAG                    @"c3id"
#define C3NAME_TAG                  @"c3name"

// user coupon
#define COUPON_CODE                 @"code"
#define COUPON_AMT                  @"coupon_amt"
#define VALID_TIME_FROM             @"valid_time_from"
#define VALID_TIME_TO               @"valid_time_to"

#define COMMENT_TAG                 @"comment"
#define COMMENT_STAR_LENGTH         @"star_length"
#define SATISFIED_TAG               @"satisfied"
#define GENERAL_TAG                 @"general"
#define UNSATISFIED_TAG             @"unsatisfied"
#define PROMO_NAME_TAG              @"promo_name"

#define VERSIONNAME_TAG             @"versionName"
#define RETCODE_TAG                 @"retCode"
#define NEEDUPDATE_TAG              @"needUpdate"
#define DES_TAG                     @"desc"

#define ADVERTISE_URL_TAG           @"advertise_url"

#define LIST_URL_TAG                @"list_url"
#define BACKGROUND_TAG              @"background"
#define PRODUCTS_TAG                @"products"

#define TYPE_TAG                    @"type"

#define USER_LEVEL_TAG              @"user_level"
#define USER_NAME_TAG               @"user_name"

#define CONTENT_TAG                 @"content"

#define CREATE_TIEM_TAG             @"create_time"

#define STAR_TAG                    @"star"
#define LIST_TAG                    @"list"
#define URL_TAG                     @"url"
#define TEXT_TAG                    @"text"
#define SPACE_IN_HTML               @"&nbsp;"
#define NUM_TAG                     @"num"
#define PROMORULE_TAG               @"promoRule"
#define RULES_BUY_MORE_TAG          @"rules_buy_more"
#define AID_TAG                     @"aid"

#define MEMO_TAG                    @"memo"
#define SHIP_DATE_TAG               @"ship_date"
#define TIME_SPAN_TAG               @"time_span"
#define SUBORDER_TAG                @"subOrder"
#define TIMEAVAIABLE_TAG            @"timeAvaiable"
#define FORBIDDEN_TAG               @"forbidden"
#define DEPTID_TAG                  @"deptId"
#define BKEY_TAG                    @"bKey"
#define DISTRICT_TAG                @"district"
#define ITEMS_TAG                   @"items"
#define TOTALWEIGHT_TAG             @"totalWeight"
#define ISVIRTUAL_TAG               @"isVirtual"
#define WEIGHT_TAG                  @"weight"
#define SHIPPINGPRICE_TAG           @"shippingPrice"
#define SHIPPINGID_TAG              @"ShippingId"
#define PRODUCT_ID_ONEKEY_TAG       @"product_id_onkey"
#define GIFT_TAG                    @"gift"
#define SMALL_TAG                   @"small"
#define PRODUCTNAME_TAG             @"ProductName"
#define PHONE_TAG                   @"phone"
#define WORKPLACE_TAG               @"workplace"
#define MESSAGE_TAG                 @"message"
#define ID_TAG                      @"id"
#define IID_TAG                     @"iid"
#define PRICE_TAG                   @"price"
#define POINT_TAG                   @"point"
#define ICSONID_TAG                 @"icsonid"
#define LEVEL_TAG                   @"level"
#define DEFAULT_SPLASH_PIC_URL      @"defaultRUL"
#define SPECIAL_SPLASH_PIC_URL      @"URL"
#define SPECIAL_SPLASH_PIC_DURATION @"duration"
#define SPECIAL_SPLASH_PIC_STARTTIME @"beginTime"
#define SPECIAL_SPLASH_PIC_ENDTIME @"endTime"

#define MSG_TAG                     @"msg"
#endif
