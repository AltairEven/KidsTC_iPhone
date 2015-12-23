/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GCoverLineLab.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：1/7/13
 */

#import "GCoverLineLab.h"

@implementation GCoverLineLab

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isShowLine = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_lineLayer && _isShowLine) {
        _lineLayer.frame = CGRectMake(0.0,self.frame.size.height/2.0,self.frame.size.width,1.0);
        _lineLayer.hidden = [self.text length]==0;
    }
}

- (void)createLine
{
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = self.textColor.CGColor;
        [self.layer addSublayer:_lineLayer];
    }
}

- (void)showLine:(BOOL)show
{
    if (show) {
        [self createLine];
        _lineLayer.hidden = [self.text length]==0;
    }
    else
    {
        _lineLayer.hidden = YES;
    }
    
    _isShowLine = show;
    //NSLog(@"Show Line%d", show);
}
@end
