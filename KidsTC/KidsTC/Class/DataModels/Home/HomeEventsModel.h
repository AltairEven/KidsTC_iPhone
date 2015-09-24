//
//  HomeEventsModel.h
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeEventItem.h"

@interface HomeEventsModel : NSObject

@property (nonatomic, copy) NSString *title; //热门活动标题

@property (nonatomic, strong) NSArray *eventItemsArray; //热门活动

- (instancetype)initWithHomeData:(NSDictionary *)data;

@end
