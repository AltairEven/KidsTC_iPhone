//
//  AddressManager.m
//  ICSON
//
//  Created by 钱烨 on 2/7/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "AddressManager.h"

#define DEFAULT_MD5_STRING (@"defaultmd5string")

static AddressManager *_addressManager = nil;

@interface AddressManager ()

@property (nonatomic, strong) HttpRequestClient *loadRequest;

@property (nonatomic, strong) HttpRequestClient *loadTownsRequest;

@property (nonatomic, strong) HttpRequestClient *loadTownRelatedRequest;

@property (nonatomic, copy) NSString *localMD5String;

- (BOOL)isCountryADInLocalFile:(AdministrativeDivision *)countryAd;
- (BOOL)isProvinceInLocalFile:(AdministrativeDivision *)province;
- (BOOL)isCityInLocalFile:(AdministrativeDivision *)city;
- (BOOL)isCountyInLocalFile:(AdministrativeDivision *)county;

@end


@implementation AddressManager
@synthesize hasValidData = _hasValidData;
@synthesize loadRequest;


- (id)init
{
    self = [super init];
    if (self) {
        _hasValidData = NO;
        self.loadRequest = nil;
    }
    
    return self;
}


+ (instancetype)sharedManager
{
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^{
        _addressManager = [[AddressManager alloc] init];
    });
    
    return _addressManager;
}


- (void)validateADListDataWithSuccess:(void (^)(AddressManager *))success andFailure:(void (^)(NSError *))failure
{
    if (!self.loadRequest) {
        self.loadRequest = [HttpRequestClient clientWithUrlAliasName:@"URL_FULL_DISTRICT"];
    }
    //先获取本地MD5值
    self.localMD5String = [IcsonCountryAD getLocalMd5String];
    if ([GToolUtil isEmpty:self.localMD5String]) {
        self.localMD5String = DEFAULT_MD5_STRING;
    }

    NSDictionary *param = [NSDictionary dictionaryWithObject:self.localMD5String forKey:@"fileMD5"];
    [self.loadRequest setParameter:param];
    
    //发送数据拉取请求
    __weak AddressManager *weakSelf = self;
    [weakSelf.loadRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        
        [weakSelf loadAddressSucceed:responseData];
        success(weakSelf);
        
    } failure:^(HttpRequestClient *client, NSError *error) {
        
        [weakSelf loadAddressFailed:error];
        failure(error);
        
    }];
}



- (void)loadAddressSucceed:(id)info
{
    NSLog(@"Load ADList succeed.....");
    
    NSDictionary *dataDic = [info objectForKey:@"data"];
    
    if(dataDic && [dataDic count] > 0)
    {
        NSError *error = nil;
        [IcsonCountryAD parseAndSaveServerData:dataDic withError:&error];
    }
    _hasValidData = YES;
}



- (void)loadAddressFailed:(id)info
{
    if (![self.localMD5String isEqualToString:DEFAULT_MD5_STRING]) {
        _hasValidData = YES;
    }
    NSLog(@"Load ADList failed.....");
}




- (AdministrativeDivision *)getADInfoWithMatchType:(MatchType)type matchData:(id)data andError:(NSError *__autoreleasing *)error {
    
    if (!data) {
        return nil;
    }
    
    AdministrativeDivision *resultAD;
    for (AdminLevel al = AdminLevelProvince; al <= AdminLevelTown; al ++) {
        resultAD = [self getADInfoWithLevel:al matchType:type matchData:data andError:error];
        if (resultAD) {
            break;
        }
    }
    
    return resultAD;
}



- (AdministrativeDivision *)getADInfoWithLevel:(AdminLevel)level matchType:(MatchType)type matchData:(id)data andError:(NSError *__autoreleasing *)error
{
    if (!data) {
        return nil;
    }
    
    switch (level) {
        case AdminLevelCountry:
        {
            return nil;
        }
            break;
        case AdminLevelProvince:
        {
            return [IcsonProvince getProvinceWithMatchType:type matchData:data andError:error];
        }
            break;
        case AdminLevelCity:
        {
            return [IcsonCity getCityWithMatchType:type matchData:data andError:error];
        }
            break;
        case AdminLevelCounty:
        {
            return [IcsonCounty getCountyWithMatchType:type matchData:data andError:error];
        }
            break;
        case AdminLevelTown:
        {
            return [IcsonTown getTownWithMatchType:type matchData:data andError:error];
        }
            break;
        case AdminLevelVillage:
        {
            return nil;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}



- (NSArray *)getADArrayWithLevel:(AdminLevel)level andError:(NSError *__autoreleasing *)error
{
    NSArray *resultArray;
    switch (level) {
        case AdminLevelCountry:
        {
            
        }
            break;
        case AdminLevelProvince:
        {
            resultArray = [IcsonProvince getADArrayWithError:error];
        }
            break;
        case AdminLevelCity:
        {
            resultArray = [IcsonCity getADArrayWithError:error];
        }
            break;
        case AdminLevelCounty:
        {
            resultArray = [IcsonCounty getADArrayWithError:error];
        }
            break;
        case AdminLevelTown:
        {
            resultArray = [IcsonTown getADArrayWithError:error];
        }
            break;
        case AdminLevelVillage:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    if (resultArray) {
        resultArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            //按sort ID升序排列
            AdministrativeDivision *ad1 = obj1;
            AdministrativeDivision *ad2 = obj2;
            return [ad1.sortId compare:ad2.sortId];
        }];
    }
    
    return resultArray;
}



- (void)getTownsForCounty:(IcsonCounty *)county fromServerWithSuccess:(void (^)())success failed:(void (^)(NSError *))failed {
    if (!self.loadTownsRequest) {
        self.loadTownsRequest = [HttpRequestClient clientWithUrlAliasName:@"URL_ADDRESS_GETTOWNS"];
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           county.gbAreaId, @"countyid",
                           @"iPhone", @"appSource",
                           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], @"appVersion",
                           [NSString stringWithFormat:@"%ld", (long)([UserWrapper shareMasterUser].uid)], @"uid",
                           nil];
    [self.loadTownsRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        //获得乡镇列表
        NSArray *arr = [NSArray arrayWithArray:[responseData objectForKey:@"data"]];
        if (!arr || [arr count] == 0)
        {
            success();
            return;
        }
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:[arr count]];
        for (NSDictionary *dic in arr) {
            NSUInteger townId = [[dic objectForKey:@"townNo"] integerValue];
            NSString *townName = [dic objectForKey:@"townName"];
            IcsonTown *town = [IcsonTown ADInstance];
            town.uniqueId = [NSNumber numberWithInteger:townId];
            town.name = townName;
            town.sortId = [NSNumber numberWithInteger:townId];
            town.adminLevel = [NSNumber numberWithInteger:AdminLevelTown];
            [tempArray addObject:town];
        }
        [county removeTownList:county.townList];
        [county addTownList:[NSSet setWithArray:tempArray]];
        success();
    } failure:^(HttpRequestClient *client, NSError *error) {
        NSString *errMsg = [[error userInfo] objectForKey:@"data"];
        NSError *returnError = [NSError errorWithDomain:@"Get Towns For County" code:-1 userInfo:[NSDictionary dictionaryWithObject:errMsg forKey:@"errorMsg"]];
        failed(returnError);
    }];
    
}



- (void)getADInfoWithTownUniqueId:(NSUInteger)uId fromServerWithSuccess:(void (^)(IcsonTown *))success failed:(void (^)(NSError *))failed {
    if (!self.loadTownRelatedRequest) {
        self.loadTownRelatedRequest = [HttpRequestClient clientWithUrlAliasName:@"URL_ADDRESS_GETDETAILS"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%ld", (long)uId], @"district",
                           @"iPhone", @"appSource",
                           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], @"appVersion",
                           [NSString stringWithFormat:@"%ld", (long)([UserWrapper shareMasterUser].uid)], @"uid",
                           nil];
    [self.loadTownRelatedRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        NSDictionary *dataDic = [responseData objectForKey:@"data"];
        if (!dataDic || [dataDic count] == 0)
        {
            //返回data无效
            NSError *error = [NSError errorWithDomain:@"Get ADInfo With Town" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"获取地址信息失败" forKey:@"errorMsg"]];
            failed(error);
            return;
        }
        NSNumber *gbAreaId = [dataDic objectForKey:@"gbAreaId"];
        if ([gbAreaId integerValue] > 0) {
            NSError *error = nil;
            IcsonCounty *countyAD =  (IcsonCounty *)[[AddressManager sharedManager] getADInfoWithLevel:AdminLevelCounty matchType:MatchTypeGbAreaId matchData:gbAreaId andError:&error];
            if (error) {
                //获取本地信息失败
                NSError *error = [NSError errorWithDomain:@"Get ADInfo With Town" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"获取地址信息失败" forKey:@"errorMsg"]];
                failed(error);
            } else {
                //获得乡镇列表
                NSDictionary *townsDic = [dataDic objectForKey:@"towns"];
                if (!townsDic || [townsDic count] == 0) {
                    success(nil);
                    return;
                }
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:[townsDic count]];
                IcsonTown *returnTown = nil;
                for (NSDictionary *townDic in [townsDic allValues]) {
                    NSUInteger townId = [[townDic objectForKey:@"townNo"] integerValue];
                    NSString *townName = [townDic objectForKey:@"townName"];
                    IcsonTown *town = [IcsonTown ADInstance];
                    town.uniqueId = [NSNumber numberWithInteger:townId];
                    town.name = townName;
                    town.sortId = [NSNumber numberWithInteger:townId];
                    town.adminLevel = [NSNumber numberWithInteger:AdminLevelTown];
                    [tempArray addObject:town];
                    if (townId == uId) {
                        returnTown = town;
                    }
                }
                [countyAD removeTownList:countyAD.townList];
                [countyAD addTownList:[NSSet setWithArray:tempArray]];
                success((IcsonTown *)returnTown);
            }
        } else {
            //gbAreaId无效
            NSError *error = [NSError errorWithDomain:@"Get ADInfo With Town" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"获取地址信息失败" forKey:@"errorMsg"]];
            failed(error);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        NSString *errMsg = [[error userInfo] objectForKey:@"data"];
        NSError *returnError = [NSError errorWithDomain:@"Get ADInfo With Town" code:-1 userInfo:[NSDictionary dictionaryWithObject:errMsg forKey:@"errorMsg"]];
        failed(returnError);
    }];
}


@end
