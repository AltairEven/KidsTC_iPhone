//
//  HomeTimeQiangCell.m
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeTimeQiangCell.h"
#import "RichPriceView.h"

@interface HomeTimeQiangCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;

@end

@implementation HomeTimeQiangCell

- (void)awakeFromNib {
    // Initialization code
    //price view
    [self.priceView setContentColor:COLOR_GLOBAL_NORMAL];
    [self.priceView.unitLabel setFont:[UIFont systemFontOfSize:12]];
    [self.priceView.priceLabel setFont:[UIFont systemFontOfSize:16]];
}

- (void)setImageUrl:(NSURL *)imageUrl {
    _imageUrl = imageUrl;
    [self.cellImageView setImageWithURL:imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
}

- (void)setPrice:(CGFloat)price {
    _price = price;
    [self.priceView setPrice:price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
