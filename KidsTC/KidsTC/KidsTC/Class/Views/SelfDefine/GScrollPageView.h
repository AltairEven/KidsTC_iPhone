/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GScrollPageView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：12/24/12
 */

/*
 分页Scrool Page.
 */
#import <UIKit/UIKit.h>
#import "GScrollView.h"
#import "GPageControl.h"

@protocol GScrollPageViewDataSource;

@interface GScrollPageView : UIView<UIScrollViewDelegate>
{
    NSInteger _viewsCount;
    NSMutableArray *_validPages;
@public
    NSInteger _curPageIndex;
}

@property (nonatomic, strong)GScrollView *pagesView;
@property (nonatomic, strong)GPageControl *pageCtrl;
@property (nonatomic) BOOL cycledScroll;
@property (nonatomic, weak)id<GScrollPageViewDataSource> dataSource;
- (void)setpageViews:(NSArray *)theViews;
- (void)reloadPages;
- (int)validPageIndex:(NSInteger)index;
- (void)setCurrentPageIndex:(NSUInteger)index;
@end


@protocol GScrollPageViewDataSource <NSObject>
@required;
- (int)numberOfPage:(GScrollPageView *)aScrollPageView;
- (UIView *)pageOfScrollView:(GScrollPageView *)aScrollPageView ofPage:(NSInteger)pageIndex;
@end


@interface UIView(Duplicate){
}
- (id)duplicateView;
@end