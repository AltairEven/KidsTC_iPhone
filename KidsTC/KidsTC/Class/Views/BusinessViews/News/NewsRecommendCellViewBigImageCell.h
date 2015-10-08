//
//  NewsRecommendCellViewBigImageCell.h
//  KidsTC
//
//  Created by Qian Ye on 15/10/2.
//  Copyright © 2015年 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsRecommendCellViewBigImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;

+ (CGFloat)cellHeight;

@end
