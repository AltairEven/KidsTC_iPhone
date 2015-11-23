//
//  ActivityLogoItem.h
//  KidsTC
//
//  Created by Altair on 11/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ActivityLogoItemTypeGift = 1,
    ActivityLogoItemTypePreferential,
    ActivityLogoItemTypeCoupon,
    ActivityLogoItemTypeTuan
}ActivityLogoItemType;

@interface ActivityLogoItem : NSObject

@property (nonatomic, assign) ActivityLogoItemType type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *itemDescription;

@property (nonatomic, readonly) UIImage *image;

- (instancetype)initWithType:(ActivityLogoItemType)type description:(NSString *)description;

@end
