//
//  ActiveModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ActiveTypeGift = 1,
    ActiveTypePreferential,
    ActiveTypeTuan
}ActiveType;

@interface ActiveModel : NSObject

@property (nonatomic, assign) ActiveType type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *activeDescription;

@property (nonatomic, readonly) UIImage *image;

- (instancetype)initWithType:(ActiveType)type AndDescription:(NSString *)description;

@end
