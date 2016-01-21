//
//  StoreDetailStrategyCell.m
//  KidsTC
//
//  Created by Altair on 1/20/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "StoreDetailStrategyCell.h"

@interface StoreDetailStrategyCell ()

@property (weak, nonatomic) IBOutlet UIView *contentBGView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIView *descriptionBGView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *editorLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;

@end

@implementation StoreDetailStrategyCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.contentBGView bringSubviewToFront:self.descriptionBGView];
    
    self.recommendLabel.layer.cornerRadius = 3;
    self.recommendLabel.layer.masksToBounds = YES;
    self.recommendLabel.layer.borderColor = [[KTCThemeManager manager] defaultTheme].highlightTextColor.CGColor;
    self.recommendLabel.layer.borderWidth = 1;
    [self.recommendLabel setTextColor:[[KTCThemeManager manager] defaultTheme].highlightTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configWithItemModel:(StoreRelatedStrategyModel *)model {
    //image view
    NSArray *constraintsArray = [self.cellImageView constraints];
    for (NSLayoutConstraint *constraint in constraintsArray) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = model.imageRatio * SCREEN_WIDTH;
            break;
        }
    }
    [self.cellImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_BIG];
    [self.titleLabel setText:model.title];
    [self.editorLabel setText:model.author];
    [self.viewCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.viewCount]];
    [self.commentCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.commentCount]];
    [self.hotImageView setHidden:!model.isHot];
    [self.recommendLabel setHidden:!model.isRecommend];
}

@end
