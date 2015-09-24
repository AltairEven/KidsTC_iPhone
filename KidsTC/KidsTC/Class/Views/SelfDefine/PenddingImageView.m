/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：PenddingImageView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年11月21日
 */

#import "PenddingImageView.h"


@implementation PenddingImageView

@synthesize group = _group;
@synthesize imgUrl = _imgUrl;
@synthesize userInfo = _userInfo;
@synthesize showWithAnimation = _showWithAnimation;
@synthesize imgView = _imgView;

- (void) internalInit 
{
    self.backgroundColor = [UIColor clearColor];

    _imgUrl = nil;
    _penddingStat = ePenddingNormal;
    
    _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_imgView];
    
    _swapImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_swapImgView setContentMode:UIViewContentModeScaleAspectFit];
    _swapImgView.alpha = 0;
    [self addSubview:_swapImgView];
    
    _showWithAnimation = YES;
    _showASAP = YES;
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if ( nil != self ) {
        [self internalInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];     // the frame size will be set at this time
    if ( nil != self ) {
        [self internalInit];
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

- (void)setPlaceHolderImg:(UIImage *)placeHolderImg
{
    if (nil == _imgView.image || _placeHolderImg == _imgView.image) {
        _imgView.image = placeHolderImg;
    }
    
    _placeHolderImg = placeHolderImg;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;

    _imgView.frame = _swapImgView.frame = UIEdgeInsetsInsetRect(frame, _imgInset);
    _imgView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
}

- (void)setImgUrl:(NSString *)imgUrl
{
    if (imgUrl && imgUrl.length > 0 && ![_imgUrl isEqualToString:imgUrl])
    {
        _imgUrl = imgUrl;
        
        [self stop];
        _penddingStat = ePenddingNormal;
    }
}

- (void) swapAnimWithImage:(UIImage*)img
{
    _imgToDisplay = img;
    
    if (_showASAP) {
        [self realDisplayImage];
    }
}

- (void) setLoadFail
{
    _penddingStat = ePenddingFail;
    if (_failImg) {
        [self swapAnimWithImage:_failImg];
    }
    [self onLoadFail];
}

- (void) realDisplayImage
{
    if (_imgToDisplay)
    {
        [self onWillDisplay];
        
        _swapImgView.image = _imgView.image;
        _imgView.image = _imgToDisplay;
        
        _imgToDisplay = nil;
        
        if (_showWithAnimation) {
            _swapImgView.alpha = 1;
            _imgView.alpha = 0;
            [UIView animateWithDuration:.3 animations:^{
                _swapImgView.alpha = 0;
                _imgView.alpha = 1;
            }];
        } else {
            _swapImgView.alpha = 0;
            _imgView.alpha = 1;
        }
    }
}

- (CGSize) sizeForCurrentImage
{
    return _imgView.image ? _imgView.image.size : CGSizeZero;
}

- (UIImage*) showingImage
{
    return _imgView.image;
}

- (void) refresh
{
    _penddingStat = ePenddingNormal;
    [self goFetching];
}

- (void) goFetching
{
    if (ePenddingHasSent == _penddingStat || ePenddingComplete == _penddingStat) {
        return;
    }
    
    if (_imgUrl.length == 0)
    {
        // 非法的url，直接返回fail
        [self setLoadFail];
        return;
    }

    [self stop];
    
    _penddingStat = ePenddingHasSent;
    _imgView.image = _placeHolderImg;
    
    NSString * currentUrl = [_imgUrl copy];
    
    if (![DownLoadManager isRemoteUrl:_imgUrl])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (![currentUrl isEqualToString:_imgUrl]) {
                return;
            }
            UIImage * img = [UIImage imageWithContentsOfFile:_imgUrl];
            if (nil == img) {
                img = [UIImage imageNamed:_imgUrl];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (img) {
                    _penddingStat = ePenddingComplete;
                    [self swapAnimWithImage:img];
                    [self onLoadSuccess];
                } else {
                    [self setLoadFail];
                }
            });
        });
    }
    else
    {
        [[DownLoadManager sharedDownLoadManager] downloadWithUrl:_imgUrl group:_group successBlock:^(UIImage * img) {
            if (![currentUrl isEqualToString:_imgUrl]) {
                return;
            }
            if ([img isKindOfClass:[NSData class]]) {
                // should never go there
                img = [UIImage imageWithData:(NSData*)img];
            }
            if (img) {
                _penddingStat = ePenddingComplete;
                [self swapAnimWithImage:img];
                [self onLoadSuccess];
            } else {
                [self setLoadFail];
            }
        } failureBlock:^(NSError * err) {
            [self setLoadFail];
        } option:[self downloadOption]];
    }
}

- (void) stop
{
    if (ePenddingHasSent == _penddingStat) {
        [[DownLoadManager sharedDownLoadManager] cancelByUrl:_imgUrl];
        _penddingStat = ePenddingNormal;
    }
}

- (DownloadOption*) downloadOption
{
    return DownloadOptionImage;
}

- (void) onWillDisplay {
    
}

- (void) onLoadSuccess {
    
}

- (void) onLoadFail {
    
}

@end
