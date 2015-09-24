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
@property (weak, nonatomic) IBOutlet UIView *imageFilterView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIView *descriptionBGView;
@property (weak, nonatomic) IBOutlet UIView *titleBGView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *editorBGView;
@property (weak, nonatomic) IBOutlet UILabel *editorLabel;

@end

@implementation ParentingStrategyViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.contentBGView bringSubviewToFront:self.imageFilterView];
    [self.contentBGView bringSubviewToFront:self.descriptionBGView];
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
    [self.cellImageView setImageWithURL:model.imageUrl placeholderImage:[UIImage imageNamed:@"detail_banner"]];
    //title
    [self.titleLabel setText:model.title];
    //editor
    NSString *wholeString = [NSString stringWithFormat:@"小编推荐：%@", model.editorWord];
//    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
//    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
//    [labelString setAttributes:attribute range:NSMakeRange(0, 5)];
//    
//    [self.editorLabel setAttributedText:labelString];
    
    [self.editorLabel setText:wholeString];
    
    [self.contentBGView bringSubviewToFront:self.descriptionBGView];
}

@end
