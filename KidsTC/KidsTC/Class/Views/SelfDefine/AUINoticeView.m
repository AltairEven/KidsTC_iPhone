//
//  AUINoticeView.m
//  KidsTC
//
//  Created by Altair on 12/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "AUINoticeView.h"

@interface AUINoticeView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) NSUInteger pageNumber;

@property (nonatomic, strong) NSArray *labelsArray;

@property (nonatomic, assign) CGSize viewSize;

@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, assign) BOOL resettingView;

@property (nonatomic, strong) NSTimer *autoPlayTimer;

- (void)didClickedLabel:(id)sender;

- (void)createRecyclableView;

- (void)createRecyclableSubViews;

- (UILabel *)createLabelWithFrame:(CGRect)frame andIndex:(NSUInteger)index;

- (void)resetRecyclableScrollViewWithTargetContenOffset:(CGPoint)contentOffset;

- (void)resetCurrentPageIndex:(NSUInteger)index;

- (void)resetLabelForNoticeIndex:(NSUInteger)nIndex withPageIndex:(NSUInteger)pIndex;

- (void)createAutoPlayTimer;

- (void)destoryAutoPlayTimer;

- (void)autoPlayTimerAlert:(id)sender;

@end

@implementation AUINoticeView


#pragma mark Initialization

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        AUINoticeView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.scrollView.delegate = self;
    self.font = [UIFont systemFontOfSize:14];
    self.maxLine = 1;
    self.autoPlayDuration = 3;
    self.playDirection = AUINoticeViewPlayDirectionLeftToRight;
}

- (void)reloadData {
    [self destoryAutoPlayTimer];
    [self createRecyclableView];
}


- (void)didClickedLabel:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSUInteger index = tap.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(auiNoticeView:didClickedAtIndex:)]) {
        [self.delegate auiNoticeView:self didClickedAtIndex:index];
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
        CGPoint offset = *targetContentOffset;
        [self resetRecyclableScrollViewWithTargetContenOffset:offset];
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
    }
}

#pragma mark Private methods

- (void)createRecyclableView {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(numberOfStringsForNoticeView:)]) {
            self.pageNumber = [self.dataSource numberOfStringsForNoticeView:self];
        }
        self.viewSize = self.frame.size;
        if ([self.dataSource respondsToSelector:@selector(sizeForNoticeView:)]) {
            self.viewSize = [self.dataSource sizeForNoticeView:self];
        }
        if ([self.dataSource respondsToSelector:@selector(noticeStringForNoticeView:atIndex:)]) {
            //clear first
            for (UIView *subview in self.scrollView.subviews) {
                [subview removeFromSuperview];
            }
            
            if (self.pageNumber < 1) {
                //no label
                return;
            } else if (self.pageNumber == 1) {
                //one label
                UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height)];
                noticeLabel.tag = 0;
                [noticeLabel setFont:self.font];
                [noticeLabel setNumberOfLines:self.maxLine];
                NSString *text = [self.dataSource noticeStringForNoticeView:self atIndex:0];
                [noticeLabel setText:text];
                if (self.enableClicking) {
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedLabel:)];
                    noticeLabel.userInteractionEnabled = YES;
                    [noticeLabel addGestureRecognizer:tap];
                }
                [self.scrollView addSubview:noticeLabel];
                self.labelsArray = [NSArray arrayWithObject:noticeLabel];
                self.scrollView.contentSize = CGSizeMake(self.viewSize.width, 0);
                self.scrollView.contentOffset = CGPointMake(0, 0);
            } else {
                [self createRecyclableSubViews];
                //auto play timer
                [self createAutoPlayTimer];
            }
        }
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
    self.resettingView = NO;
}

- (void)createRecyclableSubViews {
    //add 3 imageviews, last first and second
    CGFloat xPosition = 0;
    CGFloat yPosition = 0;
    switch (self.playDirection) {
        case AUINoticeViewPlayDirectionLeftToRight:
        {
            //last
            NSUInteger index = self.pageNumber - 1;
            CGRect frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel1 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel1];
            //first
            xPosition = self.viewSize.width;
            index = 0;
            frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel2 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel2];
            //second
            xPosition = self.viewSize.width * 2;
            index = 1;
            frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel3 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel3];
            //reset contentOffset
            self.scrollView.contentSize = CGSizeMake(self.viewSize.width * 3, 0);
            [self.scrollView setContentOffset:CGPointMake(self.viewSize.width, self.scrollView.contentOffset.y)];
            
            self.labelsArray = [NSArray arrayWithObjects:noticeLabel1, noticeLabel2, noticeLabel3, nil];
        }
            break;
        case AUINoticeViewPlayDirectionRightToLeft:
        {
            //second
            NSUInteger index = 1;
            CGRect frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel1 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel1];
            //first
            xPosition = self.viewSize.width;
            index = 0;
            frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel2 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel2];
            //last
            xPosition = self.viewSize.width * 2;
            index = self.pageNumber - 1;
            frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel3 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel3];
            //reset contentOffset
            self.scrollView.contentSize = CGSizeMake(self.viewSize.width * 3, 0);
            [self.scrollView setContentOffset:CGPointMake(self.viewSize.width, self.scrollView.contentOffset.y)];
            
            self.labelsArray = [NSArray arrayWithObjects:noticeLabel1, noticeLabel2, noticeLabel3, nil];
        }
            break;
        case AUINoticeViewPlayDirectionTopToBottom:
        {
            //last
            NSUInteger index = self.pageNumber - 1;
            CGRect frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel1 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel1];
            //first
            yPosition = self.viewSize.height;
            index = 0;
            frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel2 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel2];
            //second
            yPosition = self.viewSize.height * 2;
            index = 1;
            frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel3 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel3];
            //reset contentOffset
            self.scrollView.contentSize = CGSizeMake(0, self.viewSize.height * 3);
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.viewSize.height)];
            
            self.labelsArray = [NSArray arrayWithObjects:noticeLabel1, noticeLabel2, noticeLabel3, nil];
        }
            break;
        case AUINoticeViewPlayDirectionBottomToTop:
        {
            //second
            NSUInteger index = 1;
            CGRect frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel1 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel1];
            //first
            yPosition = self.viewSize.height;
            index = 0;
            frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel2 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel2];
            //last
            yPosition = self.viewSize.height * 2;
            index = self.pageNumber - 1;
            frame = CGRectMake(xPosition, yPosition, self.viewSize.width, self.viewSize.height);
            UILabel *noticeLabel3 = [self createLabelWithFrame:frame andIndex:index];
            [self.scrollView addSubview:noticeLabel3];
            //reset contentOffset
            self.scrollView.contentSize = CGSizeMake(0, self.viewSize.height * 3);
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.viewSize.height)];
            
            self.labelsArray = [NSArray arrayWithObjects:noticeLabel1, noticeLabel2, noticeLabel3, nil];
        }
            break;
        default:
            break;
    }
    self.pageIndex = 0;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame andIndex:(NSUInteger)index {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    label.tag = index;
    [label setFont:self.font];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setNumberOfLines:self.maxLine];
    NSString *text = [self.dataSource noticeStringForNoticeView:self atIndex:index];
    [label setText:text];
    if (self.enableClicking) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedLabel:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
    }
    return label;
}

- (void)resetRecyclableScrollViewWithTargetContenOffset:(CGPoint)contentOffset {
    NSInteger index = 0;
    NSInteger preIndex = 0;
    NSInteger nextIndex = 0;
    CGPoint currentOffset = self.scrollView.contentOffset;
    CGPoint resetContentOffset = currentOffset;
    switch (self.playDirection) {
        case AUINoticeViewPlayDirectionLeftToRight:
        {
            if (contentOffset.x >= self.viewSize.width * 2) {
                self.resettingView = YES;
                //向左
                index = self.pageIndex + 1;
                if (index > self.pageNumber - 1) {
                    index = 0;
                }
                //reset content offset
                resetContentOffset = CGPointMake(currentOffset.x - self.viewSize.width, currentOffset.y);
                //reset beside page
                preIndex = self.pageIndex;
                nextIndex = index + 1;
                if (nextIndex > self.pageNumber - 1) {
                    nextIndex = 0;
                }
            } else if (contentOffset.x <= 0) {
                self.resettingView = YES;
                //向右
                index = self.pageIndex - 1;
                if (index < 0) {
                    index = self.pageNumber - 1;
                }
                //reset content offset
                resetContentOffset = CGPointMake(currentOffset.x + self.viewSize.width, currentOffset.y);
                //reset beside page
                preIndex = index - 1;
                if (preIndex < 0) {
                    preIndex = self.pageNumber - 1;
                }
                nextIndex = self.pageIndex;
            }
        }
            break;
        case AUINoticeViewPlayDirectionRightToLeft:
        {
            if (contentOffset.x >= self.viewSize.width * 2) {
                self.resettingView = YES;
                //向左
                index = self.pageIndex - 1;
                if (index < 0) {
                    index = self.pageNumber - 1;
                }
                //reset content offset
                resetContentOffset = CGPointMake(currentOffset.x - self.viewSize.width, currentOffset.y);
                //reset beside page
                preIndex = index - 1;
                if (preIndex < 0) {
                    preIndex = self.pageNumber - 1;
                }
                nextIndex = self.pageIndex;
            } else if (contentOffset.x <= 0) {
                self.resettingView = YES;
                //向右
                index = self.pageIndex + 1;
                if (index > self.pageNumber - 1) {
                    index = 0;
                }
                //reset content offset
                resetContentOffset = CGPointMake(currentOffset.x + self.viewSize.width, currentOffset.y);
                //reset beside page
                preIndex = self.pageIndex;
                nextIndex = index + 1;
                if (nextIndex > self.pageNumber - 1) {
                    nextIndex = 0;
                }
            }
        }
            break;
        case AUINoticeViewPlayDirectionTopToBottom:
        {
            if (contentOffset.y >= self.viewSize.height * 2) {
                self.resettingView = YES;
                //向上
                index = self.pageIndex + 1;
                if (index > self.pageNumber - 1) {
                    index = 0;
                }
                //reset content offset
                resetContentOffset = CGPointMake(currentOffset.x, currentOffset.y - self.viewSize.height);
                //reset beside page
                preIndex = self.pageIndex;
                nextIndex = index + 1;
                if (nextIndex > self.pageNumber - 1) {
                    nextIndex = 0;
                }
            } else if (contentOffset.y <= 0) {
                self.resettingView = YES;
                //向下
                index = self.pageIndex - 1;
                if (index < 0) {
                    index = self.pageNumber - 1;
                }
                //reset content offset
                resetContentOffset = CGPointMake(currentOffset.x, currentOffset.y + self.viewSize.height);
                //reset beside page
                preIndex = index - 1;
                if (preIndex < 0) {
                    preIndex = self.pageNumber - 1;
                }
                nextIndex = self.pageIndex;
            }
        }
            break;
        case AUINoticeViewPlayDirectionBottomToTop:
        {
            if (contentOffset.y >= self.viewSize.height * 2) {
                self.resettingView = YES;
                //向上
                index = self.pageIndex - 1;
                if (index < 0) {
                    index = self.pageNumber - 1;
                }
                //reset content offset
                resetContentOffset = CGPointMake(currentOffset.x, currentOffset.y - self.viewSize.height);
                //reset beside page
                preIndex = index - 1;
                if (preIndex < 0) {
                    preIndex = self.pageNumber - 1;
                }
                nextIndex = self.pageIndex;
            } else if (contentOffset.y <= 0) {
                self.resettingView = YES;
                //向下
                index = self.pageIndex + 1;
                if (index > self.pageNumber - 1) {
                    index = 0;
                }
                //reset content offset
                resetContentOffset = CGPointMake(currentOffset.x, currentOffset.y + self.viewSize.height);
                //reset beside page
                preIndex = self.pageIndex;
                nextIndex = index + 1;
                if (nextIndex > self.pageNumber - 1) {
                    nextIndex = 0;
                }
            }
        }
            break;
        default:
            break;
    }
    if (self.resettingView) {
        [self.scrollView setContentOffset:resetContentOffset animated:NO];
        [self resetLabelForNoticeIndex:preIndex withPageIndex:0];
        [self resetLabelForNoticeIndex:index withPageIndex:1];
        [self resetLabelForNoticeIndex:nextIndex withPageIndex:2];
        [self resetCurrentPageIndex:index];
        self.resettingView = NO;
    }
}

- (void)resetCurrentPageIndex:(NSUInteger)index {
    self.pageIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(auiNoticeView:didScrolledToIndex:)]) {
        [self.delegate auiNoticeView:self didScrolledToIndex:index];
    }
}

- (void)resetLabelForNoticeIndex:(NSUInteger)nIndex withPageIndex:(NSUInteger)pIndex {
    if (self.dataSource) {
        NSString *noticeString = @"";
        if ([self.dataSource respondsToSelector:@selector(noticeStringForNoticeView:atIndex:)]) {
            noticeString = [self.dataSource noticeStringForNoticeView:self atIndex:nIndex];
        }
        if ([noticeString length] == 0) {
            //没有通知
            return;
        }
        UILabel *noticeLabel = [self.labelsArray objectAtIndex:pIndex];
        noticeLabel.tag = nIndex;
        [noticeLabel setText:noticeString];
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
    CGPoint currentOffset = self.scrollView.contentOffset;
    switch (self.playDirection) {
        case AUINoticeViewPlayDirectionLeftToRight:
        {
            [self.scrollView setContentOffset:CGPointMake(currentOffset.x + self.viewSize.width, currentOffset.y) animated:YES];
        }
            break;
        case AUINoticeViewPlayDirectionRightToLeft:
        {
            [self.scrollView setContentOffset:CGPointMake(currentOffset.x - self.viewSize.width, currentOffset.y) animated:YES];
        }
            break;
        case AUINoticeViewPlayDirectionTopToBottom:
        {
            [self.scrollView setContentOffset:CGPointMake(currentOffset.x, currentOffset.y + self.viewSize.height) animated:YES];
        }
            break;
        case AUINoticeViewPlayDirectionBottomToTop:
        {
            [self.scrollView setContentOffset:CGPointMake(currentOffset.x, currentOffset.y - self.viewSize.height) animated:YES];
        }
            break;
        default:
            break;
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
