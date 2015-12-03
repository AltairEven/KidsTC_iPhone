//
//  FavouriteViewStoreCell.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "FavouriteViewStoreCell.h"
#import "FiveStarsView.h"

@interface FavouriteViewStoreCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation FavouriteViewStoreCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    self.cellImageView.layer.cornerRadius = 5;
    self.cellImageView.layer.masksToBounds = YES;
    
    [self.distanceLabel setTextColor:[AUITheme theme].highlightTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(FavouriteStoreItemModel *)model {
    if (model) {
        [self.cellImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.titleLabel setText:model.name];
        [self.starsView setStarNumber:model.starNumber];
        [self.distanceLabel setText:model.distanceDescription];
    }
}

+ (CGFloat)cellHeight {
    return 100;
}

@end
