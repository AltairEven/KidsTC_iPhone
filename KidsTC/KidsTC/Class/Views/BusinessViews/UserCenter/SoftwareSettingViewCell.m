//
//  SoftwareSettingViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "SoftwareSettingViewCell.h"

@interface SoftwareSettingViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation SoftwareSettingViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)resetWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle showArrow:(BOOL)bShow {
    [self.mainTitleLabel setText:mainTitle];
    if ([subTitle length] > 0) {
        [self.subTitleLabel setHidden:NO];
        [self.subTitleLabel setText:subTitle];
    } else {
        [self.subTitleLabel setHidden:YES];
    }
    [self.arrowImageView setHidden:!bShow];
}


+ (CGFloat)cellHeight {
    return 44;
}

@end
