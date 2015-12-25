//
//  ParentingStrategyViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyViewCell.h"
#import "RichPriceView.h"
#import "FiveStarsView.h"

@interface ParentingStrategyViewCell ()

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

@implementation ParentingStrategyViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.contentBGView bringSubviewToFront:self.descriptionBGView];
    
    self.recommendLabel.layer.cornerRadius = 3;
    self.recommendLabel.layer.masksToBounds = YES;
    self.recommendLabel.layer.borderColor = [[KTCThemeManager manager] currentTheme].highlightTextColor.CGColor;
    self.recommendLabel.layer.borderWidth = 1;
    [self.recommendLabel setTextColor:[[KTCThemeManager manager] currentTheme].highlightTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(ParentingStrategyListItemModel *)model {
    if (!model) {
        return;
    }
    //image view
    NSArray *constraintsArray = [self.cellImageView constraints];
    for (NSLayoutConstraint *constraint in constraintsArray) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = model.imageRatio * SCREEN_WIDTH;
            break;
        }
    }
    [self.cellImageView setImageWithURL:model.imageUrl];
    [self.titleLabel setText:model.title];
    [self.editorLabel setText:model.editorName];
    [self.viewCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.viewCount]];
    [self.commentCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.commentCount]];
    [self.hotImageView setHidden:!model.isHot];
    [self.recommendLabel setHidden:!model.isRecommend];
}

@end
