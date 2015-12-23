//
//  PromotionBaseModel.h
//  KidsTC
//
//  Created by 钱烨 on 9/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionBaseModel : NSObject

@property (nonatomic, copy) NSString *promotionId;

@property (nonatomic, copy) NSString *promotionDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
