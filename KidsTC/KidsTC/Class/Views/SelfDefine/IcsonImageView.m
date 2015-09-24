//
//  IcsonImageView.m
//  FlexLayout
//
//  Created by alex tao on 1/5/13.
//  Copyright (c) 2013 alex tao. All rights reserved.
//

#import "IcsonImageView.h"

@implementation IcsonImageView

- (void) internalInit
{
    [super internalInit];
}


- (DownloadOption*) downloadOption
{
    if (_onlyReadCache) {
        return DownloadOptionMakeImage(NO, eCallbackOldDataNoFetchNew, nil);
    }
    return [super downloadOption];
}


- (void) setLocalImageName:(NSString*)name
{
    self.imgUrl = name;
    [self goFetching];
}

- (void) cleanImage {
    _imgView.image = nil;
}

- (BOOL) shouldHandleClickEvent {
    return (![GToolUtil isNetworkWifiStatus] && [[NSUserDefaults standardUserDefaults] boolForKey:kIsDownloadImageOrNotWhenWifi] && _clickDownloadMode);
    //return ([[NSUserDefaults standardUserDefaults] boolForKey:kIsDownloadImageOrNotWhenWifi] && _clickDownloadMode);
}

- (void)loadAsyncImage:(NSString*)url placeHolderImage:(UIImage*)placeHolder andLoadFailedImage:(UIImage*)failedImage
{
    self.group = [IcsonImageView randomGroupName];
    
    _onlyReadCache = NO;
    self.placeHolderImg = placeHolder;
    self.failImg = failedImage;
    
    if([self shouldHandleClickEvent])
	{
		CGFloat width = self.frame.size.width;
        UIImage *newFailImg = nil;
        if(width >70.0f) {
            newFailImg = [UIImage imageNamed:@"load_failed_default"];
        } else if(width > 40.0f) {
            newFailImg = [UIImage imageNamed:@"load_failed_default"];
        } else if(width > 30.0f) {
            newFailImg = [UIImage imageNamed:@"load_failed_default"];
        } else {
            newFailImg = [UIImage imageNamed:@"load_failed_default"];
        }
        
        self.failImg = newFailImg;
        _onlyReadCache = YES;
    }
    
    self.imgUrl = url;
    [self goFetching];
}

- (void)loadAsyncImage:(NSString*)url placeHolderImage:(UIImage*)placeHolder
{
    [self loadAsyncImage:url placeHolderImage:placeHolder andLoadFailedImage:[UIImage imageNamed:@"load_failed_default"]];
}

- (void)loadAsyncImage:(NSString*)url
{
    [self loadAsyncImage:url placeHolderImage:[UIImage imageNamed:@"load_failed_default"]];
}

- (void)loadWangGouImage:(NSString*)url withResolution:(RESOLUTION_WANG_GOU)r
{
	url = [GToolUtil changeUrl:url andResolution:r];
	[self loadAsyncImage:url];
}

+ (NSString*) randomGroupName {
    static NSUInteger sNameIdx = 0;
    NSArray * arr = [IcsonImageView groupNames];
    if (sNameIdx >= arr.count) sNameIdx= 0;
    return [arr objectAtIndex:sNameIdx++];
}

+ (NSArray*) groupNames {
    static NSArray * sImgNameArr = nil;
    if (nil == sImgNameArr) {
        sImgNameArr = [NSArray arrayWithObjects:@"imgCache1", @"imgCache2", @"imgCache3", @"imgCache4", @"imgCache5", nil];
    }
    return sImgNameArr;
}

- (void) onLoadSuccess
{
    [super onLoadSuccess];

    if (_tapGesture) {
        [self removeGestureRecognizer:_tapGesture];
        _tapGesture = nil;
    }
    if (_imgDelegate && [_imgDelegate respondsToSelector:@selector(imageViewLoaded:size:)]) {
        [_imgDelegate imageViewLoaded:self size:_imgView.image.size];
    }
}

- (void) onLoadFail
{
    [super onLoadFail];
    if (_clickDownloadMode && nil == _tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self addGestureRecognizer:_tapGesture];
    }
    if (_imgDelegate && [_imgDelegate respondsToSelector:@selector(imageViewLoadFail:)]) {
        [_imgDelegate imageViewLoadFail:self];
    }
}

- (void) onWillDisplay
{

}

- (void)tapped:(UITapGestureRecognizer*)gesture
{
	_onlyReadCache = NO;
    [self goFetching];
}

@end
