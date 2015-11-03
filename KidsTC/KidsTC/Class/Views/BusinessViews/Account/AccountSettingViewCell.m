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
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation AccountSettingViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle {
    [self.mainTitleLabel setText:mainTitle];
    if ([subTitle length] > 0) {
        [self.arrowImageView setHidden:NO];
        [self.subTitleLabel setHidden:NO];
        [self.subTitleLabel setText:subTitle];
    } else {
        [self.arrowImageView setHidden:YES];
        [self.subTitleLabel setHidden:YES];
    }
}


+ (CGFloat)cellHeight {
    return 44;
}

@end
