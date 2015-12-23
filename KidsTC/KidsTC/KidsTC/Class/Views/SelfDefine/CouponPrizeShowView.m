//
//  CouponPrizeShowView.m
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-10-29.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import "CouponPrizeShowView.h"
#import "RollConfig.h"

@implementation CouponPrizeShowView



- (void)setTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}

- (void)setDrawMsg:(NSString *)drawMsg
{
    if ([drawMsg length] == 0)
    {
        self.drawMsgLabel.hidden = YES;
    }
    else
    {
        self.drawMsgLabel.hidden = YES;
        self.drawMsgLabel.text = drawMsg;
    }
}

- (void)setContentWithPrizeInfo:(NSDictionary *)prizeInfo
{
    PrizeType prizeType = [[prizeInfo objectForKey:@"success_type"] intValue];
    NSString *drawMsg = [prizeInfo objectForKey:@"success_name"];
    NSString *prizeContent = [prizeInfo objectForKey:@"reward_detail"];
    [self.titleLabel setText:@"优惠劵稍后会发放到你的账户中！"];
    [self.drawMsgLabel setHidden:([drawMsg length] == 0 || prizeType == GoldPrizeType)];
    [self.drawMsgLabel setText:drawMsg];
    [self.contentLable setText:prizeContent];
    if (prizeType == CouponPrizeType)
    {
        [self.prizeBGView setImage:LOADIMAGE(@"ps_bg_1", @"png")];
    }
    else if (prizeType == QQPrizeType)
    {
        [self.prizeBGView setImage:LOADIMAGE(@"ps_bg_2", @"png")];
    }
    else if (prizeType == GoldPrizeType)
    {
        [self.prizeBGView setImage:LOADIMAGE(@"ps_bg_3", @"png")];
        [self.titleLabel setText:@"获得金币奖励！"];
        NSDictionary * rewardInfo = [prizeInfo objectForKey:@"reward_info"];
        if ([rewardInfo isKindOfClass:[NSDictionary class]])
        {
            int rewardId = [[rewardInfo objectForKey:@"success_type"] intValue];
            if (rewardId > 0)
            {
                self.drawMsgLabel.hidden = NO;
                [self.prizeBGView setImage:LOADIMAGE(@"ps_bg_1", @"png")];
            }
        }
    }
}

- (IBAction)closePrizeView:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(closePrizeShowContentView)])
    {
        [self.delegate closePrizeShowContentView];
    }
}

- (IBAction)sharePrize:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(prizeNeedShare)])
    {
        [self.delegate prizeNeedShare];
    }
}

@end
