/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GBigADView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：12/24/12
 */

#import "GBigADView.h"


@implementation GBigADView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        // Initialization code
        _asc = YES;
        _scrollLock = NO;
        _touchLock = NO;
		self.pagesView.delaysContentTouches = NO;
        self.bgImgView = [[UIImageView alloc] initWithFrame:frame];
        self.bgImgView.image = LOADIMAGE(@"banner_image_loadfailed", @"png");
        self.bgImgView.hidden = YES;
        [self addSubview:self.bgImgView];
        [self sendSubviewToBack:self.bgImgView];
    }
    return self;
}

-(void) dealloc
{
    [self stopAutoScorll];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pageCtrl.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 16);
    self.pagesView.frame = self.bounds;
	self.pagesView.delaysContentTouches = NO;
}

- (void)setADData:(NSArray *)adData
{
    if(_adData != adData)
    {
        _adData = adData;
        //TODO
        //Update all the view.
    }
}

- (void)startAutoScorll
{
    _touchLock = YES;
    [self stopAutoScorll];
    int timerInterval = 3;
    _scrollTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:timerInterval] interval:timerInterval target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopAutoScorll
{
    [_scrollTimer invalidate];
    _scrollTimer = nil;
}

- (void)scrollToNextPage:(id)sender
{
    if ((!_scrollLock) && _viewsCount >1) {
        CGPoint aPoint = [self.pagesView contentOffset];
        //int nextIndex = _curPageIndex;
        
        if (!self.cycledScroll) {
            aPoint.x = self.pagesView.bounds.size.width * _curPageIndex;
            if (_curPageIndex == 0) {
                _asc = YES;
            }
            else if(_curPageIndex == _viewsCount -1) {
                _asc = NO;
            }
        }
        else {
            aPoint.x = self.pageCtrl.frame.size.width;
            _asc = YES;
        }
        
        /*滑动误差2个像素？*/
        int offsetX = (self.pagesView.bounds.size.width+2) * (_asc?1:-1);
        aPoint.x += offsetX;
        _animatedLock = YES;
        [self.pagesView setContentOffset:aPoint animated:YES];
    }
}

- (void)setCurrentPageIndex:(NSUInteger)index
{
    if (!_animatedLock) {
        [self stopAutoScorll];
        [super setCurrentPageIndex:index];
        [self startAutoScorll];
    }
}

#pragma mark -
#pragma mark GScrollPageViewDataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollLock = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _scrollLock = decelerate;
    _touchLock = decelerate;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _animatedLock = NO;
    _touchLock = NO;
    
    NSInteger nextIndex = _curPageIndex;
    if (_asc) {
        nextIndex += 1;
    }
    else {
        nextIndex -= 1;
    }
    if (self.cycledScroll) {
        nextIndex = [self validPageIndex:nextIndex];
    }
    [super setCurrentPageIndex:nextIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _scrollLock = NO;
    _touchLock = NO;
}

@end