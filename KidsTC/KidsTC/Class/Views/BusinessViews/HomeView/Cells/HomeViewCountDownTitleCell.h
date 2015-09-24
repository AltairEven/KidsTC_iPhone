//
//  HomeViewCountDownTitleCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewCountDownTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (CGFloat)cellHeight;

- (void)setLeftTime:(NSTimeInterval)leftTime;

@end
