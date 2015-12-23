/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：ShortCut.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：2012年9月23日
 */


#ifndef iPad51Buy_Shortcut_h
#define iPad51Buy_Shortcut_h

#define MAKE_LABEL(rect, text, color, fontSize) [GToolUtil makeLabelWithFrame: (rect)\
options: [NSDictionary dictionaryWithObjectsAndKeys:\
(text), @"text",\
(color), @"textColor",\
[UIFont systemFontOfSize: (fontSize)], @"font",\
nil]]

#define MAKE_LABEL_WITH_INSETS(rect, insets, text, color, fontSize) [GToolUtil makeLabelWithFrame: (rect)\
andInsets:(insets)\
options: [NSDictionary dictionaryWithObjectsAndKeys:\
(text), @"text",\
(color), @"textColor",\
[UIFont systemFontOfSize: (fontSize)], @"font",\
nil]];

#define MAKE_STRIKELABEL(rect, text, color, fontSize) [GToolUtil makeStrikeLabelWithFrame: (rect)\
options: [NSDictionary dictionaryWithObjectsAndKeys:\
(text), @"text",\
(color), @"textColor",\
[UIFont systemFontOfSize: (fontSize)], @"font",\
nil]];

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBA_HEX(v, a) [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 green:((float)(((v) & 0xFF00) >> 8))/255.0 blue:((float)((v) & 0xFF))/255.0 alpha:(a)]
#define XPOINTOF(view) view.frame.origin.x
#define YPOINTOF(view) view.frame.origin.y
#define WIDTHOF(view) view.frame.size.width
#define HEIGHTOF(view) view.frame.size.height
#define MOVEVIEWTOX(view, x) view.frame = CGRectMake(x, YPOINTOF(view), WIDTHOF(view), HEIGHTOF(view))
#define MOVEVIEWTOY(view, y) view.frame = CGRectMake(XPOINTOF(view), y, WIDTHOF(view), HEIGHTOF(view))
#define CHANGEWIDTHOFVIEW(view, width) view.frame = CGRectMake(XPOINTOF(view), YPOINTOF(view), width, HEIGHTOF(view))
#define CHANGEHEIGHTOFVIEW(view, height) view.frame = CGRectMake(XPOINTOF(view), YPOINTOF(view), WIDTHOF(view), height)
#define LOADIMAGE(file,ext) [UIImage imageNamed:(file)]
//#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]] // arc 版本种这个方法会造成严重的效率问题
#define GBSTR_FROM_DATA(data) [[NSString alloc] initWithData: (data) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif)]

#define UTF82GBK(str) [[NSString alloc] initWithData:[str dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(NSUTF8StringEncoding)] encoding: kCFStringEncodingGB_18030_2000]
#define GBK2UTF8(str) [[NSString alloc] initWithData:[str dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] encoding: NSUTF8StringEncoding]
#define INT2STRING(intValue) [NSString stringWithFormat:@"%d", intValue] 
#define INT2NUMBER(intValue) [NSNumber numberWithInt:intValue] 
#define O2STR(obj) (obj ? [NSString stringWithFormat:@"%@", obj] : @"")
#define IDTOSTRING(idValue) (([idValue isKindOfClass:[NSString class]] && ![idValue isEqualToString:@"0"]) ? idValue : (([idValue isKindOfClass:[NSNumber class]] && ![idValue isEqual:@0]) ? O2STR(idValue) : @""))

//add by ivy :是否有值 && 是否为NSString && 是否不为""
#define DATATOSTRINGORNIL(dataValue) ((dataValue && [dataValue isKindOfClass:[NSString class]] && ![dataValue isEqualToString:@""]) ? dataValue : nil);
#define DATATOSTRINGOREMPTY(dataValue) ((dataValue && [dataValue isKindOfClass:[NSString class]] && ![dataValue isEqualToString:@""]) ? dataValue : @"");
#define DATATOINTEGERORZERO(dataValue) (dataValue ? ([dataValue integerValue]):0)
#define DATATOARRAYORNIL(dataValue) ((dataValue && [dataValue isKindOfClass:[NSArray class]] && [dataValue count] > 0)? dataValue:nil)

#define FILE_FULL_PATH(path) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent: (path)]
#define FILE_FULL_PATH_IN_DOCUMENT(path) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent: (path)]
#define FILE_CACHE_PATH(path) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent: (path)]

#define PRICE_WITH_DECIMAL(price) [GToolUtil covertPriceToString:price]

#define iPhone5 CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)

#endif
