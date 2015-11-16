//
//  RichPriceView.m
//  KidsTC
//
//  Created by 钱烨 on 7/10/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "RichPriceView.h"

#define DefaultColor ([UIColor darkGrayColor])

@interface RichPriceView ()

@property (nonatomic, assign) CGFloat unitLabelHorizontalMargin;

@property (nonatomic, assign) CGFloat priceLabelHorizontalMargin;

@property (nonatomic, assign) CGFloat unitLabelVerticalMargin;

@property (nonatomic, assign) CGFloat priceLabelVerticalMargin;

- (void)initSubViews;

@end

@implementation RichPriceView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    [self initSubViews];
    return self;
}


- (void)initSubViews {
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIFont *font = [UIFont systemFontOfSize:self.frame.size.height];
    
    _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    [self.unitLabel setFont:font];
    [self.unitLabel setTextColor:DefaultColor];
    [self.unitLabel setTextAlignment:NSTextAlignmentLeft];
    [self.unitLabel setText:@"￥"];
    [self addSubview:self.unitLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    [self.priceLabel setFont:font];
    [self.priceLabel setTextColor:DefaultColor];
    [self.priceLabel setTextAlignment:NSTextAlignmentLeft];
    [self.priceLabel setText:@"0"];
    [self addSubview:self.priceLabel];
    
    _slashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0.5)];
    [self.slashView setBackgroundColor:DefaultColor];
    [self addSubview:self.slashView];
    [self.slashView setHidden:!self.slashed];
}


- (CGSize)sizeToFitParameters {
    CGSize size = [self viewSize];
    
    CGFloat widthAdjustment = 0;
    
    if (IS_GREATER_THAN_IOS9) {
        widthAdjustment = self.unitLabel.font.pointSize;
    } else {
        widthAdjustment = self.unitLabel.frame.size.width;
    }
    
    [self.unitLabel setFrame:CGRectMake(0, size.height - self.unitLabel.font.pointSize, widthAdjustment, self.unitLabel.frame.size.height)];
    [self.priceLabel setFrame:CGRectMake(widthAdjustment, size.height - self.priceLabel.font.pointSize, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height)];
    
    [self.superview updateConstraintsIfNeeded];
    [self.superview layoutIfNeeded];
    return size;
}

- (CGSize)viewSize {
    [self.priceLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.priceLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    CGSize unitFitSize = [self.unitLabel sizeOfSizeToFitWithMaximumNumberOfLines:1];
    CGSize priceFitSize = [self.priceLabel sizeOfSizeToFitWithMaximumNumberOfLines:1];
    
    self.unitLabelVerticalMargin = self.unitLabel.font.lineHeight - self.unitLabel.font.pointSize;
    self.priceLabelVerticalMargin = self.priceLabel.font.lineHeight - self.priceLabel.font.pointSize;
    CGFloat margin = (self.unitLabelVerticalMargin > self.priceLabelVerticalMargin ? self.unitLabelVerticalMargin : self.priceLabelVerticalMargin);
    
    CGFloat width = unitFitSize.width + priceFitSize.width;
    if (IS_GREATER_THAN_IOS9) {
        width = self.unitLabel.font.pointSize + priceFitSize.width;
    }
    CGFloat unitHeight = self.unitLabel.font.pointSize;
    CGFloat priceHeight = self.priceLabel.font.pointSize;
    CGFloat height = (unitHeight > priceHeight ? unitHeight : priceHeight) - margin;
    
    NSArray *priceViewConstraintsArray = [self constraints];
    if (priceViewConstraintsArray && [priceViewConstraintsArray count] > 0) {
        for (NSLayoutConstraint *constraint in priceViewConstraintsArray) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                constraint.constant = width;
            }
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = height;
                [self.slashView setFrame:CGRectMake(0, constraint.constant / 2, width, self.slashView.frame.size.height)];
            }
        }
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
        [self.slashView setFrame:CGRectMake(0, self.frame.size.height / 2, width, self.slashView.frame.size.height)];
    }
    
    
    return CGSizeMake(width, height);
}

- (void)setSlashed:(BOOL)slashed {
    _slashed = slashed;
    [self.slashView setHidden:!slashed];
}

- (void)setContentColor:(UIColor *)color {
    if (!color) {
        return;
    }
    [self.unitLabel setTextColor:color];
    [self.priceLabel setTextColor:color];
    [self.slashView setBackgroundColor:color];
}

- (void)setFont:(UIFont *)font {
    if (!font) {
        return;
    }
    [self.unitLabel setFont:font];
    [self.priceLabel setFont:font];
    [self sizeToFitParameters];
}

- (void)setPrice:(CGFloat)price {
    if (price < 0) {
        return;
    }
    [self.priceLabel setText:[NSString stringWithFormat:@"%g", price]];
    [self sizeToFitParameters];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
