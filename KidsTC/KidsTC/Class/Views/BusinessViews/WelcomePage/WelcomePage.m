/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：WelcomePage.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：5/28/13
 */

#import "WelcomePage.h"

@implementation WelcomePage
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _textLab = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 10.0, frame.size.height / 5.0, frame.size.width * 4.0/5.0, frame.size.height * 3.0/5.0)];
        _textLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLab];
        self.textLab.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

- (void)showActionBtn:(BOOL)show
{
    if (show)
    {
        if (!self.actionBtn)
        {
            self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect aRect = CGRectMake(0.0, 0.0, 185.0f, 38.0f);
            aRect.origin.x = (self.frame.size.width - 185.0)/2.0;
            aRect.origin.y = self.frame.size.height * 8.0 / 10.0;
            self.actionBtn.frame = aRect;
            [self.actionBtn setImage:LOADIMAGE(@"welcome_action_btn", @"png") forState:UIControlStateNormal];
            [self addSubview:self.actionBtn];
        }
        self.actionBtn.hidden = NO;
    }
    else
    {
        self.actionBtn.hidden = YES;
    }
}

- (void)setContentImage:(UIImage *)img
{
    if(img != nil)
    {
        CGSize imgSize = img.size;
        imgSize.height = self.frame.size.width / imgSize.width * imgSize.height;
        imgSize.width = self.frame.size.width;
        self.imageView.frame = CGRectMake((self.frame.size.width - imgSize.width)/2.0, (self.frame.size.height-[[UIApplication sharedApplication] statusBarFrame].size.height - imgSize.height)/2.0, imgSize.width, imgSize.height);
//        self.imageView.center = self.center;
    }
    
    self.imageView.image = img;
}

- (void)setContentText:(NSString *)text
{
    self.textLab.text = text;
}

@end
