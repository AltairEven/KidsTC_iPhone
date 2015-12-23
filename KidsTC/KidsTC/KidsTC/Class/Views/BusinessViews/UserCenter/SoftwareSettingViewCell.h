//
//  SoftwareSettingViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoftwareSettingViewCell : UITableViewCell

- (void)resetWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle showArrow:(BOOL)bShow;

+ (CGFloat)cellHeight;

@end
