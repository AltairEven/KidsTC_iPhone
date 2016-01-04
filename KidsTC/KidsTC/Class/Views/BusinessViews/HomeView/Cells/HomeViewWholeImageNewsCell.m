//
//  HomeViewWholeImageNewsCell.m
//  KidsTC
//
//  Created by 钱烨 on 9/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewWholeImageNewsCell.h"
#import "AUIBannerScrollView.h"

@interface HomeViewWholeImageNewsCell () <AUIBannerScrollViewDataSource, AUIBannerScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet AUIBannerScrollView *bannerScrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;

@property (nonatomic, strong) HomeWholeImageNewsCellModel *cellModel;

@end

@implementation HomeViewWholeImageNewsCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    
    self.bannerScrollView.dataSource = self;
    self.bannerScrollView.delegate = self;
    [self.bannerScrollView setEnableClicking:YES];
    [self.bannerScrollView setRecyclable:YES];
    [self.bannerScrollView setAutoPlayDuration:5];
    [self.bannerScrollView setShowPageIndex:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeWholeImageNewsCellModel *)model {
    self.cellModel = model;
    [self.bannerScrollView reloadData];
    NSUInteger modelsCount = [model.newsModels count];
    if (modelsCount > 0) {
        HomeNewsBaseModel *newsModel = [model.newsModels objectAtIndex:0];
        [self.titleLabel setText:newsModel.title];
    } else {
        [self.titleLabel setText:@""];
    }
    if (modelsCount > 1) {
        self.rightMargin.constant = 40;
        [self.indexLabel setHidden:NO];
        [self.indexLabel setText:[NSString stringWithFormat:@"1/%lu", (unsigned long)modelsCount]];
    } else {
        self.rightMargin.constant = 0;
        [self.indexLabel setHidden:YES];
        [self.indexLabel setText:@""];
    }
}

#pragma mark AUIBannerScrollViewDataSource & AUIBannerScrollViewDelegate

- (NSUInteger)numberOfBannersOnScrollView:(AUIBannerScrollView *)scrollView {
    return [self.cellModel.newsModels count];
}

- (UIImageView *)bannerImageViewOnScrollView:(AUIBannerScrollView *)scrollView withViewFrame:(CGRect)frame atIndex:(NSUInteger)index {
    UIImageView *imageView = nil;
    imageView = [[UIImageView alloc] initWithFrame:frame];
    HomeNewsBaseModel *model = [self.cellModel.newsModels objectAtIndex:index];
    [imageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_BIG];
    return imageView;
}

- (NSURL *)bannerImageUrlForScrollView:(AUIBannerScrollView *)scrollView atIndex:(NSUInteger)index {
    HomeNewsBaseModel *model = [self.cellModel.newsModels objectAtIndex:index];
    return model.imageUrl;
}

- (CGFloat)heightForBannerScrollView:(AUIBannerScrollView *)scrollView {
    return [self.cellModel cellRatio] * SCREEN_WIDTH;
}

- (void)auiBannerScrollView:(AUIBannerScrollView *)scrollView didScrolledToIndex:(NSUInteger)index {
    HomeNewsBaseModel *model = [self.cellModel.newsModels objectAtIndex:index];
    [self.titleLabel setText:model.title];
    [self.indexLabel setText:[NSString stringWithFormat:@"%lu/%lu", (unsigned long)(index + 1), (unsigned long)[self.cellModel.newsModels count]]];
}

- (void)auiBannerScrollView:(AUIBannerScrollView *)scrollView didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewWholeImageNewsCell:didClickedAtIndex:)]) {
        [self.delegate homeViewWholeImageNewsCell:self didClickedAtIndex:index];
    }
}

@end
