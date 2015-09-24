//
//  MultiSelView.m
//  iPhone51Buy
//
//  Created by alex tao on 3/27/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import "MultiSelView.h"

#define SEL_MARGIN      10
#define EDGE_MARGIN     0

@implementation MultiSelView

- (void)internalInit
{
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_contentView];
    
    _objArr = [[NSMutableArray alloc] initWithCapacity:4];
    _allowMultiSel = NO;
    
    _disableIdx = [[NSMutableSet alloc] initWithCapacity:2];
    _contentOffset = EDGE_MARGIN;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self internalInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self internalInit];
    }
    return self;
}

- (void)dealloc
{
    _selDelegate = nil;
}

- (void) setTitleLabel:(NSString*)title withOffset:(CGFloat)offset
{
    if (title.length > 0) {
        if (nil == _selTitle) {
            _selTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140.0, 37.0)];
            _selTitle.textColor = [UIColor blackColor];
            _selTitle.textAlignment = NSTextAlignmentLeft;
            _selTitle.adjustsFontSizeToFitWidth = YES;
            _selTitle.backgroundColor = [UIColor clearColor];
            _selTitle.font = [UIFont systemFontOfSize:14.0];
        }
        [self addSubview:_selTitle];
    } else {
        [_selTitle removeFromSuperview];
    }
    _selTitle.text = title;
    
    if (offset < EDGE_MARGIN) {
        offset = EDGE_MARGIN;
    }
    _contentOffset = offset;
    
    [self setNeedsLayout];
}

- (void) appendSelStrings:(NSArray*)strArr
{
    [_objArr addObjectsFromArray:strArr];
    [self setNeedsLayout];
}

- (void) setSelectedForObj:(id)obj
{
    NSInteger idx = [_objArr indexOfObject:obj];
    [self setSelectedForIdx:idx];
}

- (void) setSelectedForIdx:(NSInteger)idx
{
    _selIdx = idx;
    NSArray * btnArr = _contentView.subviews;
    for (UIButton * view in btnArr) {
        view.selected = (view.tag == _selIdx);
    }
}

- (void) setDisableForIdxArr:(NSArray*)idArr
{
    if (idArr.count > 0) {
        [_disableIdx addObjectsFromArray:idArr];
        NSArray * btnArr = _contentView.subviews;
        for (UIButton * view in btnArr) {
            view.enabled = ![_disableIdx containsObject:[NSNumber numberWithInteger:view.tag]];
        }
    }
}

- (UIButton*) createSelBtn
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];

    //[btn setTitleColor:BUTTON_WEAK_TITLE_COLOR forState:UIControlStateNormal];
    btn.contentMode = UIViewContentModeScaleAspectFill;
    [btn.layer setBorderWidth:BORDER_WIDTH];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
//    UIImage *img = [UIImage imageNamed:@"detail_uncheck.png"];
//    UIImage *imgSelected = [UIImage imageNamed:@"detail_check.png"];
//
//    img = [img stretchableImageWithLeftCapWidth: floorf(img.size.width/2) topCapHeight: floorf(img.size.height/2)];
//    imgSelected = [imgSelected stretchableImageWithLeftCapWidth:floorf(imgSelected.size.width/2) topCapHeight: floorf(imgSelected.size.height/2)];
//
//    [btn setBackgroundImage: img forState: UIControlStateNormal];
//    [btn setBackgroundImage: imgSelected forState: UIControlStateSelected];
    
    [btn.layer setBorderColor:[UIColor colorWithRed:122/255.0 green:142/255.0 blue:162/255.0 alpha:1].CGColor];
    [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.47 blue:0 alpha:1] forState:UIControlStateHighlighted];
    [btn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.47 blue:0 alpha:1] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] forState:UIControlStateDisabled];
    
    [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void) selectBtn:(UIButton*)sender
{
    if (sender.isSelected) {
        return;
    }
    NSArray * btnArr = _contentView.subviews;
    for (UIButton * view in btnArr) {
        if (view == sender) {
            view.selected = YES;
            view.layer.borderWidth = 0;
            //[view.layer setBorderColor:CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0.8, 0, 0, 0.5})];
            //[view setBackgroundColor:[UIColor colorWithRed:1.0 green:0.47 blue:0 alpha:1]];
        } else {
            view.selected = NO;
            view.layer.borderWidth = BORDER_WIDTH;
            //重置颜色
            [view.layer setBorderColor:[UIColor colorWithRed:122/255.0 green:142/255.0 blue:162/255.0 alpha:1].CGColor];
            //[view setBackgroundColor:[UIColor whiteColor]];
        }
    }
    [_selDelegate multiSel:self didSelectObject:[_objArr objectAtIndex:sender.tag] adIndex:sender.tag];
}

- (void) resetView
{
    _selIdx = 0;
    [_disableIdx removeAllObjects];
    [_objArr removeAllObjects];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect = CGRectMake(_contentOffset, EDGE_MARGIN, rect.size.width-_contentOffset-EDGE_MARGIN, rect.size.height-EDGE_MARGIN);
    UIFont * font = [UIFont systemFontOfSize:14];
    
    NSArray * btnArr = _contentView.subviews;
    for (UIView * view in btnArr) {
        [view removeFromSuperview];
    }
    
    BOOL shouldSwitchLine = NO;
    if (_selTitle.text.length > 0) {
        //CGSize labSize = [_selTitle.text sizeWithFont:_selTitle.font];
        CGSize labSize = [_selTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObject:_selTitle.font forKey:NSFontAttributeName]];
        CGFloat titleWidth = labSize.width + EDGE_MARGIN + 2;
        if (titleWidth > (_contentOffset - SEL_MARGIN)) {
            shouldSwitchLine = YES;
            _selTitle.frame = CGRectMake(EDGE_MARGIN, 0, titleWidth, labSize.height);
        } else {
            _selTitle.frame = CGRectMake(EDGE_MARGIN, 0, titleWidth, 37.0);
        }
    }
    
    __block float xPos = _contentOffset;
    __block float yPos = shouldSwitchLine ? CGRectGetMaxY(_selTitle.frame)+SEL_MARGIN : EDGE_MARGIN;
    __block float availableWidth = rect.size.width;
    [_objArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * btn = [self createSelBtn];
        btn.tag = idx;
        float needWidth = 62;
        if ([obj isKindOfClass:[NSString class]]) {
            NSString * str = (NSString*)obj;
            [btn setTitle:str forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            //CGSize sz = [str sizeWithFont:font constrainedToSize:rect.size];
            CGSize sz = [str boundingRectWithSize:rect.size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil].size;
            needWidth = sz.width + 2*10;
        }
        
        if (needWidth < 62) {
            needWidth = 62;
        }
        
        btn.selected = (_selIdx == idx);
        btn.enabled = ![_disableIdx containsObject:[NSNumber numberWithInteger:idx]];
        [_contentView addSubview:btn];
        if (needWidth <= availableWidth) {
            btn.frame = CGRectMake(xPos, yPos, needWidth, 37);
            xPos = xPos + needWidth + SEL_MARGIN;
            availableWidth -= (needWidth + SEL_MARGIN);
        } else if (0 == idx) {
            btn.frame = CGRectMake(_contentOffset, yPos, rect.size.width, 37);
            xPos = CGRectGetMaxX(btn.frame) + SEL_MARGIN;
            availableWidth = rect.size.width - (needWidth + SEL_MARGIN);
        } else {
            if (needWidth > rect.size.width) needWidth = rect.size.width;
            yPos = yPos + 37 + SEL_MARGIN;
            btn.frame = CGRectMake(_contentOffset, yPos, needWidth, 37);
            xPos = CGRectGetMaxX(btn.frame) + SEL_MARGIN;
            availableWidth = rect.size.width - (needWidth + SEL_MARGIN);
        }
        
        //add by Altair, 20150320
        if (btn.selected) {
            btn.layer.borderWidth = 0;
            //[btn.layer setBorderColor:CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0.8, 0, 0, 0.5})];
            //[btn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.47 blue:0 alpha:1]];
        }
        if (!btn.enabled) {
            btn.layer.borderWidth = BORDER_WIDTH;
            //[btn.layer setBorderColor:[UIColor colorWithRed:122/255.0 green:142/255.0 blue:162/255.0 alpha:1].CGColor];
        }
    }];
}

- (void)sizeToFit
{
    [super sizeToFit];
    
    CGRect rect = self.bounds;
    UIView * btn = [_contentView.subviews lastObject];
    rect.size.height = CGRectGetMaxY(btn.frame) + EDGE_MARGIN;
    
    self.bounds = rect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
