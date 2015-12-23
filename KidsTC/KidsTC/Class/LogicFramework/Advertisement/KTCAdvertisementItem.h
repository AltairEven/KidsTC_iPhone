//
//  KTCAdvertisementItem.h
//  KidsTC
//
//  Created by Altair on 12/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeSegueModel.h"

@interface KTCAdvertisementItem : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) HomeSegueModel *segueModel;

- (instancetype)initWithImage:(UIImage *)image segueRawData:(NSDictionary *)data;

@end
