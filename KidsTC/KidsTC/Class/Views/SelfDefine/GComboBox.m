//
//  GComboBox.m
//  iphone
//
//  Created by CGS on 12-3-11.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GComboBox.h"

@implementation GComboBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        button = [[UIButton alloc] initWithFrame: frame];
        pickerView = [[UIPickerView alloc] init];

        [self addSubview: button];
        [self addSubview: pickerView];
    }
    return self;
}


@end
