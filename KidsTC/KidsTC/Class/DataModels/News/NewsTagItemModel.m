//
//  NewsTagItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/15/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsTagItemModel.h"

@interface NewsTagTypeModel ()

- (KTCUserRole *)userRoleWithType:(NSUInteger)type;

@end

@implementation NewsTagTypeModel


//if ([data objectForKey:@"id"]) {
//    self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
//}
//self.name = [NSString stringWithFormat:@"%@", [data objectForKey:@"tagName"]];
//self.isHot = [[data objectForKey:@"isHostTag"] boolValue];
//self.type = [[data objectForKey:@"type"] integerValue];

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.type = [[data objectForKey:@"type"] integerValue];
        self.typeDescription = [NSString stringWithFormat:@"%@", [data objectForKey:@"typeDesc"]];
        NSArray *tags = [data objectForKey:@"tags"];
        if (tags && [tags isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            //手动添加“全部”, WTF
            NSDictionary *allDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"id", @"全部", @"tagName", @"1", @"isHotTag", [NSNumber numberWithInteger:self.type], @"type", nil];
            NewsTagItemModel *allModel = [[NewsTagItemModel alloc] initWithRawData:allDic];
            if (allDic) {
                [tempArray addObject:allModel];
            }
            for (NSDictionary *singleElem in tags) {
                NewsTagItemModel *model = [[NewsTagItemModel alloc] initWithRawData:singleElem];
                if (model) {
                    [tempArray addObject:model];
                }
            }
            self.tagItems = [NSArray arrayWithArray:tempArray];
        }
        
        KTCUserRole *role = [self userRoleWithType:self.type];
        if (role) {
            self.metaData = [[NewsTagTypeModelMetaData alloc] init];
            self.metaData.image = [KTCUserRole middleImageWithUserRole:role];
            self.metaData.mainTitle = [KTCUserRole mainDescriptionWithUserRole:role];
            self.metaData.subTitle = [KTCUserRole subDescriptionWithUserRole:role];
        }
    }
    return self;
}


+ (NSUInteger)tagTypeFromUserRole:(KTCUserRole *)role {
    if (!role) {
        return 1;
    }
    NSUInteger tagType = 1;
    switch (role.role) {
        case UserRolePrepregnancy: {
            tagType = 1;
        }
            break;
        case UserRolePregnancy: {
            tagType = 2;
        }
            break;
        case UserRoleBirth: {
            tagType = 3;
        }
            break;
        case UserRoleBabyInOne: {
            tagType = 4;
        }
            break;
        case UserRoleBabyOneToThree: {
            tagType = 5;
        }
            break;
        case UserRoleBabyFourToSix: {
            tagType = 6;
        }
            break;
        default:
            break;
    }
    return tagType;
}

- (KTCUserRole *)userRoleWithType:(NSUInteger)type {
    KTCUserRole *role = nil;
    switch (type) {
        case 1:
        {
            role = [KTCUserRole instanceWithRole:UserRolePrepregnancy sex:KTCSexMale];
        }
            break;
        case 2:
        {
            role = [KTCUserRole instanceWithRole:UserRolePregnancy sex:KTCSexMale];
        }
            break;
        case 3:
        {
            role = [KTCUserRole instanceWithRole:UserRoleBirth sex:KTCSexMale];
        }
            break;
        case 4:
        {
            role = [KTCUserRole instanceWithRole:UserRoleBabyInOne sex:KTCSexMale];
        }
            break;
        case 5:
        {
            role = [KTCUserRole instanceWithRole:UserRoleBabyOneToThree sex:KTCSexMale];
        }
            break;
        case 6:
        {
            role = [KTCUserRole instanceWithRole:UserRoleBabyFourToSix sex:KTCSexMale];
        }
            break;
        default:
            break;
    }
    return role;
}

@end


@implementation NewsTagItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.name = [NSString stringWithFormat:@"%@", [data objectForKey:@"tagName"]];
        self.isHot = [[data objectForKey:@"isHostTag"] boolValue];
        self.type = [[data objectForKey:@"type"] integerValue];
    }
    return self;
}

- (KTCUserRole *)relatedUserRole {
    KTCUserRole *role = nil;
    switch (self.type) {
        case 1:
        {
            role = [KTCUserRole instanceWithRole:UserRolePrepregnancy sex:KTCSexMale];
        }
            break;
        case 2:
        {
            role = [KTCUserRole instanceWithRole:UserRolePregnancy sex:KTCSexMale];
        }
            break;
        case 3:
        {
            role = [KTCUserRole instanceWithRole:UserRoleBirth sex:KTCSexMale];
        }
            break;
        case 4:
        {
            role = [KTCUserRole instanceWithRole:UserRoleBabyInOne sex:KTCSexMale];
        }
            break;
        case 5:
        {
            role = [KTCUserRole instanceWithRole:UserRoleBabyOneToThree sex:KTCSexMale];
        }
            break;
        case 6:
        {
            role = [KTCUserRole instanceWithRole:UserRoleBabyFourToSix sex:KTCSexMale];
        }
            break;
        default:
            break;
    }
    return role;
}

@end

@implementation NewsTagTypeModelMetaData



@end
