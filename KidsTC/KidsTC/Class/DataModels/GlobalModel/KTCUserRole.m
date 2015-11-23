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
    NSUInteger identifier = [KTCUserRole userRoleIdentifierWithRole:role sex:sex];
    switch (identifier) {
        case 0:
        {
            name = @"未知";
        }
            break;
        case 1:
        {
            name = @"备孕";
        }
            break;
        case 2:
        {
            name = @"孕期";
        }
            break;
        case 3:
        {
            name = @"新生儿(男)";
        }
            break;
        case 4:
        {
            name = @"新生儿(女)";
        }
            break;
        case 5:
        {
            name = @"婴儿(男)";
        }
            break;
        case 6:
        {
            name = @"婴儿(女)";
        }
            break;
        case 7:
        {
            name = @"幼儿(男)";
        }
            break;
        case 8:
        {
            name = @"幼儿(女)";
        }
            break;
        case 9:
        {
            name = @"学前(男)";
        }
            break;
        case 10:
        {
            name = @"学前(女)";
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

+ (NSUInteger)userRoleIdentifierWithRole:(UserRole)role sex:(KTCSex)sex {
    NSUInteger identifier = 0;
    if (sex == 0) {
        identifier = role;
    } else {
        identifier = role + sex - 1;
    }
    return identifier;
}

- (NSString *)userRoleIdentifierString {
    return [NSString stringWithFormat:@"%lu", (unsigned long)[KTCUserRole userRoleIdentifierWithRole:self.role sex:self.sex]];
}

+ (UIImage *)smallImageWithUserRole:(KTCUserRole *)role {
    UserRole userRole = role.role;
    UIImage *image = nil;
    switch (userRole) {
        case UserRoleUnknown:
        {
        }
            break;
        case UserRolePrepregnancy:
        {
            image = [UIImage imageNamed:@"roleselect_prepregnancy_small"];
        }
            break;
        case UserRolePregnancy:
        {
            image = [UIImage imageNamed:@"roleselect_pregnancy_small"];
        }
            break;
        case UserRoleBirth:
        {
            image = [UIImage imageNamed:@"roleselect_newbirth_small"];
        }
            break;
        case UserRoleBabyInOne:
        {
            image = [UIImage imageNamed:@"roleselect_babyinone_small"];
        }
            break;
        case UserRoleBabyOneToThree:
        {
            image = [UIImage imageNamed:@"roleselect_223_small"];
        }
            break;
        case UserRoleBabyFourToSix:
        {
            image = [UIImage imageNamed:@"roleselect_426_small"];
        }
            break;
        default:
            break;
    }
    return image;
}

@end
