/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：OCOrderItem.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-2-28
 */

#import <Foundation/Foundation.h>

static const int kItemInfoEmptyErrorTag = 31415926;
static const int kOrderPartitionErrorTag = 31415927;
static const int kPurchaseCountErrorTag = 0; //限购数量 Error Code 需要更新

@interface OCOrderItem : NSObject

//@property (nonatomic) NSInteger orderID;                    // 订单ID
//@property (nonatomic) int isVirtual;                        // 虚拟订单类型
//@property (nonatomic, retain) NSString *vValue;             // 延迟配送天数
//@property (nonatomic) NSInteger ruleBenefits;               // 该订单的优惠金额
//@property (nonatomic) NSInteger totalAmt;                   // 订单总价额
//@property (nonatomic) NSInteger totalCut;                   // 订单总满减价格
@property (nonatomic, strong) NSArray *invoiceContentArr;   // 可用的发票内容列表
@property (nonatomic) BOOL isCanVAT;                        // 是否可以开增值税发票
//@property (nonatomic, retain) NSDictionary *productList;    // 订单中的商品列表
//edit by Altair, 20141124, use array instead of dic
@property (nonatomic, strong) NSArray *promotionArray;   // 优惠信息
@property (nonatomic, strong) NSDictionary *pointRange;     // 积分限制
@property (nonatomic) BOOL allowCoupon;                     // 是否可以使用优惠劵

@property (nonatomic, strong) NSDictionary *packageItems;   //包裹信息字典
@property (nonatomic, strong) NSArray *coupons;         //单品赠券字典

- (id)initWithRawData:(NSDictionary *)rawData;

@end

@interface  OCPackageItem : NSObject
@property(nonatomic,strong) NSString* orderID;                     //订单ID xiaomanwang modified新版本必须用001，不可以转为整数
@property(nonatomic) NSInteger psyStock;                    //分仓的id
@property(nonatomic) int isVirtual;                         //虚拟订单类型
@property(nonatomic,strong) NSString *vValue;               //延迟配送天数
@property(nonatomic) NSInteger ruleBenefits;               //改订单的优惠金额
@property(nonatomic) NSInteger totalAmt;                    //订单总价额
@property(nonatomic) NSInteger totalCut;                    //订单总满减价格
@property (nonatomic, strong) NSDictionary *productList;    // 订单中的商品列表
@property (nonatomic, strong) NSDictionary *promotionDic;   // 优惠信息
@property (nonatomic, strong) NSDictionary *pointRange;     // 积分限制
@property (nonatomic) BOOL allowCoupon;                     // 是否可以使用优惠劵

//以下三个参数，用来支持新联营
@property (nonatomic) int saleMode;
@property (nonatomic) int sallerId;
@property (nonatomic) int sallerStockId;


- (id)initWithRawData:(NSDictionary *)rawData andKey:(NSString*)key;

@end
