//
//  StoreDetailViewServiceCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreDetailViewServiceCell.h"
#import "RichPriceView.h"

@interface StoreDetailViewServiceCell ()

@property (weak, nonatomic) IBOutlet UIView *leftBG;
@property (weak, nonatomic) IBOutlet UIView *rightBG;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *leftPromotionPriceView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightNameLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *rightPromotionPriceView;

- (void)didClicked:(id)sender;

@end

@implementation StoreDetailViewServiceCell

- (void)awakeFromNib {
    // Initialization code
    [self.leftPromotionPriceView setContentColor:COLOR_GLOBAL_NORMAL];
    [self.leftPromotionPriceView.unitLabel setFont:[UIFont systemFontOfSize:16]];
    [self.leftPromotionPriceView.priceLabel setFont:[UIFont systemFontOfSize:20]];
    
    [self.rightPromotionPriceView setContentColor:COLOR_GLOBAL_NORMAL];
    [self.rightPromotionPriceView.unitLabel setFont:[UIFont systemFontOfSize:16]];
    [self.rightPromotionPriceView.priceLabel setFont:[UIFont systemFontOfSize:20]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.leftBG.tag = 100;
    self.rightBG.tag = 101;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClicked:)];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClicked:)];
    [self.leftBG addGestureRecognizer:leftTap];
    [self.rightBG addGestureRecognizer:rightTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configWithLeftModel:(ServiceListItemModel *)leftModel rightModel:(ServiceListItemModel *)rightModel {
    if (!leftModel || !rightModel) {
        return;
    }
    [self.leftImageView setImageWithURL:leftModel.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
    [self.leftNameLabel setText:leftModel.serviceName];
    [self.leftPromotionPriceView setPrice:leftModel.promotionPrice];
    
    [self.rightImageView setImageWithURL:rightModel.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
    [self.rightNameLabel setText:rightModel.serviceName];
    [self.rightPromotionPriceView setPrice:rightModel.promotionPrice];
}

+ (CGFloat)cellHeight {
    return 180;
}


- (void)didClicked:(id)sender {
    UIView *view = [(UITapGestureRecognizer *)sender view];
    NSUInteger itemIndex = self.index * 2;
    switch (view.tag) {
        case 100:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(storeDetailViewServiceCell:didClickedServiceAtIndex:)]) {
                [self.delegate storeDetailViewServiceCell:self didClickedServiceAtIndex:itemIndex];
            }
        }
            break;
        case 101:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(storeDetailViewServiceCell:didClickedServiceAtIndex:)]) {
                [self.delegate storeDetailViewServiceCell:self didClickedServiceAtIndex:itemIndex + 1];
            }
        }
            break;
        default:
            break;
    }
}

@end
