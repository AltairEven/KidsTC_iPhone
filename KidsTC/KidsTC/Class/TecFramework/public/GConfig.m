//
//  GConfig.m
//  iphone51buy
//
//  Created by icson apple on 12-6-28.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GConfig.h"
#import "InterfaceManager.h"
#import "UIDevice+IdentifierAddition.h"
//#import "GArea.h"

#define DefaultLongitude (121.43333)
#define DefailtLatitude (34.50000)

static GConfig *_sharedConfig;


//是否加载网络图片
static BOOL bLoadWebImage = YES;

@interface GConfig ()

@property (nonatomic, strong) NSMutableDictionary * URLMapWithAlias;
@property (nonatomic, strong) NSDictionary * interFaceList;
@property (nonatomic, strong) NSMutableArray *      histList;

@end

@implementation GConfig
@synthesize URLMapWithAlias = _URLMapWithAlias;
@synthesize envInfo = _envInfo;
@synthesize lock = _lock;

+ (GConfig *)sharedConfig
{
	@synchronized([self class])
    {
		if (!_sharedConfig)
        {
			_sharedConfig = [[[self class] alloc] init];
		}
		return _sharedConfig;
	}
	return nil;
}

- (void)compareVersionAndLoad
{
	self.interFaceList  = [[InterfaceManager sharedManager] interfaceData];
	if(self.interFaceList == nil)
	{
		NSDictionary *URLMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"interface_list" ofType:@"plist"]];
		self.URLMapWithAlias = [NSMutableDictionary dictionaryWithDictionary:[URLMap objectForKey:@"data"]];
	}
	else
	{
		self.URLMapWithAlias = [NSMutableDictionary dictionaryWithDictionary:[self.interFaceList objectForKey:@"data"]];
	}
}

- (id)init
{
    if (self = [super init])
    {
		_lock = [[NSLock alloc] init];
		[self compareVersionAndLoad];
        // init env info
        self.envInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kAppEnvInfoKey];
	}
    
	return self;
}

- (KTCLocation *)currentLocation {
    if (!_currentLocation) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:DefailtLatitude longitude:DefaultLongitude];
        _currentLocation = [[KTCLocation alloc] initWithLocation:location locationDescription:@"正在定位"];
    }
    return _currentLocation;
}

- (NSString *)currentLocationCoordinateString {
    return [GToolUtil stringFromCoordinate:self.currentLocation.location.coordinate];
}

- (void)startSMSCodeCountDownWithLeftTime:(void (^)(NSTimeInterval))left completion:(void (^)())completion {
    if (self.smsCodeCountDown.leftTime > 0) {
        return;
    }
    if (!self.smsCodeCountDown) {
        self.smsCodeCountDown = [[ATCountDown alloc] initWithLeftTimeInterval:60];
    }
    __weak GConfig *weakSelf = self;
    [weakSelf.smsCodeCountDown startCountDownWithCurrentTimeLeft:^(NSTimeInterval currentTimeLeft) {
        if (left) {
            left(currentTimeLeft);
        }
    } completion:^{
        if (completion) {
            completion();
        }
        weakSelf.smsCodeCountDown = nil;
    }];
    
}

- (void)load
{
	[self.lock lock];
//	[self compareVersionAndLoad];
	[self.lock unlock];
}

- (NSString *)envInfo
{
    if (_envInfo.length > 0) {
        return _envInfo;
    }
#ifdef RELEASE
    return @"release";
#else
    return @"debug";
#endif
}

- (void)setEnvInfo:(NSString *)envInfo
{
    _envInfo = envInfo;
    
    [[NSUserDefaults standardUserDefaults] setObject:_envInfo forKey:kAppEnvInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)refresh:(NSDictionary*)dic
{
	[self.lock lock];
	if(dic) //
	{
		self.interFaceList = dic;
		self.URLMapWithAlias = [NSMutableDictionary dictionary];
		self.URLMapWithAlias = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];
	}
	else
	{
		NSDictionary *URLMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"interface_list" ofType:@"plist"]];
		self.URLMapWithAlias = [NSMutableDictionary dictionaryWithDictionary:[URLMap objectForKey:@"data"]];
	}
	[self.lock unlock];
}

- (NSDictionary*)getAllConfigURL
{
	return self.URLMapWithAlias;
}

- (NSString *)getURLStringWithAliasName:(NSString *)aliasName
{
    return [[self.URLMapWithAlias objectForKey:aliasName] objectForKey:@"url"];
}

- (HttpRequestMethod)getURLSendDataMethodWithAliasName:(NSString *)aliasName
{
    NSString * httpMethod = [[self.URLMapWithAlias objectForKey:aliasName] objectForKey:@"method"];
    if ([[httpMethod lowercaseString] isEqualToString:@"post"]) {
        return HttpRequestMethodPOST ;
    }
    return HttpRequestMethodGET;
}



+ (NSString *)getInvoiceTypeName:(INVOICE_TYPE)invoiceType
{
	if (invoiceType == INVOICE_TYPE_RETAIL_PERSONAL) {
		return @"个人商业零售发票";
	} else if(invoiceType == INVOICE_TYPE_RETAIL_COMPANY){
		return @"单位商业零售发票";
	} else if(invoiceType == INVOICE_TYPE_VAT){
		return @"增值税专用发票";
	} else if(invoiceType == INVOICE_TYPE_GUANGDONG_NORMAL){
		return @"普通发票";
    }
	
	return nil;
}

- (NSString *)getInvoiceDesc:(NSDictionary *)_invoice
{
	if (!_invoice) {
		return nil;
	}
	
	INVOICE_TYPE invoiceType = (INVOICE_TYPE)[[_invoice objectForKey: @"type"] integerValue];
	NSString *invoiceTypeDesc = [[self class] getInvoiceTypeName: invoiceType];
	
	return [NSString stringWithFormat: @"%@ (抬头：%@)", invoiceTypeDesc, [_invoice objectForKey: @"title"]];
}

- (INVOICE_TYPE)invoiceTypeStrToTypeID:(NSString *)typeStr
{
    int typeID = 0;
    if ([typeStr isEqualToString:kPersonalInvoiceTypeName])
        typeID = INVOICE_TYPE_RETAIL_PERSONAL;
    else if ([typeStr isEqualToString:kCompanyInvoiceTypeName])
        typeID = INVOICE_TYPE_RETAIL_COMPANY;
    else if ([typeStr isEqualToString:kGuangdongNormalTypeName])
        typeID = INVOICE_TYPE_GUANGDONG_NORMAL;
    
    return typeID;
}

+ (NSString *)getCurrentAppVersionCode
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (BOOL)isInUpdateImmunePeriod:(NSDate *) timeNow
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDate *updateImmunePeriodStartDate = [prefs objectForKey:kUpdateImmunePeriodKey];
    if (updateImmunePeriodStartDate == nil)
    {
        return NO;
    }
    
    return [timeNow timeIntervalSinceDate:updateImmunePeriodStartDate] < kUpdateImmuneTimeThreshold;
}

+ (void)restartUpdateImmunePeriod
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kUpdateImmunePeriodKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getForceUpdateInfo
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kForceUpdateInfoKey];
}

+ (void)setForceUpdateInfo:(NSDictionary *)versionInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:versionInfo forKey:kForceUpdateInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getLastOrderInfo
{
    NSDictionary * info = [[NSUserDefaults standardUserDefaults] objectForKey:kLastOrderInfoKey];
    if (info) {
        NSInteger oldUid = [[info objectForKey:@"uid"] integerValue];
        if (oldUid == [UserWrapper shareMasterUser].uid) {
            return info;
        }
    }
    
    return nil;
}

+ (void)setLastOrderInfo:(NSDictionary *)orderInfo
{
    if (orderInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:orderInfo forKey:kLastOrderInfoKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLastOrderInfoKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//+ (NSInteger)getZoneIDWithDistrictID:(NSInteger)districtID
//{
//    GAreaDistrict *areaDistrict = [[[GArea sharedGArea] getDistrictList] objectForKey:[NSNumber numberWithInt:districtID]];
//    NSString *provinceName = [[[areaDistrict city] province] provinceName];
//    if (provinceName == nil) {
//        return -1;
//    }
//    for (int zoneIndex = 0; zoneIndex<[[[UserWrapper shareMasterUser]getProvinces] count]; zoneIndex++)
//    {
//        NSString *provinceInShort = [[[UserWrapper shareMasterUser] getProvinces] objectAtIndex:zoneIndex];
//        if ([provinceName hasPrefix:provinceInShort] || [provinceInShort hasPrefix:provinceName])
//        {
//            return zoneIndex;
//        }
//    }
//    
//    return -1;
//}

//+ (void)setAreaByDistrictID:(NSInteger)districtIDToBeFind
//{
//	NSDictionary*areaData = [[GArea sharedGArea] getAreaData];
//	for (id pid in [areaData allKeys])
//	{
//		GAreaProvince*p = [areaData objectForKey:pid];
//		for (id cid in [p.cityList allKeys])
//		{
//			GAreaCity *c = [p.cityList objectForKey:cid];
//			for (id did in [c.districtList allKeys])
//			{
//				GAreaDistrict *d = [c.districtList objectForKey:did];
//				if(d.districtId == districtIDToBeFind)
//				{
//					[UserWrapper shareMasterUser].selectedProvince = p;
//					[UserWrapper shareMasterUser].selectedCity = c;
//					[UserWrapper shareMasterUser].selectedDistrict = d;
//					[[UserWrapper shareMasterUser] areaChangedToSaveDispatch];
//				}
//			}
//		}
//	}
//}

//+(void)setDistrictItemWithDistrictID:(NSInteger)districtID
//{
//	GAreaDistrict *areaDistrict = [[[GArea sharedGArea] getDistrictList] objectForKey:[NSNumber numberWithInt:districtID]];
//	if(areaDistrict)
//	{
//		GAreaCity*city = areaDistrict.city;
//		GAreaProvince*province = city.province;
//		if(areaDistrict && province && city)
//		{
//			[UserWrapper shareMasterUser].selectedProvince = province;
//			[UserWrapper shareMasterUser].selectedCity = city;
//			[UserWrapper shareMasterUser].selectedDistrict = areaDistrict;
//			[[UserWrapper shareMasterUser] areaChangedToSaveDispatch];
//		}
//		else
//		{
//			[GConfig setAreaByDistrictID:districtID];
//		}
//	}
//	else
//	{
//		[GConfig setAreaByDistrictID:districtID];
//	}
//}

//+ (NSInteger)getProvinceIDWithDistrictID:(NSInteger)districtID
//{
//    GAreaDistrict *areaDistrict = [[[GArea sharedGArea] getDistrictList] objectForKey:[NSNumber numberWithInt:districtID]];
//    NSString *provinceName = [[[areaDistrict city] province] provinceName];
//    for (id provinceID in [[UserWrapper shareMasterUser]getDeliveryDic])
//    {
//        NSDictionary *siteDic = [[[UserWrapper shareMasterUser] getDeliveryDic] objectForKey:provinceID];
//        if ([provinceName hasPrefix:[siteDic objectForKey:@"zone"]] || [[siteDic objectForKey:@"zone"] hasPrefix:provinceName])
//        {
//            return [provinceID integerValue];
//        }
//    }
//    
//    return -1;
//}
//

+ (NSString*)searchHistFilePath
{
    NSArray *arrPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [arrPath objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@",documentsDirectory, SEARCH_HISTORY_SAVE_NAME];
}

+ (NSArray*)getSearchHistory
{
    if (nil == [GConfig sharedConfig].histList) {
        [GConfig sharedConfig].histList = [NSMutableArray arrayWithContentsOfFile:[GConfig searchHistFilePath]];
    }
    return [GConfig sharedConfig].histList;
}

+ (void)addSearchHistory:(NSString*)str
{
    if (str) {
        if (nil == [GConfig sharedConfig].histList) {
            [GConfig sharedConfig].histList = [NSMutableArray array];
        } else {
            [[GConfig sharedConfig].histList removeObject:str];
            while ([GConfig sharedConfig].histList.count >= SEARCH_HISTORY_COUNT) {
                [[GConfig sharedConfig].histList removeLastObject];
            }
        }
        
        [[GConfig sharedConfig].histList insertObject:str atIndex:0];
        [[GConfig sharedConfig].histList writeToFile:[GConfig searchHistFilePath] atomically:YES];
    }
}

+ (void)clearAllSearchHistory
{
    [[NSFileManager defaultManager] removeItemAtPath:[GConfig searchHistFilePath] error:nil];
    [GConfig sharedConfig].histList = nil;
}

- (BOOL)getIsAutoResume
{
    return [[self.interFaceList objectForKey:@"autoResume"] boolValue];
}

+ (NSString *)getNowDateTS
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    return [NSString stringWithFormat:@"%f",[localeDate timeIntervalSince1970] ] ;
}


- (BOOL)loadWebImage {
    return bLoadWebImage;
}


- (void)setLoadWebImage:(BOOL)bLoad {
    bLoadWebImage = bLoad;
}

+ (id)getObjectFromNibWithView:(UIView *)view {
    UIView *nibView = [GConfig getObjectFromNibWithClass:[view class]];
    [GConfig replaceAutolayoutConstrainsFromView:view toView:nibView];
    return nibView;
}


+ (id)getObjectFromNibWithClass:(Class)aClass {
    
    NSString *className = NSStringFromClass(aClass);
    
    NSArray *topObjArray = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    
    for (id anObj in topObjArray) {
        if ([anObj isKindOfClass:aClass]) {
            return anObj;
        }
    }
    
    return nil;
}


+ (void)replaceAutolayoutConstrainsFromView:(UIView *)placeholderView toView:(UIView *)realView {
    realView.autoresizingMask = placeholderView.autoresizingMask;
    realView.translatesAutoresizingMaskIntoConstraints = placeholderView.translatesAutoresizingMaskIntoConstraints;
    
    // Copy autolayout constrains from placeholder view to real view
    if (placeholderView.constraints.count > 0) {
        
        // We only need to copy "self" constraints (like width/height constraints)
        // from placeholder to real view
        for (NSLayoutConstraint *constraint in placeholderView.constraints) {
            
            NSLayoutConstraint* newConstraint;
            
            // "Height" or "Width" constraint
            // "self" as its first item, no second item
            if (!constraint.secondItem) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:nil
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            // "Aspect ratio" constraint
            // "self" as its first AND second item
            else if ([constraint.firstItem isEqual:constraint.secondItem]) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:realView
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            
            // Copy properties to new constraint
            if (newConstraint) {
                newConstraint.shouldBeArchived = constraint.shouldBeArchived;
                newConstraint.priority = constraint.priority;
                if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
                    newConstraint.identifier = constraint.identifier;
                }
                [realView addConstraint:newConstraint];
            }
        }
    }
}


+ (CGFloat)heightForLabelWithWidth:(CGFloat)width LineBreakMode:(NSLineBreakMode)mode Font:(UIFont *)font topGap:(CGFloat)tGap bottomGap:(CGFloat)bGap andText:(NSString *)text {
    if ([text length] == 0) {
        return 0;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, font.pointSize)];
    [label setLineBreakMode:mode];
    [label setFont:font];
    [label setText:text];
    CGFloat height = [label sizeToFitWithMaximumNumberOfLines:0] + tGap + bGap;
    return height;
}


+ (CGFloat)heightForLabelWithWidth:(CGFloat)width LineBreakMode:(NSLineBreakMode)mode Font:(UIFont *)font topGap:(CGFloat)tGap bottomGap:(CGFloat)bGap maxLine:(NSUInteger)line andText:(NSString *)text {
    if ([text length] == 0) {
        return 0;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, font.pointSize)];
    [label setLineBreakMode:mode];
    [label setFont:font];
    [label setText:text];
    CGFloat height = [label sizeToFitWithMaximumNumberOfLines:line] + tGap + bGap;
    return height;
}


+ (void)resetLineView:(UIView *)view withLayoutAttribute:(NSLayoutAttribute)attribute {
    NSArray *leftBorderConstraintsArray = [view constraints];
    for (NSLayoutConstraint *constraint in leftBorderConstraintsArray) {
        if (constraint.firstAttribute == attribute) {
            //height constraint
            //new
            constraint.constant = BORDER_WIDTH;
            break;
        }
    }
}

+ (NSString *)currentSMSCodeKey {
    NSString *deviceId = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSTimeInterval timeStamp = [NSDate timeIntervalSinceReferenceDate];
    NSString *codeKey = [NSString stringWithFormat:@"%@%f", deviceId, timeStamp];
    return codeKey;
}

@end
