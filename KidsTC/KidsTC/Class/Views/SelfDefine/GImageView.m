//
//  GImageView.m
//  iphone51buy
//
//  Created by icson apple on 12-5-31.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GImageView.h"
#import "CodeConstants.h"
#import "HttpProcessHelper.h"


#define gCacheMaxLengthForImageView (25)
#define gCacheMaxLengthLocalForImageView (500)

static GImageCache *_sharedImageCache;
@implementation GImageCache

+ (GImageCache *)sharedImageCache
{
    @synchronized([self class]){
        if (!_sharedImageCache) {
            _sharedImageCache = [[[self class] alloc] init];
        }
        
        return _sharedImageCache;
    }

    return nil;
}

- (id)init
{
    if(self = [super init]){
        cacheList = [[NSMutableDictionary alloc] initWithCapacity: gCacheMaxLengthForImageView];
        imageCacheLock = [[NSLock alloc] init];

        localCacheList = [[NSMutableDictionary alloc] initWithContentsOfFile: FILE_CACHE_PATH(@"plist/img_list.plist")];
        if (localCacheList == nil) {
            localCacheList = [[NSMutableDictionary alloc] initWithCapacity: gCacheMaxLengthLocalForImageView];
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath: FILE_CACHE_PATH(@"imgCache")]) {
            [fileManager createDirectoryAtPath: FILE_CACHE_PATH(@"imgCache") withIntermediateDirectories: YES attributes: nil error: nil];
        }

        if (![fileManager fileExistsAtPath: FILE_CACHE_PATH(@"plist")]) {
            [fileManager createDirectoryAtPath: FILE_CACHE_PATH(@"plist") withIntermediateDirectories: YES attributes: nil error: nil];
        }
    }

    return self;
}

- (void)dealloc
{
     cacheList = nil;
     localCacheList = nil;
     imageCacheLock = nil;
}

- (void)clearImageCache
{
	if(cacheList)
	{
		[cacheList removeAllObjects];
	}
    

	localCacheList = [[NSMutableDictionary alloc] init];
	[localCacheList writeToFile: FILE_CACHE_PATH(@"plist/img_list.plist") atomically: YES];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath: FILE_CACHE_PATH(@"imgCache")]) {
		[fileManager removeItemAtPath: FILE_CACHE_PATH(@"imgCache") error: nil];
	}
	//程序运行中如果清空，再次缓存的时候需要重新创建imgCache，不然后续的没法缓存了
	if (![fileManager fileExistsAtPath: FILE_CACHE_PATH(@"imgCache")]) {
		[fileManager createDirectoryAtPath: FILE_CACHE_PATH(@"imgCache") withIntermediateDirectories: YES attributes: nil error: nil];
	}
}

- (UIImage *)loadImageFromCache:(NSString *)_imageUrl
{	
	UIImage *cacheImage = [cacheList objectForKey: _imageUrl];
	if (cacheImage) {
		return cacheImage;
	}

    cacheImage = [self loadImageFromCacheLocal: _imageUrl];
    if (cacheImage) {
        return cacheImage;
    }

	return nil;
}

- (NSString *)urlToCacheKey:(NSString *)url
{
    return [NSString stringWithFormat: @"image-%@", url];
}

- (UIImage *)relativePathToImage:(NSString *)relativePath
{
    return [[UIImage alloc] initWithContentsOfFile: FILE_CACHE_PATH(([NSString stringWithFormat: @"imgCache/%@", relativePath]))];
}

- (UIImage *)loadImageFromCacheLocal:(NSString *)_imageUrl
{
    NSString *cacheKey = [self urlToCacheKey: _imageUrl];
    NSString *path = [localCacheList objectForKey: cacheKey];
    if (path) {
        UIImage *localImg = [self relativePathToImage: path];
        if (localImg) {
            // 放到内存缓存中
            [self pushImageToCache: _imageUrl image: localImg saveLocal: NO];
        }
        
        return localImg;
    }

	return nil;
}

- (void)removeImageFromCacheLocalByKey:(NSString *)localCacheKey
{
    NSString *imgPath = [localCacheList objectForKey: localCacheKey];
    if (imgPath) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error = nil;
        [fileManager removeItemAtPath: FILE_CACHE_PATH(([NSString stringWithFormat: @"imgCache/%@", imgPath])) error: &error];
        [localCacheList removeObjectForKey: localCacheKey];
    }
}

- (void)removeImageFromCacheLocal:(NSString *)_imageUrl
{
    NSString *localCacheKey = [self urlToCacheKey:_imageUrl];
    [self removeImageFromCacheLocalByKey:localCacheKey];
}

- (NSString *)generateImgCachePath
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    
    return uuidString;
}

- (void)pushImageToCache:(NSString *)_imageUrl image:(UIImage *)_image
{
    [self pushImageToCache: _imageUrl image: _image saveLocal: YES];
}

- (void)pushImageToCache:(NSString *)_imageUrl image:(UIImage *)_image saveLocal:(BOOL)_saveLocal
{
	if (!_imageUrl || !_image)
    {
		return;
	}

	if ([cacheList objectForKey: _imageUrl])
    {
		[cacheList removeObjectForKey: _imageUrl];
	}
	
	[cacheList setObject: _image forKey: _imageUrl];
	[imageCacheLock lock];
	if ([cacheList count] > gCacheMaxLengthForImageView)
    {
		NSArray *allKeys = [cacheList allKeys];
		[cacheList removeObjectsForKeys: [allKeys subarrayWithRange: NSMakeRange(0, [cacheList count] - gCacheMaxLengthForImageView)]];
	}

    if(_saveLocal)
    {
        NSString *localCacheKey = [self urlToCacheKey: _imageUrl];
        [self removeImageFromCacheLocalByKey: localCacheKey];
        NSString *imgPath = [self generateImgCachePath];
        NSString  *jpgPath = FILE_CACHE_PATH(([NSString stringWithFormat: @"imgCache/%@", imgPath]));
        NSError *error;
        BOOL imgSaved = [UIImageJPEGRepresentation(_image, 1.0) writeToFile: jpgPath options: NSDataWritingAtomic error: &error]; 
        if (imgSaved)
        {
            [localCacheList setObject: imgPath forKey: localCacheKey];
        }
        
        if ([localCacheList count] > gCacheMaxLengthLocalForImageView)
        {
            NSArray *allKeys = [localCacheList allKeys];
            allKeys = [allKeys subarrayWithRange: NSMakeRange(0, [localCacheList count] - gCacheMaxLengthLocalForImageView)];
            for (NSString *key in allKeys)
            {
                [self removeImageFromCacheLocalByKey: key];
            }
        }
        
        [localCacheList writeToFile: FILE_CACHE_PATH(@"plist/img_list.plist") atomically: YES];
    }

	[imageCacheLock unlock];
}

@end

@implementation GImageLoader
@synthesize  delegate, imgRequest;
- (id)init
{
	if (self = [super init])
    {
		_imgHttpProcessHelper = [[HttpProcessHelper alloc] init];
	}

	return self;
}

- (void)cancel
{
	if (imgRequest)
    {
		if (!imgRequest.isCancelled)
        {
			[imgRequest clearDelegatesAndCancel];
		}
        
		 imgRequest = nil;
	}
}

- (ASIHTTPRequest *)startRequest:(NSString *)_imageUrl
{
	if (delegate)
    {
		[_imgHttpProcessHelper setUrl: _imageUrl];

		[self cancel];
		imgRequest = [_imgHttpProcessHelper startGETProcess: delegate onSuccess: @selector(imgFinished:) onFailed: @selector(imgFailed:) onLoading: nil data: nil userInfo: [NSDictionary dictionaryWithObjectsAndKeys: _imageUrl, @"imageUrl", nil]];
    }

	return imgRequest;
}

- (void)dealloc
{
    self.delegate = nil;
	[self cancel];

}

@end

@implementation GImageView
@synthesize status, delegate, imageUrl;
@synthesize loadfailedImage = _loadfailedImage;
- (void)imgFailed:(ASIHTTPRequest *)request
{
	if(![GToolUtil isNetworkWifiStatus] && [[NSUserDefaults standardUserDefaults] boolForKey:kIsDownloadImageOrNotWhenWifi])
    {
		self.status = GImageStatusInSaveFlowMode;
	}
	else
	{
		self.status = GImageStatusDefault;
	}
    
	[self setImage:self.loadfailedImage];
}

- (void)imgFinished:(ASIHTTPRequest *)request
{
	UIImage *resultImage = [UIImage imageWithData: [request responseData]];
    
    if (nil == resultImage)
    {
        [self imgFailed:request];
        return;
    }
    
	[self setImage: resultImage];
	
	if (delegate)
    {
		[delegate gImageViewLoaded: self size: resultImage.size];
	}
	
	if (request.userInfo)
    {
		[[GImageCache sharedImageCache] pushImageToCache: [request.userInfo objectForKey: @"imageUrl"] image: resultImage];
	}
	
	self.status = GImageStatusDone;
}

- (void)loadAsyncImage:(NSString *)_imageUrl placeHolderImage:(UIImage *)_placeHolderImage andLoadFailedImage:(UIImage *)loadfailedImage
{
    self.loadfailedImage = loadfailedImage ? loadfailedImage : LOADIMAGE(@"image_loading_failed", @"png");
    
    if (_imageUrl == nil)
    {
        self.image = self.loadfailedImage;
		return;
	}
    
    if(![GToolUtil isNetworkWifiStatus] && [[NSUserDefaults standardUserDefaults] boolForKey:kIsDownloadImageOrNotWhenWifi])
	{
		//不允许下载的情况下，如果已经下载了，则直接return，否则，则记录url, 设置为placehoder，并更改状态为placeholder
		if ([_imageUrl isEqualToString: imageUrl] && status == GImageStatusDone) {
			return;
		}
		else if(self.status == GImageStatusInSaveFlowMode)
		{
			self.imageUrl = _imageUrl;
			
			UIImage *cachedImage = [[GImageCache sharedImageCache] loadImageFromCache: _imageUrl];
			if (cachedImage)
			{
				[self setImage: cachedImage];
				if (delegate)
				{
					[delegate gImageViewLoaded: self size: cachedImage.size];
				}
				self.status = GImageStatusDone;
				return;
			}
			
			CGSize size = self.frame.size;
			UIImage *newPlaceHoder = nil;
			if(size.width >70.0f)
			{
				newPlaceHoder = LOADIMAGE(@"placeholder_large", @"png");
			}
			else if(size.width > 40.0f)
			{
				newPlaceHoder = LOADIMAGE(@"placeholder_big", @"png");
			}
			else if(size.width > 30.0f)
			{
				newPlaceHoder = LOADIMAGE(@"placeholder_middle", @"png");
			}
			else
			{
				newPlaceHoder = LOADIMAGE(@"placeholder_small", @"png");
			}
            
			[self setImage:newPlaceHoder];
			return;
		}
	}
	
	if ([_imageUrl isEqualToString: imageUrl] && status == GImageStatusDone)
    {
		return;
	}
	
	self.imageUrl = _imageUrl;
	UIImage *cachedImage = [[GImageCache sharedImageCache] loadImageFromCache: _imageUrl];
	if (cachedImage)
    {
		[self setImage: cachedImage];
		if (delegate)
        {
			[delegate gImageViewLoaded: self size: cachedImage.size];
		}
        
		self.status = GImageStatusDone;
		return;
	}
	
	if ( !imgLoader )
    {
		imgLoader = [[GImageLoader alloc] init];
		[imgLoader setDelegate: self];
	}
	
	[self setImage: _placeHolderImage];
    self.status = GImageStatusLoading;
	[imgLoader startRequest: _imageUrl];
}

- (void)loadAsyncImage:(NSString *)_imageUrl placeHolderImage:(UIImage *)_placeHolderImage
{
	[self loadAsyncImage:_imageUrl placeHolderImage:_placeHolderImage andLoadFailedImage:nil];
}

- (void)loadAsyncImage:(NSString *)_imageUrl
{
	[self loadAsyncImage: _imageUrl placeHolderImage:LOADIMAGE(@"image_loading", @"png")];
}

- (void)dealloc
{
	if (imgLoader)
    {
		[imgLoader cancel];
		 imgLoader = nil;
	}
    
}

- (void)setStatus:(GImageStatus)statusNew
{
	if(statusNew == GImageStatusInSaveFlowMode && [[self gestureRecognizers] count] == 0)
	{
		tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
		[self addGestureRecognizer:tap];
		[self setUserInteractionEnabled:YES];
	}
	else if(statusNew == GImageStatusDone && [[self gestureRecognizers] count]>0)
	{
		[self removeGestureRecognizer:tap];
		[self setUserInteractionEnabled:NO];
	}
    
    status = statusNew;
}

- (void)tap:(UITapGestureRecognizer*)gesture
{
	if(self.status == GImageStatusInSaveFlowMode)
	{
		self.status = GImageStatusLoading;
		[self loadAsyncImage:self.imageUrl];
	}
}

@end
