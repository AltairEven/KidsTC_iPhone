//
//  HorizontalCalendarView.m
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HorizontalCalendarView.h"

@interface HorizontalCalendarView ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollBGView;

@property (nonatomic, strong) NSMutableArray *buttonArray;

- (void)resetSubViews;

- (void)didClickedButton:(id)sender;

- (void)selectButtonAtIndex:(NSUInteger)index;

@end

@implementation HorizontalCalendarView


#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        HorizontalCalendarView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.buttonArray = [[NSMutableArray alloc] init];
}


#pragma mark Private methods

- (void)resetSubViews {
    for (UIView *view in self.buttonArray) {
        [view removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    
    CGFloat xPosition = 0;
    CGFloat yPosition = 5;
    CGFloat width = SCREEN_WIDTH / 3;
    CGFloat height = 40 - (yPosition * 2);
    CGFloat gap = 2;
    NSUInteger count = [self.titlesArray count];
    for (NSUInteger index = 0; index < count; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundColor:RGBA(246, 246, 246, 1) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setTitle:[self.titlesArray objectAtIndex:index] forState:UIControlStateNormal];
        
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        
        button.tag = index;
        [button addTarget:self action:@selector(didClickedButton:) forControlEvents:UIControlEventTouchUpInside];
        xPosition += gap;
        [button setFrame:CGRectMake(xPosition, yPosition, width, height)];
        [self.scrollBGView addSubview:button];
        [self.buttonArray addObject:button];
        xPosition += width;
    }
    
    [self selectButtonAtIndex:0];
    CGFloat totalWidth = (width * count) + (gap * (count + 1));
    [self.scrollBGView setContentSize:CGSizeMake(totalWidth, 0)];
}


- (void)didClickedButton:(id)sender {
    NSUInteger index = ((UIButton *)sender).tag;
    if (index == self.currentIndex) {
        return;
    }
    [self selectButtonAtIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(HorizontalCalendarView:didClickedAtIndex:)]) {
        [self.delegate HorizontalCalendarView:self didClickedAtIndex:index];
    }
}


- (void)selectButtonAtIndex:(NSUInteger)index {
    UIButton *before = [self.buttonArray objectAtIndex:self.currentIndex];
    [before setSelected:NO];
    UIButton *after = [self.buttonArray objectAtIndex:index];
    [after setSelected:YES];
    _currentIndex = index;
}

#pragma mark Public methods

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = [NSArray arrayWithArray:titlesArray];
    [self resetSubViews];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
