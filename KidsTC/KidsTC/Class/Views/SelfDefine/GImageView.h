//
//  GImageView.h
//  iphone51buy
//
//  Created by icson apple on 12-5-31.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@class HttpProcessHelper;
@class GImageView;

@protocol GImageViewDelegate <NSObject>

-(void)gImageViewLoaded:(GImageView *)gImageView size:(CGSize)_size;

@end

typedef enum{
	GImageStatusDefault = 0,
	GImageStatusLoading = 1,
	GImageStatusDone = 2,
	GImageStatusInSaveFlowMode = 3,
	
} GImageStatus;

@interface GImageCache : NSObject
{
    NSMutableDictionary *cacheList;
    NSMutableDictionary *localCacheList;
    NSLock *imageCacheLock;
}

+ (id)sharedImageCache;
- (UIImage *)loadImageFromCache:(NSString *)_imageUrl;
- (UIImage *)loadImageFromCacheLocal:(NSString *)_imageUrl;
- (void)pushImageToCache:(NSString *)_imageUrl image:(UIImage *)_image;
- (void)clearImageCache;
@end

@interface GImageLoader : NSObject
{
    HttpProcessHelper *_imgHttpProcessHelper;
}

@property (strong, nonatomic, readonly) ASIHTTPRequest *imgRequest;
@property (weak, nonatomic) id delegate;
@end

@interface GImageView : UIImageView
{
	GImageLoader *imgLoader;
	NSString *imageUrl;
	UITapGestureRecognizer *tap;
}

@property (weak, nonatomic) id<GImageViewDelegate> delegate;
@property (nonatomic) GImageStatus status;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *loadfailedImage;
- (void)loadAsyncImage:(NSString *)_imageUrl placeHolderImage:(UIImage *)_placeHolderImage andLoadFailedImage:(UIImage *)loadfailedImage;
- (void)loadAsyncImage:(NSString *)_imageUrl placeHolderImage:(UIImage *)_placeHolderImage;
- (void)loadAsyncImage:(NSString *)imageUrl;
@end
