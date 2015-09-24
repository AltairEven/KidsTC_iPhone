//
//  HomeViewBannerCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewBannerCell.h"
#import "AUIBannerScrollView.h"

@interface HomeViewBannerCell () <AUIBannerScrollViewDataSource, AUIBannerScrollViewDelegate>

@property (weak, nonatomic) IBOutlet AUIBannerScrollView *bannerScrollView;

@end

@implementation HomeViewBannerCell

- (void)awakeFromNib {
    // Initialization code
    self.bannerScrollView.dataSource = self;
    self.bannerScrollView.delegate = self;
    [self.bannerScrollView setEnableClicking:YES];
    _ratio = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageUrlsArray:(NSArray *)imageUrlsArray {
    _imageUrlsArray = [NSArray arrayWithArray:imageUrlsArray];
    [self.bannerScrollView reloadData];
}

#pragma mark AUIBannerScrollViewDataSource & AUIBannerScrollViewDelegate

- (NSUInteger)numberOfBannersOnScrollView:(AUIBannerScrollView *)scrollView {
    return [self.imageUrlsArray count];
}

- (UIImageView *)bannerImageViewOnScrollView:(AUIBannerScrollView *)scrollView withViewFrame:(CGRect)frame atIndex:(NSUInteger)index {
    UIImageView *imageView = nil;
    imageView = [[UIImageView alloc] initWithFrame:frame];
    NSURL *imageUrl = [self.imageUrlsArray objectAtIndex:index];
    if (index == 1) {
        [imageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"detail_banner"]];
    } else {
        [imageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"home4"]];
    }
    return imageView;
}

- (CGFloat)heightForBannerScrollView:(AUIBannerScrollView *)scrollView {
    return self.ratio * SCREEN_WIDTH;
}

- (void)auiBannerScrollView:(AUIBannerScrollView *)scrollView didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewBannerCell:didClickedAtIndex:)]) {
        [self.delegate homeViewBannerCell:self didClickedAtIndex:index];
    }
}

@end
