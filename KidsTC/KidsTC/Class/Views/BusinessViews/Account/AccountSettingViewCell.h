//
//  AccountSettingViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSettingViewCell : UITableViewCell

- (void)resetWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle;

+ (CGFloat)cellHeight;

@end
