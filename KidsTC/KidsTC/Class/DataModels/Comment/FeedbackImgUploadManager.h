//
//  FeedbackImgUploadManager.h
//  iPhone51Buy
//  图片上传的数据处理 位置：我的易讯-意见反馈-新建-选择图片，提交
//  Created by 陈裕聪 on 15-4-7.
//  Copyright (c) 2015年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int kMaxNumOfImgCanUpLoad = 5;
static NSString * const kFBImgUploading = @"kFBImgUploading";
static NSString * const kFBImgUploadFailed = @"kFBImgUploaFailed";

@protocol FeedbackImgUploadManagerDelegate <NSObject>
@optional
- (void)needRefrehsFBImgPickerView;
- (void)submitSaidanURL:  (NSArray *)urlArr;
@end


//@protocol SaidanUploadSubmitDelegate <NSObject>
//- (void)submitSaidanURL;
//@end

@interface FeedbackImgUploadManager : NSObject

@property (nonatomic, strong) NSMutableArray *uplodaImgReqArr;
@property (nonatomic, strong) NSMutableArray *uplodaSaianImgReqURLArr;
@property (nonatomic, strong) NSMutableArray *uplodaFailtReqURLArr;
@property (nonatomic, strong) NSMutableArray *needUplodaImageArr;
@property (nonatomic, strong) NSMutableArray *asiRequestArr;

@property (nonatomic, assign) NSInteger reqCount;
@property (nonatomic, assign) NSInteger allReqCount;
@property (nonatomic, weak) id <FeedbackImgUploadManagerDelegate> delegate;
//@property (nonatomic, weak) id <SaidanUploadSubmitDelegate> saidanDelegate;
@property (nonatomic, strong) NSMutableArray *uploadImgStateArr;

- (id)initWithDelegate:(id<FeedbackImgUploadManagerDelegate>)delegate;
//- (id)initWithSaidanDelegate:(id<SaidanUploadSubmitDelegate>)delegate;
- (void)startUploadImage:(UIImage *)image;
//- (void)startUploadSaidanImage:(UIImage *)image andNum:(NSInteger)num;
//- (void)startUploadSaidanImage:(UIImage *)image andNum:(NSInteger)num andreqTag:(NSInteger)tags;
- (void)startUploadSaidanImage:(UIImage *)image andNum:(NSInteger)num andreqTag:(NSInteger)tags andImagesArray:(NSArray *)imagesArray andReq:(NSMutableArray*)requestArray;
- (void)removeFBItemAtIndex:(int)index;

@end