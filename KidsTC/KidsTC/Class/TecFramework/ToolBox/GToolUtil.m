//
//  GToolUtil.m
//  iphone
//
//  Created by icson apple on 12-2-27.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GToolUtil.h"
#import "RegexKitLite.h"
#import "GNavController.h"
#import "UIAlertView+Blocks.h"
#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>

static NSMutableDictionary *staticImageDictionary;
static NSInteger staticImageDictionaryIndex = 0;

static CTTelephonyNetworkInfo *_sharedTelephonyNetworkInfo;
static Reachability *_sharedReachability;

@implementation CTTelephonyNetworkInfo(GTelephonyNetworkInfoAddition)

+(CTTelephonyNetworkInfo *)sharedTelephonyNetworkInfo
{
	@synchronized([self class]){
		if (!_sharedTelephonyNetworkInfo) {
			_sharedTelephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
		}
		
		return _sharedTelephonyNetworkInfo;
	}
	
	return nil;
}

@end

@implementation Reachability(GReachability)

+(Reachability *)sharedReachability
{
    @synchronized([self class])  
    {  
		if (!_sharedReachability) {
			_sharedReachability = [[self class] reachabilityForInternetConnection];
		}
        return _sharedReachability;
    }
	
    return nil;  
}

- (void)setSharedReachability:(Reachability *)__reachability
{
	_sharedReachability = __reachability;
}

@end

@implementation GStrikeLabel

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	CGContextRef c = UIGraphicsGetCurrentContext();

	const CGFloat *black = CGColorGetComponents([self.textColor CGColor]);
	CGContextSetStrokeColor(c, black);
	CGContextSetLineWidth(c, 1);
	CGContextBeginPath(c);
	CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
	CGContextMoveToPoint(c, self.bounds.origin.x, halfWayUp);
	CGContextAddLineToPoint(c, self.bounds.origin.x + self.bounds.size.width, halfWayUp);
	CGContextStrokePath(c);
}

@end


@implementation GToolUtil
/*
 URL 字符串 里面可能包含某些字符，比如‘$‘ ‘&’ ‘？’...等，这些字符在 URL 语法中是具有特殊语法含义的，
 
 比如 URL ：http://www.baidu.com/s?wd=%BD%AA%C3%C8%D1%BF&rsv_bp=0&rsv_spt=3&inputT=3512
 
 中 的 & 起到分割作用 等等，如果 你提供的URL 本身就含有 这些字符，就需要把这些字符 转化为 “%+ASCII” 形式，以免造成冲突
 */
+(NSString*)urlEscape:(NSString *)unencodedString {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
																	  (CFStringRef)unencodedString,
																	  NULL,
																	  (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																	  kCFStringEncodingGB_18030_2000));
}

/*
 作用同上一个函数相反
 */
+ (NSString *)urlUnescape: (NSString *) input  
{
	return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
																	  (CFStringRef)input,
																	  (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																	  kCFStringEncodingGB_18030_2000));
}  

//把传入的参数按照get的方式打包到url后面。
+ (NSString*)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params
{
    if (nil == url) {
        return @"";
    }
	NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:url];
	// Convert the params into a query string
	if (params) {
		for(id key in params) {
			NSString *sKey = [key description];
			NSString *sVal = [[params objectForKey:key] description];
			//是否有？，必须处理这个
			if ([urlWithQuerystring rangeOfString:@"?"].location==NSNotFound) {
				[urlWithQuerystring appendFormat:@"?%@=%@", [GToolUtil urlEscape:sKey], [GToolUtil urlEscape:sVal]];
			} else {
				[urlWithQuerystring appendFormat:@"&%@=%@", [GToolUtil urlEscape:sKey], [GToolUtil urlEscape:sVal]];
			}
		}
	}
    
	return urlWithQuerystring;
}

+(GLabel *)makeLabelWithFrame:(CGRect) rect options:(NSDictionary *)options
{
	GLabel *label = [[GLabel alloc] initWithFrame: rect];
	[GToolUtil _prepareLabelWithOptions: label options: options];
	return label;
}


+(GLabel *)makeLabelWithFrame:(CGRect) rect andInsets:(UIEdgeInsets)_insets options:(NSDictionary *)options
{
	GLabel *label = [[GLabel alloc] initWithFrame: rect andInsets: _insets];
	[GToolUtil _prepareLabelWithOptions: label options: options];
	return label;
}

+(GStrikeLabel *)makeStrikeLabelWithFrame:(CGRect) rect options:(NSDictionary *)options
{
	GStrikeLabel *label = [[GStrikeLabel alloc] initWithFrame: rect];
	[GToolUtil _prepareLabelWithOptions: label options: options];
	return label;
}

+(void)_prepareLabelWithOptions:(UILabel*) label options:(NSDictionary *)options
{
	NSEnumerator *en = [options keyEnumerator];
	id key;
	while (key = [en nextObject]) {
		if ( [key isEqualToString: @"text"]) {
			label.text = [options valueForKey: key];
		} else if ( [key isEqualToString: @"textColor"]) {
			label.textColor = [options valueForKey: key];
		} else if ( [key isEqualToString: @"font"]) {
			label.font = [options valueForKey: key];
		} else if ( [key isEqualToString: @"shadowColor"]) {
			label.shadowColor = [options valueForKey: key];
		}
	}
    label.backgroundColor = [UIColor clearColor];
}

+(void)removeAllSubViews:(UIView *)view
{
	for (UIView *subView in view.subviews) {
		[subView removeFromSuperview];
	}
}

+(NSString *)getProductPic:(NSString *)productCharId type:(NSString *)type index:(NSInteger)index
{
    if ([productCharId isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    /*
     二手商品id 为 商品ID + RXX格式
     二手商品使用标准商品图片
     */
    NSRange aRange = [productCharId rangeOfString:@"R"];
    if (aRange.location != NSNotFound) {
        productCharId = [productCharId substringToIndex:aRange.location];
    }
    
    NSArray * pardIDs = [productCharId componentsSeparatedByString:@"-"];
 
	NSString *part1 = [NSString string];
	NSString *part2 = [NSString string];
    if ([pardIDs count]>2) {
        part1 = [pardIDs objectAtIndex:0];
        part2 = [pardIDs objectAtIndex:1];
    }
    
	NSString *indexStr;
	if (!index) {
		indexStr = @"";
	} else {
		indexStr = [NSString stringWithFormat: @"-%@%ld", (index < 10 ? @"0" : @""), (long)index];
	}

	return [NSString stringWithFormat: @"http://img2.icson.com/product/%@/%@/%@/%@%@.jpg", type, part1, part2, productCharId, indexStr];
}

NSInteger sortImageDictionaryWithIdx(id v1, id v2, void *context)
{
	NSDictionary *imgContext = (__bridge NSDictionary *)context;
	NSDictionary *imgInfo1 = [imgContext objectForKey: v1];
	NSDictionary *imgInfo2 = [imgContext objectForKey: v2];
	return [[imgInfo2 objectForKey: @"idx"] integerValue] - [[imgInfo1 objectForKey: @"idx"] integerValue];
}

+ (UIImage*)imageNamed:(NSString*)imageNamed cache:(BOOL)cache
{
	static NSLock *imgCacheLock;
    if (!imgCacheLock) {
        imgCacheLock = [[NSLock alloc] init];
    }

	if (!imageNamed) {
		return nil;
	}

	if (!cache) {
		return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageNamed]]];
	}

	if (staticImageDictionary == nil){
		staticImageDictionary = [NSMutableDictionary dictionary];
	}

	NSMutableDictionary* retImage = [staticImageDictionary objectForKey:imageNamed];
	if (retImage == nil)
	{
		retImage = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageNamed]]], @"image",
					[NSNumber numberWithInteger: 0], @"idx",
					nil];

		[imgCacheLock lock];
		NSArray *allKeys = [staticImageDictionary allKeys];
		allKeys = [allKeys sortedArrayUsingFunction: sortImageDictionaryWithIdx context: (__bridge void *)(staticImageDictionary)];
		if ([allKeys count] >= 20) {
			allKeys = [allKeys subarrayWithRange: NSMakeRange(20, [allKeys count] - 20)];
			
			for (NSString *key in allKeys) {
				[staticImageDictionary removeObjectForKey: key];
			}
		}
		[staticImageDictionary setObject: retImage forKey: imageNamed];
		[imgCacheLock unlock];
	}

	[retImage setObject: [NSNumber numberWithInteger: staticImageDictionaryIndex] forKey: @"idx"];
	staticImageDictionaryIndex ++;
	return [retImage objectForKey: @"image"];
}

+(void)showLoading:(UIView *)view
{
	UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	loading.frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
	loading.center = view.center;
	
	[view addSubview: loading];
	[loading startAnimating];
}

+ (NSString *) stripTags:(NSString *)str
{
	NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
	
	NSScanner *scanner = [NSScanner scannerWithString:str];
	[scanner setCharactersToBeSkipped:nil];
	NSString *tempText = nil;
	NSString *tagText = nil;
	BOOL skip = NO;

	while (![scanner isAtEnd]) {
		[scanner scanUpToString:@"<" intoString:&tempText];
		if (tempText != nil){
			if (!skip) {
				[html appendString:tempText];
			}
		}
		
		if (![scanner isAtEnd])
			[scanner setScanLocation:[scanner scanLocation] + 1];

		
		[scanner scanUpToString:@">" intoString:&tagText];
#define TAGTEXT_BEGIN_OF(str) ([tagText rangeOfString: (str)].location == 0)
		if (TAGTEXT_BEGIN_OF(@"script") || TAGTEXT_BEGIN_OF(@"style") || TAGTEXT_BEGIN_OF(@"img")) {
			skip = YES;
		} else {
			skip = NO;
			if (TAGTEXT_BEGIN_OF(@"br") || TAGTEXT_BEGIN_OF(@"/div") || TAGTEXT_BEGIN_OF(@"/p") || TAGTEXT_BEGIN_OF(@"/td")) {
				[html appendString: @"\n"];
			}
		}
#undef TAGTEXT_BEGIN_OF

		if (![scanner isAtEnd])
			[scanner setScanLocation:[scanner scanLocation] + 1];

		tagText = nil;
		tempText = nil;
	}
	
	return html;
}

+(NSArray *)makeArray:(id)dictionaryOrArray
{
	if (!dictionaryOrArray) {
		return dictionaryOrArray;
	}

	NSMutableArray *tmpList;
	if (![dictionaryOrArray respondsToSelector: @selector(objectForKey:)]) {
		tmpList = dictionaryOrArray;
	} else {
		tmpList = [NSMutableArray array];
		for (id key in dictionaryOrArray) {
			[tmpList addObject: [dictionaryOrArray objectForKey: key]];
		}
	}
	return tmpList;
}

+(void)changeViewWidth:(UIView *)view width:(CGFloat)width
{
	CGRect rect = view.frame;
	rect.size.width = width;
	[view setFrame: rect];
}

+(void)changeViewHeight:(UIView *)view height:(CGFloat)height
{
	CGRect rect = view.frame;
	rect.size.height = height;
	[view setFrame: rect];
}

+(GSITE_ID)getSiteId
{
	return GSITE_ID_SH;
}

+(NSString *)UTF82GBK:(NSString *)str
{
	NSURL *url=[ NSURL URLWithString: str ];
	NSData *data=[ NSData  dataWithContentsOfURL : url ];
	NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000 );

	return [[NSString alloc] initWithData:data encoding:enc];
}

/**
 格式化时间戳
 timeSeconds 为0时表示当前时间,可以传入你定义的时间戳
 timeFormatStr为空返回当当时间戳,不为空返回你写的时间格式(yyyy-MM-dd HH:ii:ss)
 setTimeZone ([NSTimeZone systemTimeZone]获得当前时区字符串)
 */

+(NSString *)formatDate:(NSTimeInterval)timeSeconds setTimeFormat:(NSString *)timeFormatStr setTimeZone:(NSString *)timeZoneStr
{
    NSString *dateString;
    NSDate *ordDate;

    if( timeSeconds>0){
        ordDate = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    } else {
        ordDate = [[NSDate alloc] init];
    }

    if( timeFormatStr==nil){
        dateString =[NSString stringWithFormat:@"%u",(unsigned int)[ordDate timeIntervalSince1970]];
    }else{
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:timeFormatStr];

        if( timeZoneStr != nil){
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZoneStr]];
        }

        dateString =[dateFormatter stringFromDate: ordDate];
    }

    return dateString;
}

+ (CGFloat)getHeightFittedForStr:(NSString *)str fontSize:(CGFloat)_fontSize viewWidth:(CGFloat)_viewWidth
{
    if (!str) {
        return 0.0;
    }

    CGSize size = [str sizeWithFont: [UIFont systemFontOfSize: _fontSize] constrainedToSize: CGSizeMake(_viewWidth, 99999.0) lineBreakMode: NSLineBreakByWordWrapping];
    return size.height;
}

+ (UIImage *)createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(NSDictionary *)convertCategoryArrayToDictionary:(NSArray *)category
{
    if ([category isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if ([category count] == 0) {
        return nil;
    }
    NSMutableDictionary *searchCondition = [NSMutableDictionary dictionary];
    if ([category count] > 7 ) {
        [searchCondition setObject: [category objectAtIndex: 0] forKey: @"cid"];
        [searchCondition setObject: [category objectAtIndex: 2] forKey: @"sort"];
        [searchCondition setObject: [category objectAtIndex: 4] forKey: @"pp"];
        [searchCondition setObject: [category objectAtIndex: 6] forKey: @"p"];
        [searchCondition setObject: [category objectAtIndex: 7] forKey: @"option"];
    }
    if ([category count] > 8) {
        [searchCondition setObject: [category objectAtIndex: 8] forKey: @"q"];
    }
    return searchCondition;
}

+ (NSDictionary *)convertNewCateConditionToDictionary:(NSArray *)newCateCondition
{
    static NSString * const keyArr[] = {@"path", @"option", @"areacode", @"q", @"classid", @"sort", @"p", @"pp", @"price"};
    NSMutableDictionary *conditionDic = [NSMutableDictionary dictionary];
    for (int i=0; i<MIN(9, [newCateCondition count]); i++)
    {
        [conditionDic setObject:[newCateCondition objectAtIndex:i] forKey:keyArr[i]];
    }
    
    return conditionDic;
}

+(BOOL)isEmpty:(id)obj
{
	return !obj || [obj isEqual: @""] || [obj isEqual: [NSNumber numberWithInteger: 0]];
}

+(NetworkStatus)checkNetworkStatus
{
	return [[Reachability sharedReachability] currentReachabilityStatus];
}

+(void)setKeyboardFrameChangeListener:(id)listener
{
	//[[NewTabBarViewController shareTabBarController] setKeyboardDelegate: listener];
}

+(void)unsetKeyboardFrameChangeListener:(id)listener
{
//	if ([NewTabBarViewController shareTabBarController].keyboardDelegate == listener) {
//		[[NewTabBarViewController shareTabBarController] setKeyboardDelegate: nil];
//	}
}

+ (void) showQQLoginView:(void(^)(NSInteger))_afterLoginSuccess target:(id)target
{
//    QQloginViewController *login = [[QQloginViewController alloc] initWithNibName:@"QQloginViewController" bundle:nil];
//    /* Track  PV data */
//    //TODO REMOVE PVCHANGE
////    [UserTracker trackPVPageChange:GPageCommonActionLogin from:target to:login];
//    [login setBlock:^(NSInteger uid, NSError* err) {
//        if (uid > 0 && _afterLoginSuccess) {
//            _afterLoginSuccess(uid);
//            //Reset user id for RQD
////            [GAnalytics setUserIDWithIntValue:[UserWrapper shareMasterUser].uid];
//        }
//    }];
//    
//    GNavController * navController = [[GNavController alloc] initWithRootViewController:login];
//    [target presentModalViewController:navController  animated:YES];
}

+ (void) checkLogin:(void (^)(NSString *))_afterLoginSuccess target:(id)target
{
    if ([[KTCUser currentUser] hasLogin]) {
        _afterLoginSuccess([[KTCUser currentUser] uid]);
        return;
    }
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    [login setBlock:^(NSString *uid, NSError* err) {
        if ([uid length] > 0 && _afterLoginSuccess) {
            _afterLoginSuccess(uid);
        }
    }];
    
    GNavController * navController = [[GNavController alloc] initWithRootViewController:login];
    [target presentViewController:navController animated:YES completion:nil];
}

+(NSString *)trim:(NSString *)str
{
    return !str ? str : [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger days = (ti / 86400);
    NSInteger hours = (ti / 3600 ) % 24;

	if (days > 0) {
		return [NSString stringWithFormat:@"%li天%02li小时%02li分%02li秒", (long)days, (long)hours, (long)minutes, (long)seconds];
	}

	if (hours > 0) {
		return [NSString stringWithFormat:@"%02li小时%02li分%02li秒", (long)hours, (long)minutes, (long)seconds];
	}

	if (minutes > 0) {
		return [NSString stringWithFormat:@"%02li分%02li秒", (long)minutes, (long)seconds];
	}
	
	return [NSString stringWithFormat:@"%02li秒", (long)seconds];
}

+(NSString *)getDeviceInfo
{
	return [NSString stringWithFormat: @"%@ %@ %@ %@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] model], [[UIDevice currentDevice] localizedModel], [[[CTTelephonyNetworkInfo sharedTelephonyNetworkInfo] subscriberCellularProvider] carrierName]];
}

+ (int)compareVersion:(NSString *)firstVersion version:(NSString *)secondVersion
{
    int result = 0;
    NSArray *firstVersionItems = [firstVersion componentsSeparatedByString:@"."];
    NSArray *secondVersionItems = [secondVersion componentsSeparatedByString:@"."];
    for (int i = 0; i<[firstVersionItems count] || i< [secondVersionItems count]; i++)
    {
        int firstItem = 0;
        int secondItem = 0;
        if (i<[firstVersionItems count])
        {
            firstItem = [[firstVersionItems objectAtIndex:i] intValue];
        }
        if (i<[secondVersionItems count])
        {
            secondItem = [[secondVersionItems objectAtIndex:i] intValue];
        }
        
        if (firstItem != secondItem)
        {
            result = (firstItem<secondItem)?-1:1;
            break;
        }
    }
    
    return result;
}

+ (NSString *)checkErrMessage:(NSError *)error
{
	if (error && [error userInfo] && [[error userInfo] objectForKey: @"returnData"]) {
        
        NSString * msgStr = nil;
        if ([[[error userInfo] objectForKey: @"returnData"] isKindOfClass:[NSString class]])
        {
            msgStr = [[error userInfo] objectForKey: @"returnData"];
        }
        else if([[[error userInfo] objectForKey: @"returnData"] isKindOfClass:[NSDictionary class]])
        {
            msgStr = [[[error userInfo] objectForKey: @"returnData"] objectForKey:kErrMsgKey];
        }
		return msgStr;
	}
    
	return nil;
}

// count word
+ (int) gCountWord:(NSString*) s
{
    NSInteger i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    
    if(a==0 && l==0) return 0;
    
    return (int)(l+(int)ceilf((float)(a+b)/2.0));
}

+ (NSString*)svnVersion
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"svninfo" ofType:@"txt"];
    if (path){
        return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    }
    return nil;
}

+ (BOOL)isNetworkWifiStatus
{
	NetworkStatus status = [GToolUtil checkNetworkStatus];
	if (status == ReachableViaWiFi)
	{
		return YES;
	}
	return NO;
}

+ (CGAffineTransform) transformForCurrentOrientation
{
    // Get orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // Choose the transform
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation((float)(M_PI*1.5));
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation((float)(M_PI/2));
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation((float)(-M_PI));
    } else {
        return CGAffineTransformIdentity;
    }
}

+ (BOOL)isFirstUsedRoll
{
    BOOL isFirst = ![[NSUserDefaults standardUserDefaults] boolForKey:kIsRollUsed];
    if (isFirst)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsRollUsed];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return isFirst;
}

+ (NSString *)covertPriceToString:(int)price
{
    NSString *returnStr = @"0";
    if (price%100 == 0) {
        returnStr = [NSString stringWithFormat:@"%d",price/100];
    }
    else if(price%10 == 0)
    {
        returnStr = [NSString stringWithFormat:@"%.1f",price/100.0f];
    }
    else
    {
        returnStr = [NSString stringWithFormat:@"%.2f",price/100.0f];
    }
    return returnStr;
}

+ (void)showPrice:(int)price inLabel:(UILabel *)label
{
    if (price == kNotSoldPrice) {
        label.text = kNotSoldString;
    }
    else
    {
        label.text = [NSString stringWithFormat:@"¥%@",[GToolUtil covertPriceToString:price]];
    }
}


+ (BOOL)showErrorMsg:(NSData *)returnData
{
    if (returnData != nil) {
        NSDictionary *dic = [returnData toJSONObjectFO];
        if (dic != nil) {
            NSString *msg = [dic objectForKey:@"msg"];
            if (msg != nil) {
                UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"出错了"
                                                                   message:msg
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                [alertMsg show];
                return YES;
            }
        }
    }
    return NO;
}


+ (BOOL)filterBlackList:(NSString*)urlToFilter
{
    // 接口下发每个接口已经没有enable字段，因此去除这个逻辑
    return YES;
    
	//LOG_METHOD
	//如果是图片的url，则直接返回yes
	if([urlToFilter hasSuffix:@".jpg"] || [urlToFilter hasSuffix:@".png"] || [urlToFilter hasSuffix:@".jpeg"])
	{
		return YES;
	}
	NSDictionary*dic = [GInterface sharedGInterface].interfaceList;
	if(dic)
	{
		id result = [dic objectForKey:@"enable"];
		
		BOOL enabled = (nil != result &&  [NSNull null] != result && NULL != result)? [result boolValue] : YES;
		if (!enabled)  //全部接口禁用
		{
			NSString *msg = [dic objectForKey:@"message"];
			if([msg length] != 0)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
				[alert show];
			}
			return NO;
		}
	    NSString *aliasName = [self getKeyByUrl:urlToFilter];
		if(aliasName == nil || [aliasName length] == 0)
			return YES;
		//NSLog(@"%@,%@",urlToFilter,aliasName);
		NSDictionary *d = [dic objectForKey:aliasName];
		result = [d objectForKey:@"enable"];
		enabled = (nil != result &&  [NSNull null] != result && NULL != result) ? [result boolValue] : YES;
		if(!enabled)
		{
			NSString *msg = [dic objectForKey:@"message"];
			if([msg length] != 0)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
				[alert show];
			}
			return NO;
		}
	}
	return YES;
}

+ (NSString*)getKeyByUrl:(NSString*)urlToFilter
{
	NSDictionary*dic = [[GConfig sharedConfig] getAllConfigURL];
	NSString *eventName = nil;
	for(NSString *key in dic)
	{
		NSDictionary *value = [dic objectForKey:key];
		if([urlToFilter isEqualToString:[value objectForKey:@"url"]])
		{
			eventName = key;
			break;
		}
	}
	if(eventName == nil || [eventName length] ==0)
	{
		NSInteger maxLen = 0;
		for(NSString *key in dic)
		{
			NSDictionary *value = [dic objectForKey:key];
			NSString *longStr = nil;
			NSString *shortStr = nil;
			if([[value objectForKey:@"url"] length] < [urlToFilter length])
			{
				longStr = urlToFilter;
				shortStr = [value objectForKey:@"url"];
			}
			else
			{
				longStr = [value objectForKey:@"url"];
				shortStr = urlToFilter;
			}
			if([longStr rangeOfString:shortStr].location != NSNotFound)
			{
				NSInteger len = [longStr rangeOfString:shortStr].length;
				if(len >maxLen)
				{
					eventName = key;
					maxLen = len;
				}
			}
		}
	}
    if(eventName == nil || [eventName length] == 0)
		return nil;
	return eventName;
}

+ (void)configureLabel:(UILabel*)label withFont:(CGFloat)fontSize withTextColor:(UIColor*)color
{
	label.font = [UIFont systemFontOfSize:fontSize];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = color;
	[label sizeToFit];
}

+ (void)configureButton:(UIButton*)button withFont:(CGFloat)fontSize withTextColor:(UIColor*)textColor withTitle:(NSString*)title withNorImage:(NSString*)norImageName withHighImage:(NSString*)highImageName
{
	button.backgroundColor = [UIColor clearColor];
	UIImage *normalImage = nil;
	if (norImageName)
	{
		normalImage = LOADIMAGE(norImageName, @"png");
		normalImage = [normalImage stretchableImageWithLeftCapWidth:normalImage.size.width/2.0f topCapHeight:normalImage.size.height/2.0f];
	}
	[button setBackgroundImage:normalImage forState:UIControlStateNormal];
	UIImage *highImage = nil;
	if (highImageName)
	{
		 highImage = LOADIMAGE(highImageName, @"png");
		highImage = [highImage stretchableImageWithLeftCapWidth:highImage.size.width/2.0f topCapHeight:highImage.size.height/2.0f];
	}
	[button setBackgroundImage:highImage forState:UIControlStateHighlighted];
	[button setBackgroundImage:highImage forState:UIControlStateSelected];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateSelected];
	[button setTitleColor:textColor forState:UIControlStateNormal];
	[button setTitleColor:textColor forState:UIControlStateHighlighted];
	[button setTitleColor:textColor forState:UIControlStateSelected];
	button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

+ (NSString*)changeUrl:(NSString*)url  withIndex:(NSInteger)index
{
	return [GToolUtil changeUrl:url withIndex:index andResolution:R_800];
}

+ (NSString*)changeUrl:(NSString*)url  andResolution:(RESOLUTION_WANG_GOU)res
{
	return [GToolUtil changeUrl:url withIndex:-1 andResolution:res];
}

+ (NSString*)changeUrl:(NSString*)url  withIndex:(NSInteger)index andResolution:(RESOLUTION_WANG_GOU)res
{
	if(index >= 0)
	{
		//jpg|gif|png|bmp
		NSArray *seperatedArr = nil;
		NSArray*array = @[@"jpg", @"png",@"bmp",@"gif",@"jpeg"];
		NSString*sepExt = nil;
		for (NSString* ext in array){
			if([url rangeOfString:ext].location != NSNotFound)
			{
				seperatedArr = [url componentsSeparatedByString:ext];
				sepExt = ext;
				break;
			}
		}
		if(seperatedArr.count < 2)
			return url;
		NSString*leftUrl = seperatedArr[0];
		NSString*rightUrl = seperatedArr[1];
		
		NSArray*seperatedArrByDot = [leftUrl componentsSeparatedByString:@"."];
		NSMutableArray*arrayTemp = [NSMutableArray arrayWithArray:seperatedArrByDot];
		NSString*replaceTo = INT2STRING((int)index);
		if(arrayTemp.count <2)return url;
		
		arrayTemp[arrayTemp.count -2] = replaceTo;
		NSString*newLeftUrl = [arrayTemp componentsJoinedByString:@"."];
		url = [NSString stringWithFormat:@"%@%@%@",newLeftUrl,sepExt, rightUrl];
	}
	
	NSRange ran ;
	ran.location = NSNotFound;
	NSArray*arr = @[@"/800?",@"/600?",@"/400?",@"/300?",@"/200?",@"/160?",@"/120?",@"/80?",@"/60?",@"/30?",@"?0"];
    for (int i=0; i<arr.count; i++)
	{
		NSString*f = arr[i];
		ran = [url rangeOfString:f];
		if(ran.location != NSNotFound)
		{
			break;
		}
	}
	if(NSNotFound == ran.location)
		return url;
	
	NSString*replaceTo = nil;
	switch (res) {
		case R_30:
		{
			replaceTo = @"/30?";
		}
			break;
		case R_60:
		{
			replaceTo = @"/60?";
		}
			break;
		case R_80:
		{
			replaceTo = @"/80?";
		}
			break;
		case R_120:
		{
			replaceTo = @"/120?";
		}
			break;
		case R_160:
		{
			replaceTo = @"/160?";
		}
			break;
		case R_200:
		{
			replaceTo = @"/200?";
		}
			break;
		case R_300:
		{
			replaceTo = @"/300?";
		}
			break;
		case R_400:
		{
			replaceTo = @"/400?";
		}
			break;
		case R_600:
		{
			replaceTo = @"/600?";
		}
			break;
		case R_800:
		{
			replaceTo = @"/0?";
		}
			break;
		default:
			break;
	}
	url =[url stringByReplacingCharactersInRange:ran withString:replaceTo];
	NSLog(@"url:%@",url);
	return  url;
}

+ (NSDictionary*) parsetUrl:(NSString*)urlString
{
    if ([urlString length] == 0) {
        return nil;
    }
	NSString *questionSymbol = @"?";
	NSInteger index = [urlString rangeOfString:questionSymbol].location;
	if([urlString length] > index+1)
	{
		urlString = [urlString substringFromIndex:index+1];
    }
	NSString *connectSymbol = @"&";
	NSArray *arrayOfKeyValue = [urlString componentsSeparatedByString:connectSymbol];
	NSString *key = nil;
	NSString *value = nil;
	NSString *equalSymbol = @"=";
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	for(NSString *str in arrayOfKeyValue)
	{
		NSArray *array = [str componentsSeparatedByString:equalSymbol];
		if([array count] == 2)
		{
			key = [array objectAtIndex:0];
			value = [array objectAtIndex:1];
		}else if([array count] == 1)
		{
			key = [array objectAtIndex:0];
			value = @" ";
		}
        else if([array count]>2)
        {
            key = [array objectAtIndex:0];
            
            NSInteger equalSymbolIndex = [str rangeOfString:equalSymbol].location;
            if([str length] > equalSymbolIndex+1)
            {
                value = [str substringFromIndex:equalSymbolIndex+1];
            }
            else
            {
                value = @" ";
            }
        }
		else
		{
			key = @" ";
			value = @" ";
		}
		[dic setObject:value forKey:key];
	}
    if ([dic count] == 0) {
        return nil;
    }
	return [NSDictionary dictionaryWithDictionary:dic];
}


+ (NSString *)timeStringFromTimeStamp:(NSUInteger)timeStamp withDateFormatterString:(NSString *)formatString {
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    
    NSString *returnString =[dateFormatter stringFromDate:time];
    return returnString;
}


+ (NSString *)countDownTimeStringWithLeftTime:(NSTimeInterval)leftTime {
    NSUInteger intTime = leftTime;
    
    NSUInteger day = intTime / 3600 / 24;
    NSUInteger hour = (intTime % (24 * 3600)) / 3600;
    NSUInteger minute = (intTime % 3600) / 60;
    NSUInteger second = (intTime % 3600) % 60;
    NSString *timeString = @"";
    if (day < 1) {
        timeString = [NSString stringWithFormat:@"%02lu时%02lu分%02lu秒", (unsigned long)hour, (unsigned long)minute, (unsigned long)second];
    } else {
        timeString = [NSString stringWithFormat:@"%lu天%02lu时%02lu分%02lu秒", (unsigned long)day, (unsigned long)hour, (unsigned long)minute, (unsigned long)second];
    }
    return timeString;
}


+ (TimeStructHMS)countDownTimeStructHMSWithLeftTime2:(NSTimeInterval)leftTime {
    NSUInteger intTime = leftTime;
    TimeStructHMS t1;
    t1.hour = intTime / 3600;
    t1.min = (intTime % 3600) / 60;
    t1.sec = (intTime % 3600) % 60;
    return t1;
}


+ (BOOL)copyFileFormBundlePath:(NSString *)bundlePath toFilePath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath isDirectory:NULL]) {
        return YES;
    }
    if (![manager fileExistsAtPath:bundlePath isDirectory:NULL]) {
        return NO;
    }
    BOOL checkCopyValidData = YES;//判断是否拷贝成功
    NSError *error=nil;
    [[NSFileManager defaultManager]copyItemAtPath:bundlePath toPath:filePath error:&error ];
    if (error!=nil) {
        NSLog(@"%@", error);
        NSLog(@"%@", [error userInfo]);
        checkCopyValidData = NO;
    }
    return checkCopyValidData;
}


+ (CLLocationCoordinate2D)coordinateFromString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return CLLocationCoordinate2DMake(0, 0);
    }
    if ([string length] == 0) {
        return CLLocationCoordinate2DMake(0, 0);
    }
    NSArray *components = [string componentsSeparatedByString:@","];
    if ([components count] != 2) {
        return CLLocationCoordinate2DMake(0, 0);
    }
    
    NSString *lonString = [components firstObject];
    [lonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CLLocationDegrees lon = [lonString doubleValue];
    
    NSString *latString = [components lastObject];
    [latString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CLLocationDegrees lat = [latString doubleValue];
    
    return CLLocationCoordinate2DMake(lat, lon);
}

+ (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate {
    return [NSString stringWithFormat:@"%f,%f", coordinate.longitude, coordinate.latitude];
}

+ (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}


+ (NSString *)jsonFromObject:(id)obj {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (UIImage *)takeSnapshotForView:(UIView *)view {
//    CGSize imageSize = view.frame.size;
//    
//    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    //    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//    //        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    //    } else {
//    //        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1);
//    //    }
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSaveGState(context);
//    CGContextTranslateCTM(context, view.center.x, view.center.y);
//    CGContextConcatCTM(context, view.transform);
//    CGContextTranslateCTM(context, -view.bounds.size.width * view.layer.anchorPoint.x, -view.bounds.size.height * view.layer.anchorPoint.y);
//    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
//        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    } else {
//        [view.layer renderInContext:context];
//    }
//    CGContextRestoreGState(context);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSUInteger)byteCountOfImage:(UIImage *)image {
    if (!image) {
        return 0;
    }
    //累计内存占用
    CGImageRef inImage = image.CGImage;
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    NSUInteger bitmapBytesPerRow    = (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    NSUInteger bitmapByteCount    = (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    return bitmapByteCount;
}

+ (void)drawLineOnView:(UIView *)view
        withStartPoint:(CGPoint)start
              endPoint:(CGPoint)end
             lineWidth:(CGFloat)width
                   gap:(CGFloat)gap
         sectionLength:(CGFloat)length
                 color:(UIColor *)color
             isVirtual:(BOOL)isVirtual {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色
    [shapeLayer setStrokeColor:color.CGColor];
    // 设置虚线的宽度
    [shapeLayer setLineWidth:width];
    [shapeLayer setLineJoin:kCALineJoinRound];
    if (isVirtual) {
        // 线段的长度和每条线的间距
        [shapeLayer setLineDashPattern: [NSArray arrayWithObjects:[NSNumber numberWithFloat:length], [NSNumber numberWithFloat:gap], nil]];
    }
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, end.x, end.y);
    
    [shapeLayer setPath:path]; 
    CGPathRelease(path);
    
    [view.layer addSublayer:shapeLayer];
}

+ (NSString *)distanceDescriptionWithMeters:(NSUInteger)meters {
    NSString *des = @"";
    if (meters < 1000) {
        des = [NSString stringWithFormat:@"%lu米", (unsigned long)meters];
    } else {
        CGFloat km = meters / 1000.0;
        des = [NSString stringWithFormat:@"%.2f千米", km];
    }
    return des;
}

+ (NSString *)timeDescriptionWithSeconds:(NSUInteger)seconds {
    NSUInteger hour = seconds / 3600;
    NSUInteger minute = (seconds % 3600) / 60;
    NSUInteger second = (seconds % 3600) % 60;
    NSMutableString *timeString = [NSMutableString stringWithString:@""];
    if (hour > 1) {
        [timeString appendFormat:@"%lu小时", (unsigned long)hour];
    }
    [timeString appendFormat:@"%lu分%lu秒", (unsigned long)minute, (unsigned long)second];
    return [NSString stringWithString:timeString];
}


+ (NSString *)hashString:(NSString *)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end