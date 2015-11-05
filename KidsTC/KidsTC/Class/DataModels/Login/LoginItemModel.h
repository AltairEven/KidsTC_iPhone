//
//  LoginItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LoginTypeKidTC,
    LoginTypeQQ,
    LoginTypeWechat,
    LoginTypeWeibo
}LoginType;

@interface LoginItemModel : NSObject

@property (nonatomic, assign) LoginType type;

@property (nonatomic, copy) NSString *loginDescription;

@property (nonatomic, strong) UIImage *logo;

@end
