//
//  HomeViewTwoThreeFourCell.m
//  KidsTC
//
//  Created by Altair on 12/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewTwoThreeFourCell.h"
#import "AUIStackView.h"

@interface HomeViewTwoThreeFourCell ()

@property (weak, nonatomic) IBOutlet AUIStackView *stackView;

- (void)didClickedOnImage:(id)sender;

@end

@implementation HomeViewTwoThreeFourCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.stackView setViewGap:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithCellModel:(HomeTwoThreeFourCellModel *)model {
    NSUInteger count = [model.itemsArray count];
    
    CGFloat hMargin = 10;
    CGFloat hGap = 5;
    CGFloat vMargin = 5;
    CGFloat xPosition = hMargin;
    CGFloat yPosition = vMargin;
    CGFloat width = (SCREEN_WIDTH - 2 * hMargin - (count - 1) * hGap) / count;
    CGFloat height = width * [model cellRatio];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < count; index ++) {
        HomeTwoThreeFourItem *item = [model.itemsArray objectAtIndex:index];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, width, height)];
        [imageView setUserInteractionEnabled:YES];
        [imageView setImageWithURL:item.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        imageView.tag = index;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedOnImage:)];
        [imageView addGestureRecognizer:gesture];
        [tempArray addObject:imageView];
        xPosition += width + hGap;
    }
    [self.stackView setSubViews:[NSArray arrayWithArray:tempArray]];
}

- (void)didClickedOnImage:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeCell:didClickedAtIndex:)]) {
        UIView *view = ((UITapGestureRecognizer *)sender).view;
        [self.delegate homeCell:self didClickedAtIndex:view.tag];
    }
}

@end
