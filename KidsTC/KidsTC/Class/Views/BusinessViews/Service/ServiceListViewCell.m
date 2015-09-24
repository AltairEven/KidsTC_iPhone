//
//  ServiceListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceListViewCell.h"
#import "ServiceListItemModel.h"
#import "Insurance.h"

@interface ServiceListViewCell ()

@end

@implementation ServiceListViewCell

- (void)awakeFromNib {
    // Initialization code
    
    //price view
    [self.promotionPriceView setContentColor:COLOR_GLOBAL_NORMAL];
    [self.promotionPriceView.unitLabel setFont:[UIFont systemFontOfSize:16]];
    [self.promotionPriceView.priceLabel setFont:[UIFont systemFontOfSize:20]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(ServiceListItemModel *)model {
    if (!model) {
        return;
    }
    if (model.imageUrl) {
        [self.serviceImageView setImageWithURL:model.imageUrl];
    }
    [self.serviceNameLabel setText:model.serviceName];
    [self.starsView setStarNumber:model.starNumber];
    
    if (model.promotionPrice >= 0) {
        [self.promotionPriceView setPrice:model.promotionPrice];
    } else {
        [self.promotionPriceView setPrice:0];
    }
    [self.saledCountLabel setText:[NSString stringWithFormat:@"%d", model.saledCount]];
}

+ (CGFloat)cellHeight {
    return 130;
}

@end
