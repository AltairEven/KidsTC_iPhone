//
//  HomeElementBaseModel.h
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeSegueModel.h"

@interface HomeElementBaseModel : NSObject

@property (nonatomic, strong) NSURL *imageUrl; //展示图片的链接URL

@property (nonatomic, strong) HomeSegueModel *segueModel;

- (instancetype)initWithHomeData:(NSDictionary *)data;

- (void)parseHomeData:(NSDictionary *)data;

@end
