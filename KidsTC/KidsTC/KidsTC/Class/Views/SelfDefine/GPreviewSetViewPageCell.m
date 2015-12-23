/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GPreviewSetViewPageCell.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：12/24/12
 */

#import "GPreviewSetViewPageCell.h"


@interface GPreviewSetViewPageCell ()
{
    float _titleHight;
    float _priceHight;
}
@end


@implementation GPreviewSetViewPageCell

@synthesize previewImg;
@synthesize priceLab;
@synthesize titleLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleHight = 30;
        _priceHight = 20;
        CGRect aRect = self.bounds;
        aRect.size.height -= _titleHight - _priceHight;
        
        @autoreleasepool {
            self.previewImg = [[IcsonImageView alloc] initWithFrame:aRect];
            self.previewImg.backgroundColor = [UIColor whiteColor];
            self.previewImg.layer.cornerRadius = 5;
            self.previewImg.layer.borderWidth = 1;
            self.previewImg.layer.borderColor = BUTTON_WEAK_BG.CGColor;
            self.previewImg.imgInset = UIEdgeInsetsMake(5, 5, 5, 5);
            [self addSubview:self.previewImg];
            
            aRect = CGRectMake(0.0, self.previewImg.frame.size.height, frame.size.width, _priceHight);
            self.priceLab = [[UILabel alloc] initWithFrame:aRect];
            self.priceLab.backgroundColor = [UIColor clearColor];
            self.priceLab.textAlignment = UITextAlignmentLeft;
            self.priceLab.textColor = [UIColor colorWithRed:200.0/255.0 green:61.0/255.0 blue:0 alpha:1];
            self.priceLab.font = [UIFont systemFontOfSize:12.0];
            [self addSubview:self.priceLab];
            
            aRect = CGRectMake(0.0, self.priceLab.frame.size.height + self.priceLab.frame.origin.y, frame.size.width, _titleHight);
            self.titleLab = [[UILabel alloc] initWithFrame:aRect];
            self.titleLab.backgroundColor = [UIColor clearColor];
            self.titleLab.textAlignment = UITextAlignmentLeft;
            self.titleLab.font = [UIFont systemFontOfSize:12.0];
            self.titleLab.minimumFontSize = 12.0;
            self.titleLab.textColor = COLOR_PRICE_BLACK;
            self.titleLab.numberOfLines = 2;
            self.titleLab.adjustsFontSizeToFitWidth = NO;
            
            [self addSubview:self.titleLab];
        }
        
        
        self.exclusiveTouch = NO;
    }
    return self;
}


+ (CGFloat) suggestHeight
{
    return 155;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float imgWidth = self.bounds.size.width - 10;
    
    self.previewImg.bounds = CGRectMake(0.0, 0.0, imgWidth, imgWidth);
    self.previewImg.center = CGPointMake(5 + imgWidth/2, 5 + imgWidth/2);
    
    self.titleLab.frame = CGRectMake(5.0, CGRectGetMaxY(self.previewImg.frame) + 5, imgWidth, _titleHight);
    self.priceLab.frame = CGRectMake(5.0, CGRectGetMaxY(self.titleLab.frame), imgWidth, _priceHight);
}

@end
