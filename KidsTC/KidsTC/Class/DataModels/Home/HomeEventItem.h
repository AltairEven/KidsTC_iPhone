//
//  HomeEventItem.h
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeElementBaseModel.h"

@interface HomeEventItem : HomeElementBaseModel

@property (nonatomic, copy) NSString *promotionWords; //促销语

@property (nonatomic, strong) NSArray *showingProducts; //展示的商品

@property (nonatomic, copy) NSString *badgeImageName; //徽章图标名称

@property (nonatomic, strong) NSNumber *price; //原价

@property (nonatomic, strong) NSNumber *promotePrice; //促销价

@end
