//
//  ServiceMoreDetailHotSalesItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceMoreDetailHotSalesItemModel : NSObject

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) CGFloat price;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
