//
//  CouponPrizeShowView.h
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-10-29.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrizeShowContentProtocol.h"

@interface CouponPrizeShowView : UIView <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *prizeBGView;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UILabel *drawMsgLabel;
@property (nonatomic, weak) id <PrizeShowContentProtocol> delegate;

- (void)setContentWithPrizeInfo:(NSDictionary *)prizeInfo;

@end
