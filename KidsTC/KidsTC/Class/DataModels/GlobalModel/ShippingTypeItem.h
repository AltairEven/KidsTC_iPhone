/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：ShippingTypeItem.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-2-28
 */

#import <Foundation/Foundation.h>

typedef enum {
    ShippingNoFree,
    ShippingMayFree,
} ShippingFreeType;

@interface ShippingTimeItem : NSObject

@property (nonatomic, strong) NSString *name;                   // 配送时间名称
@property (nonatomic, strong) NSString *shipDate;               // 配送时间
@property (nonatomic) NSInteger status;                         // 配送状态
@property (nonatomic) NSInteger timeSpan;                       // 用于排序
@property (nonatomic) NSInteger weekDay;                        // 每周中第几天

- (id)initWithRawData:(NSDictionary *)rawData;

@end

@interface UnifiedShippingTimeItem : NSObject
@property (nonatomic, strong) NSString *name;                    //统一配送时间名称
@property (nonatomic, strong) NSString*shipDate;                 //统一配送时间
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger timeSpan;                        //上午，下午，晚上
@property (nonatomic) NSInteger weekDay;                         //周几
@property (nonatomic, strong) NSDictionary*spanList;             //统一配送时间，每个包裹里的时间
- (id)initWithRawData:(NSDictionary *)rawData;
@end

@interface ShippingTypeItem : NSObject

@property (nonatomic) NSInteger shippingTypeID;                 // 配送方式ID
@property (nonatomic, strong) NSString *shippingTypeName;       // 配送方式名称
@property (nonatomic) NSInteger freePriceLimit;                 // 免运费价格下限
@property (nonatomic) ShippingFreeType freeType;                // 0:需要运费 1:可能需要运费
@property (nonatomic) NSInteger shippingCost;                   // 运费成本
@property (nonatomic) NSInteger shippingPrice;                  // 运费价格
@property (nonatomic) NSInteger shippingCutPrice;               // 运费减免
//@property (nonatomic, retain) NSArray *availabelTimeList;       // 可用的配送时间
//@property (nonatomic, retain) ShippingTimeItem *curTimeItem;    // 当前选择的时间
@property (nonatomic, strong)NSDictionary *availabelPackageTimeList; //可用的包裹的配送时间
@property (nonatomic, strong)NSDictionary *selectedShippingTimeItem; //每个包裹的对应的配送时间的key value对，value就是一个ShippingTimeItem对象,默认都是选择第一个
@property (nonatomic, strong)NSDictionary *availableShippingPrice;

@property (nonatomic, strong) NSArray *unifiedShipTypeLists;
@property (nonatomic, strong) UnifiedShippingTimeItem *selectedUnifiledShippingTimeItem;

@property (nonatomic, strong) ShippingTimeItem *timeAvaiablePre;  // jenny新增：第三方快递仅显示预计配送时间

- (id)initWithRawData:(NSDictionary *)rawData;
- (NSString *)getShipTypeDesc;

@end
