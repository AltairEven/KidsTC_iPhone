/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GScrollPageView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：12/24/12
 */

#import "GScrollPageView.h"

@implementation GScrollPageView
@synthesize pagesView;
@synthesize pageCtrl;
@synthesize cycledScroll = _cycledScroll;
@synthesize dataSource = _dataSource;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self internalInitWithFrame:self.frame];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self internalInitWithFrame:frame];
    }
    
    return self;
}

- (void)internalInitWithFrame:(CGRect)frame
{
    CGRect aRect = frame;
    float pageCtrlHeight = 16;
    /*Scroll view.*/
    @autoreleasepool {
        
        _validPages = [[NSMutableArray alloc] initWithCapacity:2];
        
        self.pagesView = [[GScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(aRect), CGRectGetHeight(aRect))];
        self.pagesView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.pagesView.showsVerticalScrollIndicator = NO;
        self.pagesView.showsHorizontalScrollIndicator = NO;
        self.pagesView.bounces = NO;
        self.pagesView.pagingEnabled = YES;
        self.pagesView.delegate = self;
        self.pagesView.scrollsToTop = NO;
        self.pagesView.clipsToBounds = NO;
        [self addSubview:self.pagesView];
        
        /*Page control*/
        aRect = CGRectMake(0.0, self.pagesView.frame.size.height, frame.size.width, pageCtrlHeight);
        aRect.size.height = pageCtrlHeight;
        self.pageCtrl = [[GPageControl alloc] initWithFrame:aRect activeImg:[UIImage imageNamed:@"carousel bar_white.png"] andInacticeImg:[UIImage imageNamed:@"carousel bar_black.png"]];
        [self.pageCtrl addTarget:self action:@selector(pageCtrlPageChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageCtrl];
    }
    
    _cycledScroll = NO;
    _curPageIndex = -1;
}

- (void)dealloc
{
    self.pagesView.delegate = nil;
}

- (void)setCycledScroll:(BOOL)value
{
    _cycledScroll = value;
    self.pagesView.bounces = YES;
}

- (void)setpageViews:(NSArray *)theViews
{
    _validPages = [[NSMutableArray alloc] initWithArray:theViews];
}

- (int)validPageIndex:(NSInteger)index
{
    int valiadIndex = (int)index;
    if (-1 == index) {
        valiadIndex = (int)(_viewsCount-1);
    }
    if (index == _viewsCount) {
        valiadIndex = 0;
    }
    
    return valiadIndex;
}

- (UIView *)pageOfIndex:(NSUInteger)index
{
    NSInteger aPageIndex = index;
    if (_cycledScroll) {
        aPageIndex = [self validPageIndex:index];
    }
    
    UIView *aPage = nil;
    if (aPageIndex  < [_validPages count]) {
        aPage = [_validPages objectAtIndex:aPageIndex];
    }
    else if (aPageIndex < _viewsCount){
        if (self.dataSource != nil) {
            aPage = [self.dataSource pageOfScrollView:self ofPage:aPageIndex];
            CGRect aRect = CGRectMake(0.0, 0.0, self.pagesView.bounds.size.width, self.pagesView.bounds.size.height);
            aPage.frame = aRect;
            [_validPages addObject:aPage];
        }
    }
    
    return aPage;
}

- (void)setCurrentPageIndex:(NSUInteger)index
{
    if (_curPageIndex != index && index < _viewsCount) {

        _curPageIndex = index;
        NSArray *subViews = [self.pagesView subviews];
        if([subViews count] != 0)  
        {          
            [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];  
        }
        
        UIView *prePage = nil;
        UIView *curPage = nil;
        UIView *sufPage = nil;
        for (NSInteger i = [_validPages count]; i< index+1; i++) {
            /*取validPage 至下一页位置*/
            [self pageOfIndex:i];
        }
        
        if (_viewsCount == 1)
        {
            curPage = [self pageOfIndex:index];
            CGRect aRect = CGRectMake(0.0, 0.0, self.pagesView.bounds.size.width, self.pagesView.bounds.size.height);
            curPage.frame = aRect;
        }
        else
        {
            /*取前一页*/
            NSInteger prePageIndex = index-1;
            NSInteger sufPageIndex = index+1;
            if (_cycledScroll) {
                prePageIndex = [self validPageIndex:prePageIndex];
                sufPageIndex = [self validPageIndex:sufPageIndex];
            }
            if(prePageIndex != -1)
            {
                prePage = [self pageOfIndex:prePageIndex];
            }
            curPage = [self pageOfIndex:index];
            if (prePageIndex == sufPageIndex) {
                sufPage = [prePage duplicateView];
            }
            else {
                sufPage = [self pageOfIndex:sufPageIndex];
            }
            
            CGRect aRect = CGRectMake(0.0, 0.0, self.pagesView.bounds.size.width, self.pagesView.bounds.size.height);
            prePage.frame = aRect;
            aRect.origin.x += prePage.frame.size.width;
            curPage.frame = aRect;
            aRect.origin.x += curPage.frame.size.width;
            sufPage.frame = aRect;
        }
        
        if (prePage) {
            [self.pagesView addSubview:prePage];
        }
        if (curPage) {
            [self.pagesView addSubview:curPage];
        }
        if (sufPage) {
            [self.pagesView addSubview:sufPage];
        }
        
        [self.pagesView setContentSize:CGSizeMake(prePage.frame.origin.x + prePage.frame.size.width + curPage.frame.size.width + sufPage.frame.size.width, self.pagesView.bounds.size.height)];
        [self.pagesView setContentOffset:CGPointMake(prePage.frame.origin.x +prePage.frame.size.width, 0)];
        
        self.pageCtrl.currentPage = _curPageIndex;
        [self.pagesView bringSubviewToFront:self.pageCtrl];
    }
}

- (void)pageCtrlPageChanged:(id)sender
{
    NSInteger pageIndex = self.pageCtrl.currentPage;
    [self setCurrentPageIndex:pageIndex];
}

- (void)reloadPages
{
    if (self.dataSource) {
        _viewsCount = [self.dataSource numberOfPage:self];
        self.pageCtrl.numberOfPages = _viewsCount;
        _curPageIndex = -1;
        [_validPages removeAllObjects];
        
        /*如果时循环模式，一次性加载所有页面*/
        if (self.cycledScroll)
        {
            for (int aPageIndex = 0; aPageIndex < _viewsCount; aPageIndex++)
            {
                UIView *aPage = [self.dataSource pageOfScrollView:self ofPage:aPageIndex];
                CGRect aRect = CGRectMake(0.0, 0.0, self.pagesView.bounds.size.width, self.pagesView.bounds.size.height);
                aPage.frame = aRect;
                [_validPages addObject:aPage];
            }
        }
        
        [self setCurrentPageIndex:0];
        
        /*当仅有一个Page时，隐藏PageCtrl*/
        self.pageCtrl.hidden = (1 == _viewsCount);
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint aPoint = scrollView.contentOffset;
    if (aPoint.x >= 2* self.pagesView.frame.size.width) {
        NSInteger sufIndex = _curPageIndex+1;
        
        [self setCurrentPageIndex:[self validPageIndex:sufIndex]];
    }
    else if(aPoint.x <= 0)
    {
        NSInteger preIndex = _curPageIndex-1;
        if (_cycledScroll) {
            preIndex = [self validPageIndex:preIndex];
        }
        [self setCurrentPageIndex:preIndex];
    }
    else if(!_cycledScroll && [_validPages count] == 2 && aPoint.x > 0 && aPoint.x < 2* self.pagesView.frame.size.width){
        //仅有两个页面时特殊处理pageindex.
        if (aPoint.x == 0 || aPoint.x ==self.pagesView.frame.size.width) {
            
            [self setCurrentPageIndex:aPoint.x/self.pagesView.frame.size.width];
        }
        
    }
    else if (!_cycledScroll && _curPageIndex ==0)
    {
        if (aPoint.x >= self.pagesView.frame.size.width) {
            NSInteger sufIndex = _curPageIndex+1;
            [self setCurrentPageIndex:[self validPageIndex:sufIndex]];
        }
    }
}

@end

@implementation UIView(Duplicate)
- (id)duplicateView
{
    UIView * newView = [[UIView alloc] initWithFrame:self.frame];
    
    return newView;
}
@end
