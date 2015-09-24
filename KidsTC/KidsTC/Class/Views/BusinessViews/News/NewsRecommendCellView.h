//
//  NewsRecommendCellView.h
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsRecommendCellView;

@protocol NewsRecommendCellViewDelegate <NSObject>

- (void)newsRecommendCellView:(NewsRecommendCellView *)cellView didSelectedItemAtIndex:(NSUInteger)index;

@end

@interface NewsRecommendCellView : UIView

@property (nonatomic, strong) NSArray *itemModels;

@property (nonatomic, assign) id<NewsRecommendCellViewDelegate> delegate;

@end


@interface NewsRecommendCellViewBigImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;

+ (CGFloat)cellHeight;

@end


@interface NewsRecommendCellViewSmallImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;

+ (CGFloat)cellHeight;

@end