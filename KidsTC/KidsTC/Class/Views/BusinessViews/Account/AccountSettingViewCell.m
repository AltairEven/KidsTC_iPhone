//
//  AccountSettingViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "AccountSettingViewCell.h"

@interface AccountSettingViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation AccountSettingViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.cellImageView setHidden:YES];
    [self.subTitleLabel setHidden:YES];
    
    self.cellImageView.layer.cornerRadius = self.cellImageView.frame.size.width / 2;
    self.cellImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle showImage:(BOOL)showImage showArrow:(BOOL)showArrow {
    [self.mainTitleLabel setText:mainTitle];
    [self.arrowImageView setHidden:!showArrow];
    if (showImage) {
        [self.cellImageView setHidden:NO];
        [self.subTitleLabel setHidden:YES];
        if (self.cellImageUrl) {
            [self.cellImageView setImageWithURL:self.cellImageUrl placeholderImage:[UIImage imageNamed:@"userCenter_defaultFace"]];
        } else {
            [self.cellImageView setImage:[UIImage imageNamed:@"userCenter_defaultFace"]];
        }
        return;
    }  else {
        [self.cellImageView setHidden:YES];
    }
    if ([subTitle length] > 0) {
        [self.subTitleLabel setHidden:NO];
        [self.subTitleLabel setText:subTitle];
    } else {
        [self.subTitleLabel setHidden:YES];
    }
}


+ (CGFloat)normalCellHeight {
    return 44;
}

+ (CGFloat)imageCellHeight {
    return 80;
}

@end
