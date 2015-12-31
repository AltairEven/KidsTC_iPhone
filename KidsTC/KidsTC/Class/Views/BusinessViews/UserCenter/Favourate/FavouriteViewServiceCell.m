//
//  FavouriteViewServiceCell.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "FavouriteViewServiceCell.h"
#import "FiveStarsView.h"
#import "RichPriceView.h"

@interface FavouriteViewServiceCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;

@end

@implementation FavouriteViewServiceCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    self.cellImageView.layer.cornerRadius = 5;
    self.cellImageView.layer.masksToBounds = YES;
    
    //price view
    [self.priceView setContentColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal];
    [self.priceView setUnitFont:[UIFont systemFontOfSize:16]];
    [self.priceView setPriceFont:[UIFont systemFontOfSize:20]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(FavouriteServiceItemModel *)model {
    if (model) {
        [self.cellImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.titleLabel setText:model.name];
        [self.starsView setStarNumber:model.starNumber];
        [self.priceView setPrice:model.price];
    }
}

+ (CGFloat)cellHeight {
    return 100;
}

@end
