//
//  HomeViewCountDownMoreTitleCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewCountDownMoreTitleCell.h"


@interface HomeViewCountDownMoreTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *countDownBGView;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, strong) ATCountDown *countDownTimer;

@end

@implementation HomeViewCountDownMoreTitleCell

- (void)awakeFromNib {
    // Initialization code
    self.countDownBGView.layer.borderWidth = 0.5;
    self.countDownBGView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.countDownBGView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeCountDownMoreTitleCellModel *)model {
    if (model) {
        [self.titleLabel setText:model.mainTitle];
        [self.subTitleLabel setText:model.subTitle];
        [self setLeftTime:model.timeLeft];
    }
}

- (void)setLeftTime:(NSTimeInterval)leftTime {
    if (!self.countDownTimer) {
        self.countDownTimer = [[ATCountDown alloc] initWithLeftTimeInterval:leftTime];
        __weak HomeViewCountDownMoreTitleCell *weakSelf = self;
        [weakSelf.countDownTimer startCountDownWithCurrentTimeLeft:^(NSTimeInterval currentTimeLeft) {
            [weakSelf setLabelsWithTime:[GToolUtil countDownTimeStructHMSWithLeftTime2:currentTimeLeft]];
        }];
    }
}

- (void)setLabelsWithTime:(TimeStructHMS)timeStruct {
    NSString *hourString = [NSString stringWithFormat:@"%02lu", (unsigned long)(timeStruct.hour)];
    NSString *minuteString = [NSString stringWithFormat:@"%02lu", (unsigned long)(timeStruct.min)];
    NSString *secondString = [NSString stringWithFormat:@"%02lu", (unsigned long)(timeStruct.sec)];
    [self.hourLabel setText:hourString];
    [self.minuteLabel setText:minuteString];
    [self.secondLabel setText:secondString];
}

@end
