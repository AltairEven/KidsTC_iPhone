//
//  GColorsTextCell.h
//  iphone51buy
//
//  Created by gene chu on 9/10/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTableViewCell.h"
#import "GColorsLab.h"
@interface GColorsTextCell : GTableViewCell
@property (nonatomic, readonly)GColorsLab *textLab;
@end
