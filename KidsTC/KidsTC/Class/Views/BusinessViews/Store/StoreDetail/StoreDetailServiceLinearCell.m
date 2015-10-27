//
//  StoreDetailServiceLinearCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "StoreDetailServiceLinearCell.h"
#import "RichPriceView.h"

@interface StoreDetailServiceLinearCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;

@end

@implementation StoreDetailServiceLinearCell

- (void)awakeFromNib {
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    // Initialization code
    [self.priceView setContentColor:[AUITheme theme].buttonBGColor_Normal];
    [self.priceView.unitLabel setFont:[UIFont systemFontOfSize:12]];
    [self.priceView.priceLabel setFont:[UIFont systemFontOfSize:16]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(StoreOwnedServiceModel *)model {
    if (model) {
        [self.cellImageView setImageWithURL:model.imageUrl];
        [self.titleLabel setText:model.serviceName];
        [self.priceView setPrice:model.price];
    }
}

+ (CGFloat)cellHeight {
    return 190;
}

@end
