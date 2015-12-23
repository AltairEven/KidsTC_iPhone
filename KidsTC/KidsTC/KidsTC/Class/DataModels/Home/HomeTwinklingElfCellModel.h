//
//  HomeTwinklingElfCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeTwinklingElf;

@interface HomeTwinklingElfCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeTwinklingElf *> *twinklingElvesArray;

@end


@interface HomeTwinklingElf : HomeElementBaseModel

@property (nonatomic, copy) NSString *title; //标题

@property (nonatomic, copy) NSString *imageName; //本地图片

@property (nonatomic, readonly) BOOL hasLocalImage; //存在本地图片

@end