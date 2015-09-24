//
//  HomeViewThemeCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewThemeCell;

@protocol HomeViewThemeCellDelegate <NSObject>

- (void)homeViewThemeCell:(HomeViewThemeCell *)themeCell didSelectedItemAtIndex:(NSUInteger)index;

@end

@interface HomeViewThemeCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewThemeCellDelegate> delegate;

@property (nonatomic, assign) CGFloat ratio;

@property (nonatomic, strong) NSArray *imageUrlsArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
