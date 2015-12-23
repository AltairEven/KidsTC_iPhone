//
//  HomeViewNewsCell.m
//  KidsTC
//
//  Created by 钱烨 on 9/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewNewsCell.h"

@interface HomeViewNewsCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

- (void)configTagLabelWithModel:(HomeNewsElement *)model;

@end

@implementation HomeViewNewsCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    self.tagLabel.layer.cornerRadius = 3;
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.borderWidth = BORDER_WIDTH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeNewsElement *)model {
    if (model) {
        [self.titleLabel setText:model.title];
        [self configTagLabelWithModel:model];
        [self.viewNumber setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.viewCount]];
        [self.commentNumber setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.commentCount]];
    }
}

- (void)configTagLabelWithModel:(HomeNewsElement *)model {
    if (model.isHot) {
        [self.tagLabel setHidden:NO];
        self.leftMargin.constant = 10;
        self.tagLabel.layer.borderColor = [AUITheme theme].globalThemeColor.CGColor;
        [self.tagLabel setTextColor:[AUITheme theme].globalThemeColor];
        [self.tagLabel setText:@" 热 "];
    } else if (model.isRecommend) {
        [self.tagLabel setHidden:NO];
        self.leftMargin.constant = 10;
        self.tagLabel.layer.borderColor = [AUITheme theme].highlightTextColor.CGColor;
        [self.tagLabel setTextColor:[AUITheme theme].highlightTextColor];
        [self.tagLabel setText:@" 推荐 "];
    } else {
        [self.tagLabel setHidden:YES];
        self.leftMargin.constant = 0;
    }
}

@end
