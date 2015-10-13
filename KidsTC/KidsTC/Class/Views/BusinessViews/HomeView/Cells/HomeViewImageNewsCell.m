//
//  HomeViewImageNewsCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewImageNewsCell.h"

@interface HomeViewImageNewsCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@end

@implementation HomeViewImageNewsCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeImageNewsElement *)model {
    if (model) {
        [self.titleLabel setText:model.title];
        [self.viewNumberLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.viewCount]];
        [self.commentNumberLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.commentCount]];
        [self.cellImageView setImageWithURL:model.imageUrl];
    }
}

@end
