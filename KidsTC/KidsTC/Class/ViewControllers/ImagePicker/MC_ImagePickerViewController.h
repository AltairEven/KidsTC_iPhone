//
//  MC_ImagePickerViewController.h
//  Coordinate
//
//  Created by Qian Ye on 13-11-18.
//  Copyright (c) 2013年 MapABC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MC_PhotoAlbumViewController.h"

#define PickedInfoImageArray (@"imageArray")//相册中选择的图片image
#define PickedInfoImageViewArray (@"imageViewArray")//相册中选择的图片imageview
#define PickedInfoImageURLArray (@"urlArray")//相册中选择的图片url

#define PickedInfoTakePicturesArray (@"takePicturesArray")//拍照的图片image
#define PickedInfoTakePicturesURLArray (@"takePicturesURLArray")//拍照的图片image URL

#define PickedInfoSelectAllPictureArray (@"selectAllPictureArray")// 所有选择的图片imageview
#define PickedInfoSelectAllURLArray (@"selectAllURLArray")//所有选择的图片URL
#define PickedInfoSelectAllImageArray (@"selectAllImageArray")//所有选择的图片image

@class MC_ImagePickerViewController;

@protocol MC_ImagePickerViewControllerDelegate <NSObject>

@optional

- (void)MC_ImagePickerViewController:(MC_ImagePickerViewController *)controller didFinishPickingImageWithInfo:(NSDictionary *)info;
- (void)getTakePicturePhoto : (UIImage *)image photosDictionary : (NSDictionary *)photosdictionary;

@end

@interface MC_ImagePickerViewController : UIViewController <MC_PhotoAlbumViewControllerDelegate>

@property (strong, nonatomic) id<MC_ImagePickerViewControllerDelegate> delegate;

//+ (MC_ImagePickerViewController *)sharedInstanceWithMaxNum:(NSInteger)num;

- (MC_ImagePickerViewController *)initWithMaxCount:(NSInteger)count andPhotoDictionary:(NSDictionary *)photoDictionary;

@end
