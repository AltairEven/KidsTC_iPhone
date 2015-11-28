//
//  NewsListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "NewsListViewCell.h"

@interface NewsListViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation NewsListViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    self.tagLabel.layer.cornerRadius = 3;
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.borderColor = [AUITheme theme].globalThemeColor.CGColor;
    self.tagLabel.layer.borderWidth = BORDER_WIDTH;
    [self.tagLabel setTextColor:[AUITheme theme].globalThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(NewsListItemModel *)model {
    if (model) {
        [self.newsImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.titleLabel setText:model.title];
        if (model.type == NewsTypeTopic) {
            [self.tagLabel setHidden:NO];
            [self.tagLabel setText:@" 话题 "];
            self.leftMargin.constant = 10;
        } else {
            [self.tagLabel setHidden:YES];
            [self.tagLabel setText:@""];
            self.leftMargin.constant = 0;
        }
        [self.viewCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.viewCount]];
        [self.commentCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.commentCount]];
    }
}


+ (CGFloat)cellHeight {
    return 100;
}

@end
