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
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

- (void)configTagLabelWithModel:(HomeImageNewsElement *)model;

@end

@implementation HomeViewImageNewsCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    self.tagLabel.layer.cornerRadius = 3;
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.borderWidth = BORDER_WIDTH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeImageNewsElement *)model {
    if (model) {
        [self.titleLabel setText:model.title];
        [self configTagLabelWithModel:model];
        [self.viewNumberLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.viewCount]];
        [self.commentNumberLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.commentCount]];
        [self.cellImageView setImageWithURL:model.imageUrl];
    }
}

- (void)configTagLabelWithModel:(HomeImageNewsElement *)model {
    if (model.isHot) {
        [self.tagLabel setHidden:NO];
        self.leftMargin.constant = 10;
        self.tagLabel.layer.borderColor = [[KTCThemeManager manager] defaultTheme].globalThemeColor.CGColor;
        [self.tagLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
        [self.tagLabel setText:@" 热 "];
    } else if (model.isRecommend) {
        [self.tagLabel setHidden:NO];
        self.leftMargin.constant = 10;
        self.tagLabel.layer.borderColor = [[KTCThemeManager manager] defaultTheme].highlightTextColor.CGColor;
        [self.tagLabel setTextColor:[[KTCThemeManager manager] defaultTheme].highlightTextColor];
        [self.tagLabel setText:@" 推荐 "];
    } else {
        [self.tagLabel setHidden:YES];
        self.leftMargin.constant = 0;
    }
}

@end
