//
//  FiveStarsView.m
//  KidsTC
//
//  Created by 钱烨 on 7/10/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "FiveStarsView.h"

#define DefaultStarGap (2)
#define DefaultStarWidth (15)
#define DefaultStarHeigth (15)
#define DefaultImageFull ([UIImage imageNamed:@"star_h"])
#define DefaultImageHalf ([UIImage imageNamed:@"star_half"])
#define DefaultImageEmpty ([UIImage imageNamed:@"star_n"])

@interface FiveStarsView ()

@property (nonatomic, strong) UIButton *star0;
@property (nonatomic, strong) UIButton *star1;
@property (nonatomic, strong) UIButton *star2;
@property (nonatomic, strong) UIButton *star3;
@property (nonatomic, strong) UIButton *star4;

- (void)initStars;

- (void)resetStarsWithNumber:(CGFloat)number;

- (void)resetStarsWithGap:(CGFloat)gap;

- (void)resetStarsWithSize:(CGSize)size;

- (void)resetStarsWithFullImage:(UIImage *)fullImage;

- (void)resetStarsWithHalfImage:(UIImage *)HalfImage;

- (void)resetStarsWithEmptyImage:(UIImage *)emptyImage;

- (void)didTapedOnStar:(id)sender;

@end

@implementation FiveStarsView


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    [self initStars];
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initStars];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initStars];
    }
    return self;
}

- (instancetype)initWithStarGap:(CGFloat)gap andStarSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self initStars];
        self.starGap = gap;
        self.starSize = size;
    }
    return self;
}

- (void)initStars {
    self.star0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DefaultStarWidth, DefaultStarHeigth)];
    self.star1 = [[UIButton alloc] initWithFrame:CGRectMake(DefaultStarWidth + DefaultStarGap, 0, DefaultStarWidth, DefaultStarHeigth)];
    self.star2 = [[UIButton alloc] initWithFrame:CGRectMake((DefaultStarWidth + DefaultStarGap) * 2, 0, DefaultStarWidth, DefaultStarHeigth)];
    self.star3 = [[UIButton alloc] initWithFrame:CGRectMake((DefaultStarWidth + DefaultStarGap) * 3, 0, DefaultStarWidth, DefaultStarHeigth)];
    self.star4 = [[UIButton alloc] initWithFrame:CGRectMake((DefaultStarWidth + DefaultStarGap) * 4, 0, DefaultStarWidth, DefaultStarHeigth)];
    
    [self.star0 setBackgroundImage:DefaultImageEmpty forState:UIControlStateNormal];
    [self.star1 setBackgroundImage:DefaultImageEmpty forState:UIControlStateNormal];
    [self.star2 setBackgroundImage:DefaultImageEmpty forState:UIControlStateNormal];
    [self.star3 setBackgroundImage:DefaultImageEmpty forState:UIControlStateNormal];
    [self.star4 setBackgroundImage:DefaultImageEmpty forState:UIControlStateNormal];
    
    [self.star0 setTag:0];
    [self.star1 setTag:1];
    [self.star2 setTag:2];
    [self.star3 setTag:3];
    [self.star4 setTag:4];
    
    [self.star0 addTarget:self action:@selector(didTapedOnStar:) forControlEvents:UIControlEventTouchUpInside];
    [self.star1 addTarget:self action:@selector(didTapedOnStar:) forControlEvents:UIControlEventTouchUpInside];
    [self.star2 addTarget:self action:@selector(didTapedOnStar:) forControlEvents:UIControlEventTouchUpInside];
    [self.star3 addTarget:self action:@selector(didTapedOnStar:) forControlEvents:UIControlEventTouchUpInside];
    [self.star4 addTarget:self action:@selector(didTapedOnStar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.star0];
    [self addSubview:self.star1];
    [self addSubview:self.star2];
    [self addSubview:self.star3];
    [self addSubview:self.star4];
    
    _starNumber = 0;
    _starGap = DefaultStarGap;
    _starSize = CGSizeMake(DefaultStarWidth, DefaultStarHeigth);
    _starImageFull = DefaultImageFull;
    _starImageHalf = DefaultImageHalf;
    _starImageEmpty = DefaultImageEmpty;
    
    [self sizeToFitParameters];
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setStarNumber:(CGFloat)starNumber {
    if (starNumber < 0 || starNumber > 5) {
        return;
    }
    _starNumber = starNumber;
    [self resetStarsWithNumber:starNumber];
}

- (void)setStarGap:(CGFloat)starGap {
    if (starGap < 0) {
        return;
    }
    _starGap = starGap;
    [self resetStarsWithGap:starGap];
}

- (void)setStarSize:(CGSize)starSize {
    if (starSize.width < 0 || starSize.height < 0) {
        return;
    }
    _starSize = starSize;
    [self resetStarsWithSize:starSize];
}

- (void)setStarImageFull:(UIImage *)starImageFull {
    if (!starImageFull) {
        return;
    }
    _starImageFull = starImageFull;
    [self resetStarsWithFullImage:starImageFull];
}

- (void)setStarImageHalf:(UIImage *)starImageHalf {
    if (!starImageHalf) {
        return;
    }
    _starImageHalf = starImageHalf;
    [self resetStarsWithHalfImage:starImageHalf];
}

- (void)setStarImageEmpty:(UIImage *)starImageEmpty {
    if (!starImageEmpty) {
        return;
    }
    _starImageEmpty = starImageEmpty;
    [self resetStarsWithEmptyImage:starImageEmpty];
}

- (CGSize)viewSize {
    CGFloat width = self.starSize.width * 5 + self.starGap * 4;
    CGSize size = CGSizeMake(width, self.starSize.height);
    return size;
}

- (CGSize)sizeToFitParameters {
    CGSize size = [self viewSize];
    NSArray *starsViewConstraintsArray = [self constraints];
    if (starsViewConstraintsArray && [starsViewConstraintsArray count] > 0) {
        for (NSLayoutConstraint *constraint in starsViewConstraintsArray) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                constraint.constant = size.width;
            }
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = size.height;
            }
        }
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    }
    return size;
}

#pragma mark Private Methods

- (void)resetStarsWithNumber:(CGFloat)number {
    CGFloat fromValue = self.starNumber;
    CGFloat toValue = number;
    _starNumber = number;
    NSArray *starArray = [NSArray arrayWithObjects:self.star0, self.star1, self.star2, self.star3, self.star4, nil];
    NSUInteger needPaintIndex = 0;
    while (number > 0) {
        UIButton *star = [starArray objectAtIndex:needPaintIndex];
        if (number < 1) {
            [star setBackgroundImage:self.starImageHalf forState:UIControlStateNormal];
        } else {
            [star setBackgroundImage:self.starImageFull forState:UIControlStateNormal];
        }
        number --;
        needPaintIndex ++;
    }
    
    NSUInteger noNeedPaintStartIndex = needPaintIndex;
    while (noNeedPaintStartIndex < 5) {
        UIButton *star = [starArray objectAtIndex:noNeedPaintStartIndex];
        [star setBackgroundImage:self.starImageEmpty forState:UIControlStateNormal];
        noNeedPaintStartIndex ++;
    }
    if (fromValue != toValue && self.delegate && [self.delegate respondsToSelector:@selector(fiveStarsView:didChangedStarNumberFromValue:toValue:)]) {
        [self.delegate fiveStarsView:self didChangedStarNumberFromValue:fromValue toValue:toValue];
    }
}

- (void)resetStarsWithGap:(CGFloat)gap {
    [self.star0 setFrame:CGRectMake(self.star0.frame.origin.x, 0, self.starSize.width, self.starSize.height)];
    [self.star1 setFrame:CGRectMake(self.star0.frame.origin.x + self.starSize.width + gap, 0, self.starSize.width, self.starSize.height)];
    [self.star2 setFrame:CGRectMake(self.star1.frame.origin.x + self.starSize.width + gap, 0, self.starSize.width, self.starSize.height)];
    [self.star3 setFrame:CGRectMake(self.star2.frame.origin.x + self.starSize.width + gap, 0, self.starSize.width, self.starSize.height)];
    [self.star4 setFrame:CGRectMake(self.star3.frame.origin.x + self.starSize.width + gap, 0, self.starSize.width, self.starSize.height)];
    [self sizeToFitParameters];
}

- (void)resetStarsWithSize:(CGSize)size {
    [self.star0 setFrame:CGRectMake(self.star0.frame.origin.x, 0, size.width, size.height)];
    [self.star1 setFrame:CGRectMake(self.star0.frame.origin.x + size.width + self.starGap, 0, size.width, size.height)];
    [self.star2 setFrame:CGRectMake(self.star1.frame.origin.x + size.width + self.starGap, 0, size.width, size.height)];
    [self.star3 setFrame:CGRectMake(self.star2.frame.origin.x + size.width + self.starGap, 0, size.width, size.height)];
    [self.star4 setFrame:CGRectMake(self.star3.frame.origin.x + size.width + self.starGap, 0, size.width, size.height)];
    [self sizeToFitParameters];
}

- (void)resetStarsWithFullImage:(UIImage *)fullImage {
    [self resetStarsWithNumber:self.starNumber];
}

- (void)resetStarsWithHalfImage:(UIImage *)HalfImage {
    [self resetStarsWithNumber:self.starNumber];
}

- (void)resetStarsWithEmptyImage:(UIImage *)emptyImage {
    [self resetStarsWithNumber:self.starNumber];
}

- (void)didTapedOnStar:(id)sender {
    if (self.editable) {
        UIButton *star = (UIButton *)sender;
        NSUInteger number = star.tag + 1;
        [self resetStarsWithNumber:number];
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
