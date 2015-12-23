//
//  PromotionLogoItem.h
//  KidsTC
//
//  Created by Altair on 11/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PromotionLogoItemTypeCoupon //优惠券
}PromotionLogoItemType;

@interface PromotionLogoItem : NSObject

@property (nonatomic, assign) PromotionLogoItemType type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *itemDescription;

@property (nonatomic, readonly) UIImage *image;

- (instancetype)initWithType:(PromotionLogoItemType)type description:(NSString *)description;

@end
