//
//  HomeViewThreeCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewThreeCell;

@protocol HomeViewThreeCellDelegate <NSObject>

- (void)homeViewThreeCell:(HomeViewThreeCell *)cell didClickedAtIndex:(NSUInteger)index;

@end

@interface HomeViewThreeCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewThreeCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (nonatomic, assign) CGFloat ratio;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
