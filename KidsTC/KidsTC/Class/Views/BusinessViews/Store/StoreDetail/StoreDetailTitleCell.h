//
//  StoreDetailTitleCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreDetailTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

- (void)resetWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle;

+ (CGFloat)cellHeight;

@end
