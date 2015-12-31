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
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.cellImageView setHidden:YES];
    [self.subTitleLabel setHidden:YES];
    
    self.cellImageView.layer.cornerRadius = self.cellImageView.frame.size.width / 2;
    self.cellImageView.layer.masksToBounds = YES;
    
    [self.cellImageView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle showImage:(BOOL)showImage showArrow:(BOOL)showArrow {
    [self.mainTitleLabel setText:mainTitle];
    if (showArrow) {
        [self.arrowImageView setHidden:NO];
        [self.subTitleLabel setTextColor:[UIColor darkGrayColor]];
    } else {
        [self.arrowImageView setHidden:YES];
        [self.subTitleLabel setTextColor:[UIColor lightGrayColor]];
    }
    if (showImage) {
        [self.cellImageView setHidden:NO];
        [self.subTitleLabel setHidden:YES];
        if (self.cellImage) {
            //优先使用本地头像
            [self.cellImageView setImage:self.cellImage];
        } else if (self.cellImageUrl) {
            //其次使用网络头像
            UIImage *placeHolder = [UIImage imageNamed:@"userCenter_defaultFace_boy"];
            if ([KTCUser currentUser].userRole.sex == KTCSexFemale) {
                placeHolder = [UIImage imageNamed:@"userCenter_defaultFace_girl"];
            }
            [self.cellImageView setImageWithURL:self.cellImageUrl placeholderImage:placeHolder];
        } else {
            //默认头像
            UIImage *defaultImage = [UIImage imageNamed:@"userCenter_defaultFace_boy"];
            if ([KTCUser currentUser].userRole.sex == KTCSexFemale) {
                defaultImage = [UIImage imageNamed:@"userCenter_defaultFace_girl"];
            }
            [self.cellImageView setImage:defaultImage];
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
