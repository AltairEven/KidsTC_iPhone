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

@property (nonatomic, strong) NSArray *imageUrlsArray;

@property (nonatomic, assign) CGFloat ratio;

@end

@implementation HomeViewBannerCell

- (void)awakeFromNib {
    // Initialization code
    self.bannerScrollView.dataSource = self;
    self.bannerScrollView.delegate = self;
    [self.bannerScrollView setEnableClicking:YES];
    [self.bannerScrollView setRecyclable:YES];
    [self.bannerScrollView setAutoPlayDuration:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeBannerCellModel *)model {
    if (model) {
        self.ratio = [model cellRatio];
        self.imageUrlsArray = [model imageUrlsArray];
        [self.bannerScrollView reloadData];
    }
}

#pragma mark AUIBannerScrollViewDataSource & AUIBannerScrollViewDelegate

- (NSUInteger)numberOfBannersOnScrollView:(AUIBannerScrollView *)scrollView {
    return [self.imageUrlsArray count];
}

- (UIImageView *)bannerImageViewOnScrollView:(AUIBannerScrollView *)scrollView withViewFrame:(CGRect)frame atIndex:(NSUInteger)index {
    UIImageView *imageView = nil;
    imageView = [[UIImageView alloc] initWithFrame:frame];
    if ([self.imageUrlsArray count] > index) {
        NSURL *imageUrl = [self.imageUrlsArray objectAtIndex:index];
        [imageView setImageWithURL:imageUrl placeholderImage:PLACEHOLDERIMAGE_BIG];
    }
    return imageView;
}

- (NSURL *)bannerImageUrlForScrollView:(AUIBannerScrollView *)scrollView atIndex:(NSUInteger)index {
    if ([self.imageUrlsArray count] > index) {
        NSURL *imageUrl = [self.imageUrlsArray objectAtIndex:index];
        return imageUrl;
    }
    return nil;
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
