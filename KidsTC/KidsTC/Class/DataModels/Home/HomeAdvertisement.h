//
//  HomeAdvertisement.h
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeElementBaseModel.h"

@interface HomeAdvertisement : HomeElementBaseModel

@property (nonatomic, copy) NSString *subTitle; //副标题

@property (nonatomic, assign) BOOL hasCaption; //是否有标题视图

@end
