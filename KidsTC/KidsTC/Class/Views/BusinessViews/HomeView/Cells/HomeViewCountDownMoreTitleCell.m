//
//  HomeViewCountDownMoreTitleCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewCountDownMoreTitleCell.h"


@interface HomeViewCountDownMoreTitleCell ()
@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *countDownBGView;
@property (weak, nonatomic) IBOutlet UILabel *countdownDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, strong) ATCountDown *countDownTimer;

@property (nonatomic, assign) BOOL hasStartCountDown;

@end

@implementation HomeViewCountDownMoreTitleCell

- (void)awakeFromNib {
    // Initialization code
    self.countDownBGView.layer.borderWidth = 0.5;
    self.countDownBGView.layer.borderColor = [[KTCThemeManager manager] defaultTheme].globalThemeColor.CGColor;
    self.countDownBGView.layer.cornerRadius = 3;
    self.countDownBGView.layer.masksToBounds = YES;
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.tagView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    
    [self.hourLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.minuteLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.secondLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    
    [self.titleLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeCountDownMoreTitleCellModel *)model {
    if (model) {
        [self.titleLabel setText:model.mainTitle];
        [self.countdownDesLabel setText:model.countdownDes];
        [self.subTitleLabel setText:model.subTitle];
        [self setLeftTime:model.timeLeft];
    }
}

- (void)setLeftTime:(NSTimeInterval)leftTime {
    if (!self.hasStartCountDown) {
        self.hasStartCountDown = YES;
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


- (void)stopCountDown {
    [self.countDownTimer stopCountDown];
    self.hasStartCountDown = NO;
}

@end
