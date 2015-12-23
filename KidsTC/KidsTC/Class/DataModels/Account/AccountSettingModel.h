//
//  AccountSettingModel.h
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountSettingModel : NSObject

@property (nonatomic, strong) NSURL *faceImageUrl; //头像

@property (nonatomic, strong) UIImage *faceImage; //本地头像

@property (nonatomic, copy) NSString *userName; //用户名

@property (nonatomic, strong) KTCUserRole *userRole; //角色

@property (nonatomic, copy) NSString *phone; //电话

@end
