//
//  KTCUserRole.m
//  KidsTC
//
//  Created by Altair on 11/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCUserRole.h"

@interface KTCUserRole ()

+ (instancetype)instanceWithRole:(UserRole)role sex:(KTCSex)sex andRoleName:(NSString *)name;

@end

@implementation KTCUserRole

+ (instancetype)instanceWithRole:(UserRole)role sex:(KTCSex)sex {
    NSString *name = @"未知";
    switch (role) {
        case UserRoleUnknown:
        {
            name = @"未知";
        }
            break;
        case UserRolePrepregnancy:
        {
            name = @"备孕";
        }
            break;
        case UserRolePregnancy:
        {
            name = @"孕期";
        }
            break;
        case UserRoleBirth:
        {
            name = @"新生儿";
        }
            break;
        case UserRoleBabyInOne:
        {
            name = @"婴儿";
        }
            break;
        case UserRoleBabyOneToThree:
        {
            name = @"幼儿";
        }
            break;
        case UserRoleBabyFourToSix:
        {
            name = @"学前";
        }
            break;
        default:
            break;
    }
    return [KTCUserRole instanceWithRole:role sex:sex andRoleName:name];
}

+ (instancetype)instanceWithRole:(UserRole)role sex:(KTCSex)sex andRoleName:(NSString *)name {
    KTCUserRole *userRole = [[KTCUserRole alloc] init];
    userRole.role = role;
    userRole.sex = sex;
    userRole.roleName = name;
    return userRole;
}

+ (instancetype)instanceWithIdentifier:(NSUInteger)identifier {
    if (identifier < UserRoleUnknown || identifier > UserRoleBabyFourToSix) {
        return [KTCUserRole instanceWithRole:UserRoleUnknown sex:KTCSexUnknown];
    }
    if (identifier == UserRolePrepregnancy || identifier == UserRolePregnancy) {
        return [KTCUserRole instanceWithRole:(UserRole)identifier sex:KTCSexUnknown];
    }
    BOOL isFemale = NO;
    if (identifier % 2 == 0) {
        isFemale = YES;
    }
    KTCSex sex = KTCSexUnknown;
    if (isFemale) {
        sex = KTCSexFemale;
    } else {
        sex = KTCSexMale;
    }
    
    UserRole role = (UserRole)(identifier + 1 - sex);
    return [KTCUserRole instanceWithRole:role sex:sex];
}

- (NSUInteger)userRoleIdentifier {
    NSUInteger identifier = 0;
    if (self.sex == 0) {
        identifier = self.role;
    } else {
        identifier = self.role + self.sex - 1;
    }
    return identifier;
}

- (NSString *)userRoleIdentifierString {
    return [NSString stringWithFormat:@"%lu", (unsigned long)[self userRoleIdentifier]];
}

@end
