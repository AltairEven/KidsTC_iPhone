/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：WelcomeView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：5/28/13
 */

#import "WelcomeView.h"
@interface WelcomeView()
@property (nonatomic, strong)UIImageView  *bgImageView;
@end
@implementation WelcomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        [self addSubview:_bgScrollView];
        [self sendSubviewToBack:_bgScrollView];
        
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        [_bgScrollView addSubview:_bgImageView];
        self.cycledScroll = NO;
        self.pagesView.bounces = NO;
        self.pagesView.alwaysBounceHorizontal = NO;
        self.pagesView.alwaysBounceVertical = NO;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pageCtrl.frame = CGRectMake(0, self.frame.size.height - 50, [UIScreen mainScreen].bounds.size.width, 16);
    self.pagesView.frame = self.bounds;
}

- (BOOL)autoScrollBG
{
     /*背景图片需要跟着页面滑动，条件：背景图片比屏幕宽*/
    return (_viewsCount>1 && self.bgImageView.frame.size.width > self.bgScrollView.frame.size.width);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setCurrentPageIndex:(NSUInteger)index
{
    if (_curPageIndex != index && index < _viewsCount)
    {
        [super setCurrentPageIndex:index];
        
        if (self.welcomeDelegate != nil && [self.welcomeDelegate respondsToSelector:@selector(welcomeView:didShowPageIndex:)])
        {
            [self.welcomeDelegate welcomeView:self didShowPageIndex:(int)index];
        }
    }
}
- (void)setBgImage:(UIImage *)image
{
//    if (image)
//    {
        /*将图片大小适配当前屏幕高度*/
//        CGSize size = image.size;
//        float width = self.frame.size.height / size.height * size.width;
//        CGRect aRect = self.bgImageView.frame;
//        aRect.size.width = width;
//        self.bgImageView.frame = aRect;
//        self.bgScrollView.contentSize = CGSizeMake(width, self.bgScrollView.frame.size.height);
//    }
//    self.bgImageView.center = self.center
    [self.bgScrollView setFrame:self.frame];
    [self.bgImageView setFrame:self.frame];
    self.bgImageView.image = image;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.pagesView]) {
        CGPoint aPoint = scrollView.contentOffset;
        /*背景图片需要跟着页面滑动，条件：背景图片比屏幕宽*/
        if (_curPageIndex==0) {
            aPoint.x += _curPageIndex *self.pagesView.frame.size.width;
        }
        else
        {
            aPoint.x += (_curPageIndex-1) *self.pagesView.frame.size.width;
        }
        if (_viewsCount>1 && self.bgImageView.frame.size.width > self.bgScrollView.frame.size.width)
        {
            
            float scanValue = (self.bgScrollView.contentSize.width-self.pagesView.frame.size.width)/((_viewsCount-1)*self.pagesView.frame.size.width);
//            NSLog(@"pW:%f, bW:%f, svanValue:%f", (_viewsCount)*self.pagesView.frame.size.width,self.bgScrollView.contentSize.width, scanValue);
//            NSLog(@"aPoint_x:%f, bg_X:%f, svanValue:%f", aPoint.x,aPoint.x * scanValue, scanValue);
            aPoint.x = aPoint.x * scanValue;
            self.bgScrollView.contentOffset = aPoint;
        }
    }
    [super scrollViewDidScroll:scrollView];
}
@end
