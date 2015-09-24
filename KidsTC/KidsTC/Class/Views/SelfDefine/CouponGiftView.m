/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：CouponGiftView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：ericjsshen
 * 完成日期：2013年10月16日
 */

#import "CouponGiftView.h"

@implementation OrderCouponGiftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
}

- (void)setAmount:(NSInteger)amount
{
    _amount = amount;
    _amountLabel.text = [NSString stringWithFormat:@"%li",(long)_amount];
    [self layoutLabels];
}

- (void)layoutLabels
{
    if (_amount < 10) {
        _currencySymbolLabel.frame = CGRectMake(10, 12, 12, 12);
        _amountLabel.font = [UIFont boldSystemFontOfSize:18];
        _amountLabel.frame = CGRectMake(21, 10, 28, 18);
    }
    else if (_amount < 100) {
        _currencySymbolLabel.frame = CGRectMake(8, 12, 12, 12);
        _amountLabel.font = [UIFont boldSystemFontOfSize:18];
        _amountLabel.frame = CGRectMake(19, 10, 30, 18);
    }
    else if (_amount < 1000) {
        _currencySymbolLabel.frame = CGRectMake(4, 12, 12, 12);
        _amountLabel.font = [UIFont boldSystemFontOfSize:18];
        _amountLabel.frame = CGRectMake(15, 10, 34, 18);
    }
    else {
        _currencySymbolLabel.frame = CGRectMake(3, 12, 12, 12);
        _amountLabel.font = [UIFont boldSystemFontOfSize:15];
        _amountLabel.frame = CGRectMake(14, 10, 35, 15);
    }
}


@end

@implementation ProductCouponGiftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
}

- (void)setAmount:(NSInteger)amount
{
    _amount = amount;
    _amountLabel.text = [NSString stringWithFormat:@"%li",(long)_amount];
    [self layoutLabels];
}

- (void)layoutLabels
{
    if (_amount < 10) {
        _currencySymbolLabel.frame = CGRectMake(16, 15, 16, 16);
        _amountLabel.font = [UIFont boldSystemFontOfSize:26];
        _amountLabel.frame = CGRectMake(31, 9, 37, 30);
    }
    else if (_amount < 100) {
        _currencySymbolLabel.frame = CGRectMake(12, 15, 16, 16);
        _amountLabel.font = [UIFont boldSystemFontOfSize:26];
        _amountLabel.frame = CGRectMake(27, 9, 41, 30);
    }
    else if (_amount < 1000) {
        _currencySymbolLabel.frame = CGRectMake(5, 15, 16, 16);
        _amountLabel.font = [UIFont boldSystemFontOfSize:26];
        _amountLabel.frame = CGRectMake(18, 9, 50, 30);
    }
    else {
        _currencySymbolLabel.frame = CGRectMake(3, 15, 16, 16);
        _amountLabel.font = [UIFont boldSystemFontOfSize:22];
        _amountLabel.frame = CGRectMake(15, 10, 53, 26);
    }
}


@end

@implementation PhotoCouponGiftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
}

- (void)setAmount:(NSInteger)amount
{
    _amount = amount;
    _amountLabel.text = [NSString stringWithFormat:@"%li",(long)_amount];
    [self layoutLabels];
}

- (void)layoutLabels
{
    if (_amount < 10) {
        _currencySymbolLabel.frame = CGRectMake(53, 45, 30, 30);
        _amountLabel.font = [UIFont boldSystemFontOfSize:61];
        _amountLabel.frame = CGRectMake(82, 37, 58, 65);
    }
    else if (_amount < 100) {
        _currencySymbolLabel.frame = CGRectMake(33, 45, 30, 30);
        _amountLabel.font = [UIFont boldSystemFontOfSize:61];
        _amountLabel.frame = CGRectMake(62, 37, 78, 65);
    }
    else if (_amount < 1000) {
        _currencySymbolLabel.frame = CGRectMake(10, 45, 30, 30);
        _amountLabel.font = [UIFont boldSystemFontOfSize:61];
        _amountLabel.frame = CGRectMake(37, 37, 103, 65);
    }
    else {
        _currencySymbolLabel.frame = CGRectMake(10, 52, 30, 30);
        _amountLabel.font = [UIFont boldSystemFontOfSize:45];
        _amountLabel.frame = CGRectMake(37, 45, 103, 49);
    }
}


@end
