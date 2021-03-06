//
//  NewsView.h
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsRecommendListView.h"
#import "NewsListView.h"

typedef enum {
    NewsViewTagRecommend,
    NewsViewTagMore
}NewsViewTag;

@class NewsView;

@protocol NewsViewDelegate <NSObject>

- (void)newsView:(NewsView *)newsView didClickedSegmentControlWithNewsViewTag:(NewsViewTag)viewTag;

- (void)newsView:(NewsView *)newsView didChangedNewsTagIndex:(NSUInteger)index;

- (void)newsView:(NewsView *)newsView didSelectedItem:(NewsListItemModel *)item;

- (void)newsView:(NewsView *)newsView needRefreshTableWithNewsViewTag:(NewsViewTag)viewTag tagIndex:(NSUInteger)index;

- (void)newsView:(NewsView *)newsView needLoadMoreWithNewsViewTag:(NewsViewTag)viewTag tagIndex:(NSUInteger)index;

- (void)didClickedUserRoleButton;
- (void)didClickedSearchButton;

@end

@interface NewsView : UIView

@property (nonatomic, assign) id<NewsViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet NewsRecommendListView *recommendListView;

@property (weak, nonatomic) IBOutlet NewsListView *newsListView;

@property (nonatomic, assign) NewsViewTag currentViewTag;

@property (nonatomic, readonly) NSUInteger currentNewsTagIndex;

- (void)resetRoleTypeWithImage:(UIImage *)image;

@end
