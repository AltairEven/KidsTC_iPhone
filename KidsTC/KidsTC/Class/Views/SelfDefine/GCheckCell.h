//
//  GCheckCell.h
//  iphone51buy
//
//  Created by gene chu on 9/5/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTableViewCell.h"

@interface GCheckCell : GTableViewCell
{
    BOOL _checked;
}

@property (nonatomic) BOOL checked;
- (void)checkState:(BOOL)newState;

@end
