//
//  KTCUserRole.h
//  KidsTC
//
//  Created by Altair on 11/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UserRoleUnknown = 0, //未知
    UserRolePrepregnancy = 1, //备孕
    UserRolePregnancy = 2, //孕期
    UserRoleBirth = 3, //新生儿，0~6月
    UserRoleBabyInOne = 5, //一岁以内，7~12月
    UserRoleBabyOneToThree = 7, //一到三岁，0~6月
    UserRoleBabyFourToSix = 9, //四到六岁
}UserRole;

typedef enum {
    KTCSexUnknown = 0, //未知
    KTCSexMale, //男
    KTCSexFemale //女
}KTCSex;

@interface KTCUserRole : NSObject

@property (nonatomic, assign) UserRole role;

@property (nonatomic, assign) KTCSex sex;

@property (nonatomic, copy) NSString *roleName;

+ (instancetype)instanceWithRole:(UserRole)role sex:(KTCSex)sex;

+ (instancetype)instanceWithIdentifier:(NSUInteger)identifier;

+ (NSUInteger)userRoleIdentifierWithRole:(UserRole)role sex:(KTCSex)sex;

- (NSString *)userRoleIdentifierString;

+ (UIImage *)smallImageWithUserRole:(KTCUserRole *)role;

+ (UIImage *)middleImageWithUserRole:(KTCUserRole *)role;

+ (NSString *)mainDescriptionWithUserRole:(KTCUserRole *)role;

+ (NSString *)subDescriptionWithUserRole:(KTCUserRole *)role;

- (UIImage *)refreshImageForUp;

- (UIImage *)refreshImageForDown;

- (UIImage *)emptyTableBGImage;

@end
