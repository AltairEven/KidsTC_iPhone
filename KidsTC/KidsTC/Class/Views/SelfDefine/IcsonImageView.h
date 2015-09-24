//
//  IcsonImageView.h
//  FlexLayout
//
//  Created by alex tao on 1/5/13.
//  Copyright (c) 2013 alex tao. All rights reserved.
//

#import "PenddingImageView.h"

typedef enum RESOLUTION_WANG_GOU{
    R_30,
    R_60,
	R_80,
	R_120,
	R_160,
	R_200,
	R_300,
	R_400,
	R_600,
	R_800,
}RESOLUTION_WANG_GOU;

@class IcsonImageView;

@protocol IcsonImageDelegate <NSObject>

@optional
-(void)imageViewLoaded:(IcsonImageView*)imageView size:(CGSize)_size;
-(void)imageViewLoadFail:(IcsonImageView*)imageView;

@end

///////////////////////////////////////////////////////////////////////////////////

@interface IcsonImageView : PenddingImageView {
    
    UITapGestureRecognizer *            _tapGesture;
    
}

@property (nonatomic, weak) id<IcsonImageDelegate>    imgDelegate;

@property (nonatomic) BOOL      onlyReadCache;
@property (nonatomic) BOOL      clickDownloadMode;

- (BOOL) shouldHandleClickEvent;

- (void) setLocalImageName:(NSString*)name;
- (void) cleanImage;

- (void)loadAsyncImage:(NSString*)url placeHolderImage:(UIImage*)placeHolder andLoadFailedImage:(UIImage*)failedImage;
- (void)loadAsyncImage:(NSString*)url placeHolderImage:(UIImage*)placeHolder;
- (void)loadAsyncImage:(NSString*)url;
- (void)loadWangGouImage:(NSString*)url withResolution:(RESOLUTION_WANG_GOU)r;

+ (NSString*) randomGroupName;
+ (NSArray*) groupNames;

@end
