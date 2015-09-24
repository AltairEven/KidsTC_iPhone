//
//  GCheckCell.m
//  iphone51buy
//
//  Created by gene chu on 9/5/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import "GCheckCell.h"

@implementation GCheckCell
@synthesize checked = _checked;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier widthNoCustomBorder:YES];
    if (self) {
        // Initialization code
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.opaque = NO;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.textLabel.numberOfLines = 0;
        
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
    
    CGRect contentRect = [self.contentView bounds];
    
    CGRect frame = CGRectMake(contentRect.origin.x + 40, 8.0, contentRect.size.width-40, self.contentView.bounds.size.height-16);
    self.textLabel.frame = frame;
    
    //Layout the check button image.
    UIImage *checkedImage = [UIImage imageNamed:@"radio_on.png"];
//    frame = CGRectMake(contentRect.origin.x + 10.0, 12.0, 24, 24);
    frame = CGRectMake(contentRect.origin.x + 10.0, (contentRect.size.height-16)/2, 16, 16);
    self.imageView.frame = frame;
    
    UIImage *image = (self.checked)? checkedImage :[UIImage imageNamed:@"radio_off.png"];
    self.imageView.image = image;
}

- (void)checkState:(BOOL)newState
{
    if (self.checked != newState) {
        self.checked = newState;
        UIImage *checkImage = (self.checked) ? [UIImage imageNamed:@"radio_on.png"] : [UIImage imageNamed:@"radio_off.png"];
		self.imageView.image = checkImage;
    }
}
@end
