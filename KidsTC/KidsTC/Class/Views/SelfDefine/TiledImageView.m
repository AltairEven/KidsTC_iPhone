//
//  TiledImageView.m
//  iphone
//
//  Created by icson apple on 12-3-31.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "TiledImageView.h"

@implementation TiledImageView

- (void)dealloc {
    if (image_) {
		 image_ = nil;
	}
}

- (id)initWithFrame:(CGRect)frame tiledImage:(UIImage *)_image {
    if (self = [super initWithFrame:frame]) {
    	image_ = _image;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	if (!image_) {
		return;
	}

    CGImageRef image = CGImageRetain(image_.CGImage);
	
    CGRect imageRect;
    imageRect.origin = CGPointMake(0.0, 0.0);
    //imageRect.size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	imageRect.size = CGSizeMake(rect.size.height, rect.size.height);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, CGRectMake(0.0, 0.0, rect.size.width, rect.size.height));
	CGContextScaleCTM (context, 1, -1);
	// 防止图片倒立
    CGContextDrawTiledImage(context, imageRect, image);
    CGImageRelease(image);
}

@end
