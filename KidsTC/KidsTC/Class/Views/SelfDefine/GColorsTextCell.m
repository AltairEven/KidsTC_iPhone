//
//  GColorsTextCell.m
//  iphone51buy
//
//  Created by gene chu on 9/10/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import "GColorsTextCell.h"

@implementation GColorsTextCell
@synthesize textLab = _textLab;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier widthNoCustomBorder:YES];
    if (self) {
        // Initialization code
        CGRect textRect = self.contentView.bounds;
        textRect.origin.y += 5;
        textRect.origin.x += 5;
        textRect.size.width -= 10;
        _textLab = [[GColorsLab alloc] initWithFrame:textRect];
        _textLab.backgroundColor = [UIColor clearColor];
        _textLab.opaque = NO;
        _textLab.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_textLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textRect = self.contentView.bounds;
    textRect.origin.y += 5;
    textRect.origin.x += 5;
    textRect.size.width -= 10;
    _textLab.frame = textRect;
}
@end
