//
//  HomeTwinklingElf.h
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeElementBaseModel.h"

@interface HomeTwinklingElf : HomeElementBaseModel

@property (nonatomic, copy) NSString *title; //标题

@property (nonatomic, copy) NSString *imageName; //本地图片

@property (nonatomic, readonly) BOOL hasLocalImage; //存在本地图片

@end
