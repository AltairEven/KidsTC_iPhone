//
// 
//  iPhone51Buy
//  图片上传的数据处理 位置：我的易讯-意见反馈-新建-选择图片，提交
//  Created by 陈裕聪 on 15-4-7.
//  Copyright (c) 2015年 icson. All rights reserved.
//

#import "FeedbackImgUploadManager.h"

static const CGFloat kFBImageCompressRatio = 0.4f;
static const int kMaxImageSize = 1000000; // limit to 1M
static const int kMaxSaianImageSize = 500000;

@interface FeedbackImgUploadManager ()<UIAlertViewDelegate>

@end

@implementation FeedbackImgUploadManager

- (id)initWithDelegate:(id<FeedbackImgUploadManagerDelegate>)delegate
{
    if (self = [super init])
    {
        _delegate = delegate;
        self.uploadImgStateArr = [NSMutableArray array];
        self.uplodaImgReqArr = [NSMutableArray array];
        self.uplodaSaianImgReqURLArr = [NSMutableArray array];
        self.uplodaFailtReqURLArr = [NSMutableArray array];
        self.needUplodaImageArr = [NSMutableArray array];
        self.reqCount = 0;
        self.allReqCount = 0;
    }
    
    return self;
}


- (void)dealloc
{
    for (ASIFormDataRequest *upReq in self.uplodaImgReqArr)
    {
        [upReq clearDelegatesAndCancel];
    }
    
    [_uplodaImgReqArr removeAllObjects]; 
}

- (void)startUploadImage:(UIImage *)image
{
    if ([self.uploadImgStateArr count] >= kMaxNumOfImgCanUpLoad)
    {
        return;
    }
    NSData *imgData = UIImageJPEGRepresentation(image, kFBImageCompressRatio);
    int sizeOfImg = (int)[imgData length];
    
    if (sizeOfImg > kMaxImageSize)
    {
        // limit to 500k
        [[[iToast makeText:@"图片过大，请重新选择上传"] setDuration:1500] show];
        return;
    }
        
    ASIFormDataRequest *upReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SERIVCE_UPLOAD_IMG]];
    upReq.delegate = self;
    [upReq setDidFinishSelector:@selector(fbImgUpLoadSuccess:)];
    [upReq setDidFailSelector:@selector(fbImgUpLoadFailed:)];
    [upReq setData:imgData withFileName:@"test.jpg" andContentType:@"image/jpg" forKey:@"macd"];
    [upReq startAsynchronous];
    [self.uplodaImgReqArr addObject:upReq];
    
    [self.uploadImgStateArr addObject:kFBImgUploading];
    if ([self.delegate respondsToSelector:@selector(needRefrehsFBImgPickerView)])
    {
        [self.delegate needRefrehsFBImgPickerView];
    }
}


- (void)removeFBItemAtIndex:(int)index
{
    if (index >= [self.uploadImgStateArr count])
    {
        return;
    }
    
    if ([[self.uploadImgStateArr objectAtIndex:index] isEqualToString:kFBImgUploading])
    {
        int countOfLoading = 0;
        for (int i=0; i<index; i++)
        {
            if ([[self.uploadImgStateArr objectAtIndex:i] isEqualToString:kFBImgUploading])
            {
                countOfLoading++;
            }
        }
        
        ASIFormDataRequest *upReq = [self.uplodaImgReqArr objectAtIndex:countOfLoading];
        [upReq clearDelegatesAndCancel];
        [self.uplodaImgReqArr removeObjectAtIndex:countOfLoading];
    }
    
    [self.uploadImgStateArr removeObjectAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(needRefrehsFBImgPickerView)])
    {
        [self.delegate needRefrehsFBImgPickerView];
    }
}

- (void)fbImgUpLoadSuccess:(ASIHTTPRequest *)request
{
    NSDictionary *data = [request.responseData toJSONObjectFO];
    NSString *retString = nil;
    if (data && [data count] > 0 && [[data objectForKey:@"errno"] intValue] == 0)
    {
        retString = [[data objectForKey:@"data"] objectForKey:@"attachment"];
    }
    else
    {
        retString = kFBImgUploadFailed;
    }
    
    for (int i=0; i<[self.uploadImgStateArr count]; i++)
    {
        if ([[self.uploadImgStateArr objectAtIndex:i] isEqualToString:kFBImgUploading])
        {
            [self.uploadImgStateArr replaceObjectAtIndex:i withObject:retString];
            break;
        }
    }
    
    [self.uplodaImgReqArr removeObject:request];    
    if ([self.delegate respondsToSelector:@selector(needRefrehsFBImgPickerView)])
    {
        [self.delegate needRefrehsFBImgPickerView];
    }
}

- (void)fbImgUpLoadFailed:(ASIHTTPRequest *)request
{
    for (int i=0; i<[self.uploadImgStateArr count]; i++)
    {
        if ([[self.uploadImgStateArr objectAtIndex:i] isEqualToString:kFBImgUploading])
        {
            [self.uploadImgStateArr replaceObjectAtIndex:i withObject:kFBImgUploadFailed];
        }
    }
    
    [self.uplodaImgReqArr removeObject:request];
    if ([self.delegate respondsToSelector:@selector(needRefrehsFBImgPickerView)])
    {
        [self.delegate needRefrehsFBImgPickerView];
    }
}
#pragma mark saidan
- (void)startUploadSaidanImage:(UIImage *)image andNum:(NSInteger)num andreqTag:(NSInteger)tags andImagesArray:(NSArray *)imagesArray andReq:(NSMutableArray*)requestArray;
{
     [[GAlertLoadingView sharedAlertLoadingView] show];
    if (num != 100) {
        self.allReqCount = num;
        self.needUplodaImageArr = [imagesArray mutableCopy];
        self.asiRequestArr = [requestArray mutableCopy];
    }
    if ([self.uploadImgStateArr count] >= kMaxNumOfImgCanUpLoad)
    {
        return;
    }
      NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    int sizeOfImg = (int)[imgData length];
    if (sizeOfImg > kMaxSaianImageSize)
    {
        NSInteger m = sizeOfImg/kMaxSaianImageSize;
        imgData = UIImageJPEGRepresentation(image, 1.0/m);
        sizeOfImg = (int)[imgData length];
     }
//    NSString *uploadUrlString = [[GConfig sharedConfig] getURLStringWithAliasName:@"URL_UPLOAD_IMAGE"];
//    ASIFormDataRequest *upReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:uploadUrlString]];
    ASIFormDataRequest *upReq = [requestArray objectAtIndex:tags];
    upReq.delegate = self;
    [upReq setTimeOutSeconds:30];
    upReq.tag = tags;
    [upReq setDidFinishSelector:@selector(fbImgSaiDanUpLoadSuccess:)];
    [upReq setDidFailSelector:@selector(fbImgSaiDanUpLoadFailed:)];
    [upReq setData:imgData withFileName:@"test.jpg" andContentType:@"image/jpg" forKey:@"uploadfile[]"];
    [upReq startAsynchronous];
    

}

- (void)fbImgSaiDanUpLoadSuccess:(ASIHTTPRequest *)request
{
     NSArray *dataarray = [request.responseData toJSONObjectFO];
    NSDictionary *urldata ;
    if ([dataarray count] >= 1) {
        urldata = [dataarray objectAtIndex:0];
    }
    [self.uplodaSaianImgReqURLArr addObject:[urldata objectForKey:@"url"]];
    self.reqCount++;
    if (self.reqCount == self.allReqCount) {
         [[GAlertLoadingView sharedAlertLoadingView] hide];
        [self submitphotoURL];
    }
}

- (void)fbImgSaiDanUpLoadFailed:(ASIHTTPRequest *)request
{
     [[GAlertLoadingView sharedAlertLoadingView] hide];
    
    for (int i = 0; i< [self.uplodaFailtReqURLArr count]; i++) {
        if ([[self.uplodaFailtReqURLArr objectAtIndex:i] integerValue] == request.tag) {
            [self.uplodaSaianImgReqURLArr removeAllObjects];
            [self.uplodaFailtReqURLArr removeAllObjects];
            self.reqCount = 0;
            for (int i = 0; i<[self.asiRequestArr count]; i++) {
                ASIFormDataRequest *upReq = [self.asiRequestArr objectAtIndex:i];
                [upReq cancel];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"抱歉，上传图片失败，请重新上传"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"重试",nil];
            alert.tag = 10003;
            [alert show];
            return;
        }
    }
    [self.uplodaFailtReqURLArr addObject:[NSString stringWithFormat:@"%ld",(long)request.tag]];
    [self startUploadSaidanImage:[self.needUplodaImageArr objectAtIndex:request.tag] andNum:100 andreqTag:request.tag andImagesArray:nil andReq:self.asiRequestArr];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
     if(alertView.tag == 10003 ) {
        if (buttonIndex ==0 )
        {
            //            [self.tabBarController setSelectedIndex:HomeTabHome];
        }
        else if(buttonIndex == 1)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(submitSaidanURL:)]) {
                [self.delegate submitSaidanURL:self.uplodaSaianImgReqURLArr ];
            }
        }
    }
    
}

- (void)submitphotoURL
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitSaidanURL:)]) {
        [self.delegate submitSaidanURL:self.uplodaSaianImgReqURLArr ];
    }
}
@end
