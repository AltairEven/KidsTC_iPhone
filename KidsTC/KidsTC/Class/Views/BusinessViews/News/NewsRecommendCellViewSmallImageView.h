//
//  NewsRecommendCellViewSmallImageView.h
//  KidsTC
//
//  Created by 钱烨 on 10/15/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsRecommendCellViewSmallImageView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;

- (CGFloat)viewHeight;

@end
