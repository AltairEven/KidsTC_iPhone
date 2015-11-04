//
//  AccountSettingModel.h
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountSettingModel : NSObject

@property (nonatomic, strong) NSURL *faceImgaeUrl;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *mobilePhoneNumber;

@property (nonatomic, assign) UserRole userRole;

@end
