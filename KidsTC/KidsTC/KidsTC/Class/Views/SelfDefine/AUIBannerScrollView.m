//
//  AUIBannerScrollView.m
//  KidsTC
//
//  Created by 钱烨 on 7/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AUIBannerScrollView.h"


@interface AUIBannerScrollView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, assign) NSUInteger pageNumber;

@property (nonatomic, strong) NSArray *imageViewsArray;

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, assign) BOOL resettingView;

@property (nonatomic, strong) NSTimer *autoPlayTimer;

- (void)didClickedImage:(id)sender;

- (void)createUnrecyclableView;

- (void)createRecyclableView;

- (void)resetRecyclableScrollViewWithTargetContenOffset:(CGPoint)contentOffset;

- (void)resetCurrentPageIndex:(NSUInteger)index;

- (void)resetImageForIndex:(NSUInteger)iIndex withPageIndex:(NSUInteger)pIndex;

- (void)createAutoPlayTimer;

- (void)destoryAutoPlayTimer;

- (void)autoPlayTimerAlert:(id)sender;

@end

@implementation AUIBannerScrollView


#pragma mark Initialization

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        AUIBannerScrollView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    self.showPageIndex = YES;
}

- (void)reloadData {
    [self.pageControl setHidden:!self.showPageIndex];
    [self destoryAutoPlayTimer];
    if (self.recyclable) {
        [self createRecyclableView];
    } else {
        [self createUnrecyclableView];
    }
}


- (void)didClickedImage:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSUInteger index = tap.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(auiBannerScrollView:didClickedAtIndex:)]) {
        [self.delegate auiBannerScrollView:self didClickedAtIndex:index];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (self.resettingView || self.pageNumber <= 1) {
            //正在设置视图，或者总的页面数量小于等于1，则直接return
            return;
        }
        [self resetRecyclableScrollViewWithTargetContenOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.scrollView) {
        if (self.recyclable) {
            CGPoint offset = *targetContentOffset;
            [self resetRecyclableScrollViewWithTargetContenOffset:offset];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self destoryAutoPlayTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self createAutoPlayTimer];
        if (!self.recyclable) {
            CGFloat offset = self.scrollView.contentOffset.x;
            NSUInteger index = offset / self.scrollView.frame.size.width;
            [self.pageControl setCurrentPage:index];
            if (self.delegate && [self.delegate respondsToSelector:@selector(auiBannerScrollView:didScrolledToIndex:)]) {
                [self.delegate auiBannerScrollView:self didScrolledToIndex:index];
            }
        }
    }
}

#pragma mark Private methods

- (void)createUnrecyclableView {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(numberOfBannersOnScrollView:)]) {
            self.pageNumber = [self.dataSource numberOfBannersOnScrollView:self];
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.pageNumber, 0);
            self.scrollView.contentOffset = CGPointMake(0, 0);
            [self.pageControl setNumberOfPages:self.pageNumber];
            if (self.showPageIndex) {
                if (self.pageNumber <= 1) {
                    [self.pageControl setHidden:YES];
                } else {
                    [self.pageControl setHidden:NO];
                }
                [self.pageControl setCurrentPage:0];
            }
        }
        self.viewHeight = self.frame.size.height;
        if ([self.dataSource respondsToSelector:@selector(heightForBannerScrollView:)]) {
            self.viewHeight = [self.dataSource heightForBannerScrollView:self];
        } else {
            for (NSLayoutConstraint *constraint in self.constraints) {
                if ([constraint.firstItem isKindOfClass:[self class]] && constraint.firstAttribute == NSLayoutAttributeHeight) {
                    self.viewHeight = constraint.constant;
                    break;
                }
            }
        }
        if ([self.dataSource respondsToSelector:@selector(bannerImageViewOnScrollView:withViewFrame:atIndex:)]) {
            //clear first
            for (UIView *subview in self.scrollView.subviews) {
                [subview removeFromSuperview];
            }
            //add
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            CGFloat xPosition = 0;
            for (NSUInteger index = 0; index < self.pageNumber; index ++) {
                xPosition = index * SCREEN_WIDTH;
                CGRect frame = CGRectMake(xPosition, 0, SCREEN_WIDTH, self.viewHeight);
                UIImageView *imageView = [self.dataSource bannerImageViewOnScrollView:self withViewFrame:frame atIndex:index];
                imageView.tag = index;
                if (imageView) {
                    if (self.enableClicking) {
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedImage:)];
                        imageView.userInteractionEnabled = YES;
                        [imageView addGestureRecognizer:tap];
                    }
                    [tempArray addObject:imageView];
                    [self.scrollView addSubview:imageView];
                }
            }
            self.imageViewsArray = [NSArray arrayWithArray:tempArray];
            [self createAutoPlayTimer];
        }
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
    self.resettingView = YES;
}

#pragma mark Recycle

- (void)createRecyclableView {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(numberOfBannersOnScrollView:)]) {
            self.pageNumber = [self.dataSource numberOfBannersOnScrollView:self];
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.pageNumber, 0);
            self.scrollView.contentOffset = CGPointMake(0, 0);
            [self.pageControl setNumberOfPages:self.pageNumber];
            if (self.showPageIndex) {
                if (self.pageNumber <= 1) {
                    [self.pageControl setHidden:YES];
                } else {
                    [self.pageControl setHidden:NO];
                }
                [self.pageControl setCurrentPage:0];
            }
        }
        self.viewHeight = self.frame.size.height;
        if ([self.dataSource respondsToSelector:@selector(heightForBannerScrollView:)]) {
            self.viewHeight = [self.dataSource heightForBannerScrollView:self];
        } else {
            for (NSLayoutConstraint *constraint in self.constraints) {
                if ([constraint.firstItem isKindOfClass:[self class]] && constraint.firstAttribute == NSLayoutAttributeHeight) {
                    self.viewHeight = constraint.constant;
                    break;
                }
            }
        }
        if ([self.dataSource respondsToSelector:@selector(bannerImageViewOnScrollView:withViewFrame:atIndex:)]) {
            //clear first
            for (UIView *subview in self.scrollView.subviews) {
                [subview removeFromSuperview];
            }
            
            if (self.pageNumber < 1) {
                //no image view
                return;
            } else if (self.pageNumber == 1) {
                //one image view
                UIImageView *imageView = [self.dataSource bannerImageViewOnScrollView:self withViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.viewHeight) atIndex:0];
                imageView.tag = 0;
                if (imageView) {
                    if (self.enableClicking) {
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedImage:)];
                        imageView.userInteractionEnabled = YES;
                        [imageView addGestureRecognizer:tap];
                    }
                    [self.scrollView addSubview:imageView];
                    self.imageViewsArray = [NSArray arrayWithObject:imageView];
                }
            } else {
                //add 3 imageviews, last first and second
                //last
                CGFloat xPosition = 0;
                NSUInteger index = self.pageNumber - 1;
                CGRect frame = CGRectMake(xPosition, 0, SCREEN_WIDTH, self.viewHeight);
                UIImageView *imageView1 = [self.dataSource bannerImageViewOnScrollView:self withViewFrame:frame atIndex:index];
                imageView1.tag = index;
                if (imageView1) {
                    if (self.enableClicking) {
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedImage:)];
                        imageView1.userInteractionEnabled = YES;
                        [imageView1 addGestureRecognizer:tap];
                    }
                    [self.scrollView addSubview:imageView1];
                }
                //first
                xPosition = SCREEN_WIDTH;
                index = 0;
                frame = CGRectMake(xPosition, 0, SCREEN_WIDTH, self.viewHeight);
                UIImageView *imageView2 = [self.dataSource bannerImageViewOnScrollView:self withViewFrame:frame atIndex:index];
                imageView2.tag = index;
                if (imageView2) {
                    if (self.enableClicking) {
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedImage:)];
                        imageView2.userInteractionEnabled = YES;
                        [imageView2 addGestureRecognizer:tap];
                    }
                    [self.scrollView addSubview:imageView2];
                }
                //second
                xPosition = SCREEN_WIDTH * 2;
                index = 1;
                frame = CGRectMake(xPosition, 0, SCREEN_WIDTH, self.viewHeight);
                UIImageView *imageView3 = [self.dataSource bannerImageViewOnScrollView:self withViewFrame:frame atIndex:index];
                imageView3.tag = index;
                if (imageView3) {
                    if (self.enableClicking) {
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedImage:)];
                        imageView3.userInteractionEnabled = YES;
                        [imageView3 addGestureRecognizer:tap];
                    }
                    [self.scrollView addSubview:imageView3];
                }
                self.imageViewsArray = [NSArray arrayWithObjects:imageView1, imageView2, imageView3, nil];
                //reset contentOffset
                self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
                [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, self.scrollView.contentOffset.y)];
                self.pageIndex = 0;
                [self.pageControl setCurrentPage:0];
                //auto play timer
                [self createAutoPlayTimer];
            }
        }
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
    self.resettingView = NO;
}

- (void)resetRecyclableScrollViewWithTargetContenOffset:(CGPoint)contentOffset {
    if (!self.recyclable) {
        return;
    }
    NSInteger index = 0;
    CGPoint currentOffset = self.scrollView.contentOffset;
    //循环
    if (contentOffset.x >= SCREEN_WIDTH * 2) {
        self.resettingView = YES;
        //向左
        index = self.pageIndex + 1;
        if (index > self.pageNumber - 1) {
            index = 0;
        }
        //reset content offset
        [self.scrollView setContentOffset:CGPointMake(currentOffset.x - SCREEN_WIDTH, currentOffset.y)];
        [self resetImageForIndex:index withPageIndex:1];
        //reset beside page
        NSInteger preIndex = self.pageIndex;
        NSInteger nextIndex = index + 1;
        if (nextIndex > self.pageNumber - 1) {
            nextIndex = 0;
        }
        [self resetImageForIndex:preIndex withPageIndex:0];
        [self resetImageForIndex:nextIndex withPageIndex:2];
        [self resetCurrentPageIndex:index];
        self.resettingView = NO;
    } else if (contentOffset.x <= 0) {
        self.resettingView = YES;
        //向右
        index = self.pageIndex - 1;
        if (index < 0) {
            index = self.pageNumber - 1;
        }
        //reset content offset
        [self.scrollView setContentOffset:CGPointMake(currentOffset.x + SCREEN_WIDTH, currentOffset.y)];
        [self resetImageForIndex:index withPageIndex:1];
        //reset beside page
        NSInteger preIndex = index - 1;
        if (preIndex < 0) {
            preIndex = self.pageNumber - 1;
        }
        NSInteger nextIndex = self.pageIndex;
        [self resetImageForIndex:preIndex withPageIndex:0];
        [self resetImageForIndex:nextIndex withPageIndex:2];
        [self resetCurrentPageIndex:index];
        self.resettingView = NO;
    }
}

- (void)resetCurrentPageIndex:(NSUInteger)index {
    self.pageIndex = index;
    if (self.showPageIndex) {
        [self.pageControl setCurrentPage:index];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(auiBannerScrollView:didScrolledToIndex:)]) {
        [self.delegate auiBannerScrollView:self didScrolledToIndex:index];
    }
}

- (void)resetImageForIndex:(NSUInteger)iIndex withPageIndex:(NSUInteger)pIndex {
    if (self.dataSource) {
        UIImage *image = nil;
        if ([self.dataSource respondsToSelector:@selector(bannerImageForScrollView:atIndex:)]) {
            image = [self.dataSource bannerImageForScrollView:self atIndex:iIndex];
        }
        BOOL needUrl = NO;
        if (!image || ![image isKindOfClass:[UIImage class]]) {
            //没有图片，或者非图片对象，则再读取URL
            needUrl = YES;
        }
        NSURL *imageUrl = nil;
        if (needUrl == YES && [self.dataSource respondsToSelector:@selector(bannerImageUrlForScrollView:atIndex:)]) {
            imageUrl = [self.dataSource bannerImageUrlForScrollView:self atIndex:iIndex];
        }
        if (needUrl && (!imageUrl || ![imageUrl isKindOfClass:[NSURL class]])) {
            //没有图片，没有图片URL，或者非图片URL对象
            return;
        }
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:pIndex];
        imageView.tag = iIndex;
        if (needUrl) {
            [imageView setImageWithURL:imageUrl];
        } else if (image && [image isKindOfClass:[UIImage class]]) {
            [imageView setImage:image];
        }
    }
}

#pragma mark Timer

- (void)createAutoPlayTimer {
    if (self.autoPlayDuration == 0 || self.pageNumber <= 1) {
        return;
    }
    if (!self.autoPlayTimer) {
        self.autoPlayTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoPlayDuration target:self selector:@selector(autoPlayTimerAlert:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.autoPlayTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:self.autoPlayTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)destoryAutoPlayTimer {
    if (self.autoPlayTimer) {
        [self.autoPlayTimer invalidate];
        self.autoPlayTimer = nil;
    }
}

- (void)autoPlayTimerAlert:(id)sender {
    if (self.recyclable) {
        CGPoint currentOffset = self.scrollView.contentOffset;
        [self.scrollView setContentOffset:CGPointMake(currentOffset.x + SCREEN_WIDTH, currentOffset.y) animated:YES];
    } else {
        CGPoint currentOffset = self.scrollView.contentOffset;
        CGPoint nextOffset = currentOffset;
        if (currentOffset.x >= SCREEN_WIDTH * (self.pageNumber - 1)) {
            nextOffset.x = 0;
        } else {
            nextOffset.x = currentOffset.x + SCREEN_WIDTH;
        }
        [self.scrollView setContentOffset:CGPointMake(nextOffset.x, currentOffset.y) animated:YES];
        
        NSUInteger index = nextOffset.x / self.scrollView.frame.size.width;
        [self resetCurrentPageIndex:index];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
