//
//  GToolUtil.h
//  iphone
//
//  Created by icson apple on 12-2-27.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GLabel.h"
#import "UserWrapper.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "GInterface.h"
#import "IcsonImageView.h"
#import "ATCountDown.h"
#import "UIButton+Color.h"

@interface Reachability(GReachability)
+(Reachability *)sharedReachability;
@end

@interface CTTelephonyNetworkInfo(GTelephonyNetworkInfoAddition)
+(CTTelephonyNetworkInfo *)sharedTelephonyNetworkInfo;
@end

typedef enum {
	GBorderNone = 0,
	GBorderTop = 1 << 0,
	GBorderLeft = 1 << 1,
	GBorderBottom = 1 << 2,
	GBorderRight = 1 << 3
} GBorderOption;


typedef struct {
    NSUInteger hour;
    NSUInteger min;
    NSUInteger sec;
}TimeStructHMS;


@interface GStrikeLabel : UILabel
@end


NSInteger sortImageDictionaryWithIdx(id v1, id v2, void *context);

@interface GToolUtil : NSObject
+(NSString*)urlEscape:(NSString *)unencodedString;
+ (NSString *)urlUnescape: (NSString *) input;
+(NSString*)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params;
+(GLabel *)makeLabelWithFrame:(CGRect) rect options:(NSDictionary *)options;
+(GLabel *)makeLabelWithFrame:(CGRect) rect andInsets:(UIEdgeInsets)_insets options:(NSDictionary *)options;
+(GStrikeLabel *)makeStrikeLabelWithFrame:(CGRect) rect options:(NSDictionary *)options;

+(void)_prepareLabelWithOptions:(UILabel*) label options:(NSDictionary *)options;
+(void)removeAllSubViews:(UIView *)view;

+(NSString *)getProductPic:(NSString *)productCharId type:(NSString *)type index:(NSInteger)index;

+(UIImage*)imageNamed:(NSString*)imageNamed cache:(BOOL)cache;
+(void)showLoading:(UIView *)view;

+(NSString *) stripTags:(NSString *)str;

+(NSArray *)makeArray:(id)dictionaryOrArray;

+(void)changeViewWidth:(UIView *)view width:(CGFloat)width;
+(void)changeViewHeight:(UIView *)view height:(CGFloat)height;

+(GSITE_ID)getSiteId;
+(NSString *)UTF82GBK:(NSString *)str;

+(NSString *)formatDate:(NSTimeInterval)timeSeconds setTimeFormat:(NSString *)timeFormatStr setTimeZone:(NSString *)timeZoneStr;
+ (CGFloat)getHeightFittedForStr:(NSString *)str fontSize:(CGFloat)_fontSize viewWidth:(CGFloat)_viewWidth;
+ (UIImage *) createImageWithColor: (UIColor *) color;
+(NSDictionary *)convertCategoryArrayToDictionary:(NSArray *)category;
+(NSDictionary *)convertNewCateConditionToDictionary:(NSArray *)newCateCondition;

+(BOOL)isEmpty:(id)obj;
+(NetworkStatus)checkNetworkStatus;

+(void)setKeyboardFrameChangeListener:(id)listener;
+(void)unsetKeyboardFrameChangeListener:(id)listener;

+ (void)checkLogin:(void(^)(NSString *uid))_afterLoginSuccess target:(id)target;

+(NSString *)trim:(NSString *)str;
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;
+(NSString *)getDeviceInfo;
/*
 \brief 比较版本号大小
 \return -1 firstVersion < secondVersion
          0 firstVersion = secondVersion
          1 firstVersion > secondVersion
 */
+ (int)compareVersion:(NSString *)firstVersion version:(NSString *)secondVersion;

+ (NSString *)checkErrMessage:(NSError *)error;
// count word
+ (int) gCountWord:(NSString*) s;

+ (NSString*)svnVersion;
+(BOOL)isNetworkWifiStatus;
//+(NetworkStatus)checkNetworkStatus;
+ (CGAffineTransform) transformForCurrentOrientation;
+ (BOOL)isFirstUsedRoll;


//为了正确显示价格，所以封装这个函数
+ (NSString *)covertPriceToString:(int)price;
//封装显示价格
+ (void)showPrice:(int)price inLabel:(UILabel *)label;
//封装显示出错信息
+ (BOOL)showErrorMsg:(NSData *)returnStr;
+ (BOOL)filterBlackList:(NSString*)urlToFilter;

+ (void)configureLabel:(UILabel*)label withFont:(CGFloat)fontSize withTextColor:(UIColor*)color;
+ (void)configureButton:(UIButton*)button withFont:(CGFloat)fontSize withTextColor:(UIColor*)textColor withTitle:(NSString*)title withNorImage:(NSString*)norImageName withHighImage:(NSString*)highImageName;

+ (NSString*)changeUrl:(NSString*)url  withIndex:(NSInteger)index;
+ (NSString*)changeUrl:(NSString*)url  andResolution:(RESOLUTION_WANG_GOU)res;
+ (NSString*)changeUrl:(NSString*)url  withIndex:(NSInteger)index andResolution:(RESOLUTION_WANG_GOU)res;

+ (NSDictionary*) parsetUrl:(NSString*)urlString;

//add by Altair, 20150324
+ (NSString *)timeStringFromTimeStamp:(NSUInteger)timeStamp withDateFormatterString:(NSString *)formatString;

+ (NSString *)countDownTimeStringWithLeftTime:(NSTimeInterval)leftTime;
+ (TimeStructHMS)countDownTimeStructHMSWithLeftTime2:(NSTimeInterval)leftTime;

//如果filePath中已存在，则直接返回YES
//如果bundle和filePath中都不存在，则返回NO
//如果bundle中存在，则复制到filePath，并返回拷贝结果。
+ (BOOL)copyFileFormBundlePath:(NSString *)bundlePath toFilePath:(NSString *)filePath;

+ (CLLocationCoordinate2D)coordinateFromString:(NSString *)string;

+ (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate;


+ (UIView*)duplicate:(UIView*)view;


+ (NSString *)jsonFromObject:(id)obj;

+ (UIImage *)takeSnapshotForView:(UIView *)view;

+ (NSUInteger)byteCountOfImage:(UIImage *)image;

+ (void)drawLineOnView:(UIView *)view withStartPoint:(CGPoint)start endPoint:(CGPoint)end lineWidth:(CGFloat)width gap:(CGFloat)gap sectionLength:(CGFloat)length color:(UIColor *)color isVirtual:(BOOL)isVirtual;

+ (NSString *)distanceDescriptionWithMeters:(NSUInteger)meters;
+ (NSString *)timeDescriptionWithSeconds:(NSUInteger)seconds;

@end
