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

- (void)didClickedImage:(id)sender;

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
}

- (void)reloadData {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(numberOfBannersOnScrollView:)]) {
            self.pageNumber = [self.dataSource numberOfBannersOnScrollView:self];
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.pageNumber, 0);
            self.scrollView.contentOffset = CGPointMake(0, 0);
            [self.pageControl setNumberOfPages:self.pageNumber];
            if (self.pageNumber <= 1) {
                [self.pageControl setHidden:YES];
            } else {
                [self.pageControl setHidden:NO];
            }
            [self.pageControl setCurrentPage:0];
        }
        CGFloat height = self.frame.size.height;
        if ([self.dataSource respondsToSelector:@selector(heightForBannerScrollView:)]) {
            height = [self.dataSource heightForBannerScrollView:self];
        } else {
            for (NSLayoutConstraint *constraint in self.constraints) {
                if ([constraint.firstItem isKindOfClass:[self class]] && constraint.firstAttribute == NSLayoutAttributeHeight) {
                    height = constraint.constant;
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
            NSMutableArray *viewArray = [[NSMutableArray alloc] initWithCapacity:self.pageNumber];
            CGFloat xPosition = 0;
            for (NSUInteger index = 0; index < self.pageNumber; index ++) {
                xPosition = index * SCREEN_WIDTH;
                CGRect frame = CGRectMake(xPosition, 0, SCREEN_WIDTH, height);
                UIImageView *imageView = [self.dataSource bannerImageViewOnScrollView:self withViewFrame:frame atIndex:index];
                imageView.tag = index;
                if (imageView) {
                    if (self.enableClicking) {
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedImage:)];
                        imageView.userInteractionEnabled = YES;
                        [imageView addGestureRecognizer:tap];
                    }
                    [viewArray addObject:imageView];
                    [self.scrollView addSubview:imageView];
                }
            }
            if (self.pageNumber == [viewArray count]) {
                self.imageViewsArray = [NSArray arrayWithArray:viewArray];
            }
        }
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat offset = self.scrollView.contentOffset.x;
        NSUInteger index = offset / self.scrollView.frame.size.width;
        [self.pageControl setCurrentPage:index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(auiBannerScrollView:didScrolledToIndex:)]) {
            [self.delegate auiBannerScrollView:self didScrolledToIndex:index];
        }
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
