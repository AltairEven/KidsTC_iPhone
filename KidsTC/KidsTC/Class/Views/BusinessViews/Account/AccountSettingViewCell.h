//
//  AccountSettingViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSettingViewCell : UITableViewCell

@property (nonatomic, strong) NSURL *cellImageUrl;

- (void)resetWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle showImage:(BOOL)showImage showArrow:(BOOL)showArrow;

+ (CGFloat)normalCellHeight;

+ (CGFloat)imageCellHeight;

@end
