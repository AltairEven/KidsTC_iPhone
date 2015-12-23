//
//  RichPriceView.h
//  KidsTC
//
//  Created by 钱烨 on 7/10/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichPriceView : UIView

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, strong) UIFont *unitFont;

@property (nonatomic, strong) UIFont *priceFont;

@property (nonatomic, readonly) UILabel *priceLabel;
@property (nonatomic, readonly) UIView *slashView;

@property (nonatomic, assign) BOOL slashed;

- (void)setContentColor:(UIColor *)color;

- (void)setUnitFont:(UIFont *)uFont priceFont:(UIFont *)pFont;

- (CGSize)sizeToFitParameters;
- (CGSize)viewSize;

@end
