//
//  SaidanPhotoView.h
//  ICSON
//
//  Created by 肖晓春 on 15/5/13.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SaiDanPhotoView;
//@protocol ImageClickDelegate <NSObject>
//@optional
//- (void)imageClick:(UIImageView *)imageView thumImageArray:(NSArray *)thumArray atIndex:(NSInteger)index;
//@end

@protocol SaiDanPhotoViewDelegate <NSObject>

@optional
- (void)SaiDanTakePhotos;
- (void)refreshSaiDanPhotoViewHeight;
- (void)imageClick:(UIImageView *)imageView thumImageArray:(NSArray *)thumArray atIndex:(NSInteger)index;
@end

@interface SaiDanPhotoView : UIView
@property (strong, nonatomic) IBOutlet UIButton *addphotos;
@property (strong, nonatomic)  UIButton *addPhotoBtn;
@property (nonatomic, assign) id<SaiDanPhotoViewDelegate> delegate;
@property (nonatomic)  CGFloat saiDanPhotoViewHeight;
@property (nonatomic)  CGFloat productReviewPhotoViewHeight;
- (IBAction)touchTakephotos:(id)sender;
- (CGFloat)heightOfSaiDanPhoto;
//- (void)resetImageViews : (NSDictionary *)array an;
- (void)resetImageViews:(NSDictionary *)dic andArray :(NSArray *)imagesArray;
//- (void)resetProductReviewImageViews:(NSArray *)imagesArray;
- (void)resetProductReviewImageViews:(NSArray *)imagesArray thumbnailArray:(NSArray *)thumbnailArray;
@end
