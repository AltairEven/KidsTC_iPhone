//
//  HomeViewCountDownTitleCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewCountDownTitleCell.h"


@interface HomeViewCountDownTitleCell ()

@property (weak, nonatomic) IBOutlet UIView *countDownBGView;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (nonatomic, strong) ATCountDown *countDownTimer;

@end

@implementation HomeViewCountDownTitleCell

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

- (void)setLeftTime:(NSTimeInterval)leftTime {
    if (!self.countDownTimer) {
        self.countDownTimer = [[ATCountDown alloc] initWithLeftTimeInterval:leftTime];
        __weak HomeViewCountDownTitleCell *weakSelf = self;
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

+ (CGFloat)cellHeight {
    return 44;
}

@end
