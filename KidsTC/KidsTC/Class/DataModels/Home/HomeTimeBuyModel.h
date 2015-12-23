//
//  HomeTimeBuyModel.h
//  ICSON
//
//  Created by 钱烨 on 4/15/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeElementBaseModel.h"


extern NSString *const kHomeTimeBuyQiangModel;
extern NSString *const kHomeTimeBuyTuanModel;
extern NSString *const kHomeTimeBuyMarketModel;

@interface HomeTimeBuyModel : HomeElementBaseModel

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *descriptionText;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSDictionary *eventItem;

@end
