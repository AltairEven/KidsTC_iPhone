//
//  NotificationCenterViewCell.m
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NotificationCenterViewCell.h"

@interface NotificationCenterViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation NotificationCenterViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(PushNotificationModel *)model {
    [self.titleLabel setText:model.title];
    [self.timeLabel setText:model.createTimeDescription];
    [self.contentLabel setText:model.content];
    if (model.status == PushNotificationStatusHasRead) {
        [self.bgView setAlpha:0.5];
    } else {
        [self.bgView setAlpha:1];
    }
}

@end
