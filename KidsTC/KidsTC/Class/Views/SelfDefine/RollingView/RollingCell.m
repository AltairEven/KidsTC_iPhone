/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：RollingCell.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */

#import "RollingCell.h"

@implementation RollingInfo
@synthesize rollId;
@synthesize textString = _textString;
@synthesize imgName = _imgName;

- (id) initWithId:(NSInteger)rollId_ textString:(NSString*)textStr andImageName:(NSString*)img
{
    self = [super init];
    if (self != nil) {
        self.rollId = rollId_;
        self.textString = textStr;
        self.imgName = img;
    }
    return self;
}


@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation RollingCell
@synthesize info = _info;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)layoutSubviews
{
	[super layoutSubviews];
    
    _titleLabel.frame = self.bounds;
    _bgImgView.frame = self.bounds;
}

- (void)setInfo:(RollingInfo *)info
{
    if(_info != info)
    {
        _info = info;
        
        if (info.imgName) {
            if (nil == _bgImgView) {
                _bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
                _bgImgView.backgroundColor = [UIColor clearColor];
                [_bgImgView setContentMode:UIViewContentModeScaleAspectFit];
                [self.contentView addSubview:_bgImgView];
            }
            _bgImgView.image = [UIImage imageNamed:info.imgName];
        }
        
        if (info.textString) {
            if (nil == _titleLabel) {
                _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
                _titleLabel.backgroundColor = [UIColor clearColor];
                _titleLabel.font = [UIFont systemFontOfSize:60];
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                [self.contentView addSubview:_titleLabel];
            }
            _titleLabel.text = info.textString;
        }
    }
}

@end
