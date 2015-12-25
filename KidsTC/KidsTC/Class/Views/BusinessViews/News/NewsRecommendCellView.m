//
//  NewsRecommendCellView.m
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendCellView.h"
#import "NewsRecommendListModel.h"
#import "NewsRecommendCellViewBigImageView.h"
#import "NewsRecommendCellViewSmallImageView.h"

@interface NewsRecommendCellView ()

- (void)didClickedAtSubview:(id)sender;

@end

@implementation NewsRecommendCellView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        NewsRecommendCellView *view = [GConfig getObjectFromNibWithView:self];
        [view setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalBGColor];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)setItemModels:(NSArray *)itemModels {
    _itemModels = [itemModels copy];
    [self buildSubviews];
}

- (void)buildSubviews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat yPosition = 0;
    if (self.itemModels) {
        for (NSUInteger index = 0; index < [self.itemModels count]; index ++) {
            UIView *view = nil;
            CGFloat viewHeight = 0;
            if (index == 0) {
                //大图
                NewsListItemModel *cellModel = [self.itemModels objectAtIndex:index];
                view = [[[NSBundle mainBundle] loadNibNamed:@"NewsRecommendCellViewBigImageView" owner:nil options:nil] objectAtIndex:0];
                [((NewsRecommendCellViewBigImageView *)view).imageView setImageWithURL:cellModel.imageUrl];
                [((NewsRecommendCellViewBigImageView *)view).titleLabel setText:cellModel.title];
                viewHeight = [((NewsRecommendCellViewBigImageView *)view) viewHeight];
                [view setFrame:CGRectMake(0, yPosition, self.frame.size.width, viewHeight)];
            } else {
                //小图
                NewsListItemModel *cellModel = [self.itemModels objectAtIndex:index];
                view = [[[NSBundle mainBundle] loadNibNamed:@"NewsRecommendCellViewSmallImageView" owner:nil options:nil] objectAtIndex:0];
                [((NewsRecommendCellViewSmallImageView *)view).imageView setImageWithURL:cellModel.imageUrl];
                [((NewsRecommendCellViewSmallImageView *)view).titleLabel setText:cellModel.title];
                viewHeight = [((NewsRecommendCellViewSmallImageView *)view) viewHeight];
                [view setFrame:CGRectMake(0, yPosition, self.frame.size.width, viewHeight)];
                if (index >= [self.itemModels count] - 1) {
                    [((NewsRecommendCellViewSmallImageView *)view).separator setHidden:YES];
                }
            }
            if (view) {
                yPosition += viewHeight;
                view.tag = index;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedAtSubview:)];
                [view addGestureRecognizer:tap];
                [self addSubview:view];
            }
        }
    }
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, yPosition)];
}

- (void)didClickedAtSubview:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsRecommendCellView:didSelectedItemAtIndex:)]) {
        NSUInteger tag = ((UITapGestureRecognizer *)sender).view.tag;
        [self.delegate newsRecommendCellView:self didSelectedItemAtIndex:tag];
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