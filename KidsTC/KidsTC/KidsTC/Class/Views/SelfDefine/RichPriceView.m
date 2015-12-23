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
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    [self.priceLabel setTextColor:DefaultColor];
    [self.priceLabel setTextAlignment:NSTextAlignmentLeft];
    [self.priceLabel setText:@"0"];
    [self addSubview:self.priceLabel];
    
    _unitFont = [UIFont systemFontOfSize:self.frame.size.height];
    _priceFont = [UIFont systemFontOfSize:self.frame.size.height];
    
    _slashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0.5)];
    [self.slashView setBackgroundColor:DefaultColor];
    [self addSubview:self.slashView];
    [self.slashView setHidden:!self.slashed];
}


- (CGSize)sizeToFitParameters {
    CGSize size = [self viewSize];
    
    NSArray *priceViewConstraintsArray = [self constraints];
    if (priceViewConstraintsArray && [priceViewConstraintsArray count] > 0) {
        for (NSLayoutConstraint *constraint in priceViewConstraintsArray) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                constraint.constant = size.width;
            }
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = size.height;
                [self.slashView setFrame:CGRectMake(0, constraint.constant / 2, size.width, self.slashView.frame.size.height)];
            }
        }
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
        [self.slashView setFrame:CGRectMake(0, self.frame.size.height / 2, size.width, self.slashView.frame.size.height)];
    }
    
    [self.priceLabel setFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [self.superview updateConstraintsIfNeeded];
    [self.superview layoutIfNeeded];
    return size;
}

- (CGSize)viewSize {
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH, 100);
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 1.0;
    CGRect labelFrame = [self.priceLabel.attributedText boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:context];
    
    CGFloat width = labelFrame.size.width;
    
    CGFloat unitHeight = self.unitFont.capHeight;
    CGFloat priceHeight = self.priceFont.capHeight;
    CGFloat height = (unitHeight > priceHeight ? unitHeight : priceHeight);
    
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
    [self.priceLabel setTextColor:color];
    [self.slashView setBackgroundColor:color];
}

- (void)setUnitFont:(UIFont *)unitFont {
    if (!unitFont) {
        return;
    }
    _unitFont = unitFont;
    NSString *priceText = [NSString stringWithFormat:@"%g", self.price];
    NSString *text = [NSString stringWithFormat:@"￥%@", priceText];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    [attrText addAttribute:NSFontAttributeName value:unitFont range:NSMakeRange(0,1)];
    [attrText addAttribute:NSFontAttributeName value:self.priceFont range:NSMakeRange(1, [priceText length])];
    
    [self.priceLabel setAttributedText:attrText];
    [self sizeToFitParameters];
}

- (void)setPriceFont:(UIFont *)priceFont {
    if (!priceFont) {
        return;
    }
    _priceFont = priceFont;
    NSString *priceText = [NSString stringWithFormat:@"%g", self.price];
    NSString *text = [NSString stringWithFormat:@"￥%@", priceText];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    [attrText addAttribute:NSFontAttributeName value:self.unitFont range:NSMakeRange(0,1)];
    [attrText addAttribute:NSFontAttributeName value:priceFont range:NSMakeRange(1, [priceText length])];
    
    [self.priceLabel setAttributedText:attrText];
    [self sizeToFitParameters];
}

- (void)setUnitFont:(UIFont *)uFont priceFont:(UIFont *)pFont {
    if (!uFont || !pFont) {
        return;
    }
    _unitFont = uFont;
    _priceFont = pFont;
    NSString *priceText = [NSString stringWithFormat:@"%g", self.price];
    NSString *text = [NSString stringWithFormat:@"￥%@", priceText];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    [attrText addAttribute:NSFontAttributeName value:uFont range:NSMakeRange(0,1)];
    [attrText addAttribute:NSFontAttributeName value:pFont range:NSMakeRange(1, [priceText length])];
    
    [self.priceLabel setAttributedText:attrText];
    [self sizeToFitParameters];
}

- (void)setPrice:(CGFloat)price {
    if (price < 0) {
        return;
    }
    _price = price;
    NSString *priceText = [NSString stringWithFormat:@"%g", price];
    NSString *text = [NSString stringWithFormat:@"￥%@", priceText];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    [attrText addAttribute:NSFontAttributeName value:self.unitFont range:NSMakeRange(0,1)];
    [attrText addAttribute:NSFontAttributeName value:self.priceFont range:NSMakeRange(1, [priceText length])];
    
    [self.priceLabel setAttributedText:attrText];
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
