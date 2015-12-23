/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：NoResultHintView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：benxi
 * 完成日期：12-11-5
 */

#import "NoResultHintView.h"

#define kTitle @"去首页逛逛吧"
@implementation NoResultHintView

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) setType:(NoRetHintType) type andFrame:(CGRect) frame {
    
    // Initialization code
    self.frame = frame;
    //购物车图片
    if (self.hintImageView) {
    }else {
        
        self.hintImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_search_result"]];
    }
    self.hintImageView.frame = CGRectMake((self.frame.size.width-98)/2, 20, 98, 98);
    [self addSubview:self.hintImageView];
    
    
    if (self.hintTextLabel) {
        
    }else{
    
        self.hintTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.hintImageView.frame.origin.y+self.hintImageView.frame.size.height+12, self.frame.size.width-30, 20)];
        _hintTextLabel.backgroundColor = [UIColor clearColor];
        _hintTextLabel.textAlignment = NSTextAlignmentCenter;
        _hintTextLabel.text = @"您的购物车里空空如也";
        _hintTextLabel.font = [UIFont systemFontOfSize:14.0f];
        _hintTextLabel.textColor = [UIColor colorWithRed:146.0f/255 green:146.0f/255 blue:146.0f/255 alpha:1];
        [self addSubview:_hintTextLabel];
        
    }
    
    
    //购物车按钮
    if (self.hintEnterButton) {
        
    }else{
        
        self.hintEnterButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _hintEnterButton.layer.borderWidth = 0.4;
//        _hintEnterButton.layer.borderColor = [UIColor colorWithRed:152.0f/255 green:168.0f/255 blue:184.0f/255 alpha:1].CGColor;
        _hintEnterButton.frame = CGRectMake(15, _hintTextLabel.frame.origin.y+_hintTextLabel.frame.size.height+30, self.frame.size.width-30, 45);
        _hintEnterButton.backgroundColor = [UIColor colorWithRed:255.0f/255 green:102.0f/255 blue:0/255 alpha:1.0f];
        _hintEnterButton.titleLabel.font =[UIFont systemFontOfSize:16.0f];
//        [_hintEnterButton setTitleColor:[UIColor colorWithRed:59.0f/255 green:89.0f/255 blue:111.0f/255 alpha:1] forState:UIControlStateNormal];
//        [_hintEnterButton setTitleColor:[UIColor colorWithRed:59.0f/255 green:89.0f/255 blue:111.0f/255 alpha:1] forState:UIControlStateHighlighted];
        [_hintEnterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_hintEnterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _hintEnterButton.showsTouchWhenHighlighted = YES;
        
        [_hintEnterButton setTitle:kTitle forState:UIControlStateNormal];
        [_hintEnterButton setTitle:kTitle forState:UIControlStateHighlighted];
        [_hintEnterButton addTarget:self action:@selector(goHomeToSelect) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_hintEnterButton];
    }
    
	if (type == NoCart)
	{
		[self.hintImageView setImage:LOADIMAGE(@"no_cart", @"png")];
        _hintTextLabel.text = @"您的购物车里空空如也";
		//[self.hintTextLabel setText:@"购物车里空空如也，不如去逛逛吧～"];
		[self.hintEnterButton setTitle:kTitle forState: UIControlStateNormal];
		[self.hintEnterButton setTitle:kTitle forState:UIControlStateHighlighted];
		[self.hintEnterButton setTitle:kTitle forState:UIControlStateSelected];
	}
	else if (type == NoSearchResult)
	{
		[self.hintImageView setImage:LOADIMAGE(@"no_search_result", @"png")];
		[self.hintTextLabel setText:@"抱歉，暂时没有符合条件的商品:("];
		[self.hintEnterButton setTitle:kTitle forState: UIControlStateNormal];
		[self.hintEnterButton setTitle:kTitle forState: UIControlStateHighlighted];
		[self.hintEnterButton setTitle:kTitle forState: UIControlStateSelected];

	}else if(type == NoDelivery)
	{
		[self.hintImageView setHidden:YES];
		[self.hintTextLabel setText:@"您暂时还没有购物记录"];
		self.hintTextLabel.textAlignment = NSTextAlignmentCenter;
		[self.hintEnterButton setTitle:kTitle forState:UIControlStateNormal];
		[self.hintEnterButton setTitle:kTitle forState: UIControlStateHighlighted];
		[self.hintEnterButton setTitle:kTitle forState: UIControlStateSelected];
	}else if(type == NoVirtual)
	{
		[self.hintImageView setHidden:YES];
		[self.hintTextLabel setText:@"您暂时还没有充值记录"];
		self.hintTextLabel.textAlignment = NSTextAlignmentCenter;
		[self.hintEnterButton setTitle:kTitle forState:UIControlStateNormal];
		[self.hintEnterButton setTitle:kTitle forState: UIControlStateHighlighted];
		[self.hintEnterButton setTitle:kTitle forState: UIControlStateSelected];
	}
}

- (void) goHomeToSelect {
    
	if ( _noResultHintDelegate && [_noResultHintDelegate respondsToSelector:@selector(goHome)]) {
		[_noResultHintDelegate goHome];
	}
}

@end
