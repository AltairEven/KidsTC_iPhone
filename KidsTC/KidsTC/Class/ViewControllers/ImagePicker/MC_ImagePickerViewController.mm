//
//  MC_ImagePickerViewController.m
//  Coordinate
//
//  Created by Qian Ye on 13-11-18.
//  Copyright (c) 2013年 MapABC. All rights reserved.
//

#import "MC_ImagePickerViewController.h"
//#include "GlobalDefine.h"
#import "MC_PhotoAlbumViewController.h"
//#import "MC_Imageview.h"

#define IMAGEVIEW_ORIGIN_X (4.0)
#define IMAGEVIEW_ORIGIN_Y (4.0)
#define IMAGEVIEW_SIZE_WIDTH (75.0)
#define IMAGEVIEW_SIZE_HEIGHT (75.0)
#define IMAGEVIEW_HORIZONTALGAP (4.0)
#define IMAGEVIEW_VERTICALGAP (4.0)

typedef NS_ENUM(NSInteger, ChosenTag){
    ChosenTagUnchosen,
    ChosenTagChosen
};
//typedef void (^MCAlbumListCompletion)(NSArray *albumList);
//static MC_ImagePickerViewController *controller;
//static NSInteger maxNum;

@interface MC_ImagePickerViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    ALAssetsLibrary *_assetsLibrary;
}


@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) NSMutableArray *chosenPhotos;//选择了相册中图片的image 

@property (strong, nonatomic) NSMutableArray *chosenPhotoURLs;//选择了相册中图片的image的 url

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *btnCancel;

@property (strong, nonatomic) UIButton *btnAlbum;

@property (strong, nonatomic) UITableView *tableGroup;

@property (strong, nonatomic) UIScrollView *photosView;

@property (strong, nonatomic) UILabel *lbTotalCount;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIScrollView *chosenImagePanel;

@property (strong, nonatomic) UIButton *btnDone;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) NSMutableArray *imageViewsArray;//存放所有的照片，相册和拍照的

@property (strong, nonatomic) NSMutableArray *imageURLsArray;//存放所有照片的url,拍照的照片没有URL，用字符串@“takePictureURL”代替

@property (strong, nonatomic) NSMutableArray *takePicturesArray;//存放所有拍照的照片 image

@property (strong, nonatomic) NSMutableArray *takePicturesURLArray;//存放所有拍照的照片 image URL

@property (strong, nonatomic) NSMutableArray *takePicturesImageViewArray;//存放所有拍照的照片 imageview

@property (strong, nonatomic) NSMutableArray *selectedImageViewsArray;//存放相册中选择的图片

@property (strong, nonatomic) NSMutableArray *selectedAllImageViewArray;//存放所有选择了的照片 imageview

@property (strong, nonatomic) NSMutableArray *selectedAllURLArray;//存放所有选择了的照片 URL

@property (strong, nonatomic) NSMutableArray *selectedAllImageArray;//存放所有选择了的照片 image

@property (strong, nonatomic) NSMutableArray *panelImageViewsArray;

@property (assign, nonatomic) NSInteger maxNum;

//@property (strong, nonatomic) NSURL *photoCompareURL;

- (void)getAllPicturesFromPhotoLibrary;

- (void)hasGetAllPicturesFromLibrary:(NSArray *)dataArray;

- (void)dismiss;

@end

@implementation MC_ImagePickerViewController

@synthesize chosenPhotos, chosenPhotoURLs;
@synthesize assetsLibrary, imageViewsArray, imageURLsArray, selectedImageViewsArray, panelImageViewsArray;
@synthesize topView, titleLabel, btnCancel, btnDone, tableGroup, photosView, lbTotalCount, indicatorView;
@synthesize maxNum;
#pragma mark init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (MC_ImagePickerViewController *)initWithMaxCount:(NSInteger)count andPhotoDictionary:(NSDictionary *)photoDictionary
{
    self = [super init];
    if (self) {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        self.chosenPhotos = [[NSMutableArray alloc] initWithCapacity:maxNum];
        self.chosenPhotoURLs = [[NSMutableArray alloc] initWithCapacity:maxNum];
        self.imageViewsArray = [[NSMutableArray alloc] init];
        self.imageURLsArray = [[NSMutableArray alloc] init];
        self.selectedImageViewsArray = [[NSMutableArray alloc] init];
        self.panelImageViewsArray = [[NSMutableArray alloc] init];
        self.takePicturesArray = [[NSMutableArray alloc] init];
        self.takePicturesImageViewArray = [[NSMutableArray alloc] init];
        self.selectedAllImageViewArray = [[NSMutableArray alloc] init];
        self.selectedAllURLArray = [[NSMutableArray alloc] init];
        self.selectedAllImageArray = [[NSMutableArray alloc] init];
        self.takePicturesURLArray = [[NSMutableArray alloc] init];
        maxNum = count;
        if ([photoDictionary count] > 0) {
            //相册
            self.selectedImageViewsArray  = [NSMutableArray arrayWithArray:[photoDictionary objectForKey:PickedInfoImageViewArray]];
            self.chosenPhotoURLs = [NSMutableArray arrayWithArray:[photoDictionary objectForKey:PickedInfoImageURLArray]];
            self.chosenPhotos = [NSMutableArray arrayWithArray:[photoDictionary objectForKey:PickedInfoImageArray]];
            //拍照
            self.takePicturesArray = [NSMutableArray arrayWithArray:[photoDictionary objectForKey:PickedInfoTakePicturesArray]];
            self.takePicturesURLArray = [NSMutableArray arrayWithArray:[photoDictionary objectForKey:PickedInfoTakePicturesURLArray]];
            //所有选择的照片
            self.selectedAllImageViewArray = [NSMutableArray arrayWithArray:[photoDictionary objectForKey:PickedInfoSelectAllPictureArray]];
            self.selectedAllURLArray = [NSMutableArray arrayWithArray:[photoDictionary objectForKey:PickedInfoSelectAllURLArray]];
            self.selectedAllImageArray = [NSMutableArray arrayWithArray:[photoDictionary objectForKey:PickedInfoSelectAllImageArray]];
        }
    }
    
    return self;

}

- (void)initView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat fLeft = 0.0;
    CGFloat fTop = 0.0;
    CGFloat fWidth = self.view.frame.size.width;
    CGFloat fHeight = 40.0;

    
    fLeft = 0.0;
    fHeight = 20.0;

    fTop = fHeight;
    fWidth = self.view.frame.size.width;
    fHeight = self.view.frame.size.height - 20.0 - 49.0;
    self.photosView = [[UIScrollView alloc] initWithFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.photosView setBackgroundColor:[UIColor whiteColor]];
    [self.photosView setAlwaysBounceVertical:YES];
    [self.photosView setBounces:YES];
    [self.photosView setBouncesZoom:NO];
    [self.photosView setContentSize:self.photosView.frame.size];
    [self.view addSubview:self.photosView];
    fTop = fTop - 10.0;
    fHeight = 40.0;
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicatorView setFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.photosView addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    fLeft = 0.0;
    fTop = self.view.frame.size.height - 49.0;
    fWidth = self.view.frame.size.width;
    fHeight = 49.0;
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.bottomView setBackgroundColor:RGBA(247.0, 247.0, 249.0, 1.0)];
    [self.view addSubview:self.bottomView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(fLeft, fTop - 0.5, fWidth, 0.5)];
    view.backgroundColor = RGBA(167.0, 167.0, 170.0, 1.0);
    [self.view addSubview:view];
    
    fLeft = IMAGEVIEW_ORIGIN_X;
    fTop = 4;
    fWidth = (IMAGEVIEW_SIZE_WIDTH * 3) + (IMAGEVIEW_HORIZONTALGAP * 2);
    fHeight = 40;
    fLeft = self.view.frame.size.width - 55;
    fWidth = 40;
    self.btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnDone setFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.btnDone setTitle:@"完成" forState:UIControlStateNormal];
    [self.btnDone setTitleColor:RGBA(51.0, 51.0, 51.0, 1.0) forState:UIControlStateNormal];
    [self.btnDone setBackgroundColor:[UIColor clearColor]];
    [self.btnDone addTarget:self action:@selector(onClickDoneButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.btnDone];
    
    
    fLeft = 15;
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnCancel setFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:RGBA(51.0, 51.0, 51.0, 1.0) forState:UIControlStateNormal];
    [self.btnCancel setBackgroundColor:[UIColor clearColor]];
    [self.btnCancel addTarget:self action:@selector(onClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.btnCancel];

}

#pragma mark self method
- (void)onClickCancelButton
{
    [self dismiss];
}


- (void)onClickAlbumButton
{
    MC_PhotoAlbumViewController *albumController = [MC_PhotoAlbumViewController sharedInstance];
    albumController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    albumController.delegate = self;
    
    [self presentViewController:albumController animated:YES completion:^(void){;}];
}


- (void)onClickDoneButton
{
//    if ([self.chosenPhotos count] > 0 && [self.chosenPhotoURLs count] > 0) {
    
        //删除拍照的照片中没被选择的照片
        NSMutableArray *takephotosArray = [[NSMutableArray alloc]init];
  
        for (int i = 0; i < [self.takePicturesImageViewArray count]; i++) {
            
            if (((UIImageView *)[self.takePicturesImageViewArray objectAtIndex:i]).tag == ChosenTagChosen) {
//               self.takePicturesArray addObject:<#(id)#>
//                [self.takePicturesURLArray removeObjectAtIndex:i];
                [takephotosArray  addObject:[self.takePicturesArray objectAtIndex:i]];
            }
        }
        [self.takePicturesURLArray removeAllObjects];
        
        for (int i=0; i < [takephotosArray count]; i++) {
            NSString *urlString = [NSString stringWithFormat:@"takePictureURL%d",i];
            NSURL *URL = [NSURL URLWithString:urlString];
            [self.takePicturesURLArray addObject:URL];
        }
        
        
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:self.chosenPhotos, PickedInfoImageArray, self.chosenPhotoURLs, PickedInfoImageURLArray,self.selectedImageViewsArray,PickedInfoImageViewArray,takephotosArray,PickedInfoTakePicturesArray ,self.selectedAllImageViewArray,PickedInfoSelectAllPictureArray,self.selectedAllURLArray,PickedInfoSelectAllURLArray,self.selectedAllImageArray,PickedInfoSelectAllImageArray,self.takePicturesURLArray,PickedInfoTakePicturesURLArray, nil];
        [self.delegate MC_ImagePickerViewController:self didFinishPickingImageWithInfo:dataDic];
//    }
    
    [self dismiss];
}



- (void)hasGetAllPicturesFromLibrary:(NSArray *)dataArray
{
    [self.indicatorView stopAnimating];
    [self cleanContent];
    [self showImagesWithData:dataArray];
}
- (void)cleanContent
{
    for (int n = 0; n < [self.imageViewsArray count]; n ++) {
        [[self.imageViewsArray objectAtIndex:n] removeFromSuperview];
    }
    
    [self.photosView setContentSize:self.photosView.frame.size];
    [self.lbTotalCount setText:@""];
    [self.imageURLsArray removeAllObjects];
    [self.imageViewsArray removeAllObjects];
    
    for (int n = 0; n < [self.panelImageViewsArray count]; n ++) {
        [[self.panelImageViewsArray objectAtIndex:n] removeFromSuperview];
    }
    [self.panelImageViewsArray removeAllObjects];
}


- (void)showImagesWithData:(NSArray *)imagesArray
{
    
    
        CGFloat fLeft = IMAGEVIEW_ORIGIN_X;
        CGFloat fTop = IMAGEVIEW_ORIGIN_Y;
        int nCount = 0;
        int nLineCount = 1;
        [self.takePicturesImageViewArray removeAllObjects];
        //    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:self.takePicturesArray];
        //    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:imagesArray];
        //    [imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //        [imageArray addObject:obj ];
        //    }];
        
        //    [self.takePicturesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //        [imageArray insertObject:obj atIndex:idx];
        //    }];
        
        NSInteger takePicturesCount = [self.takePicturesArray count];
        NSInteger photoscount = [imagesArray count];
        for (int n = 0; n < [imagesArray count]+1 + takePicturesCount; n ++) {
            
            //thumbnail
            CGFloat imageviewWidth = (self.view.frame.size.width - 5*IMAGEVIEW_HORIZONTALGAP)/4;
            CGFloat imageviewHeight = imageviewWidth;
            if (n == 0)//按钮
            {
                UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *phoneButtonImage = [UIImage imageNamed:@"camera"];
                [phoneButton setImage:phoneButtonImage forState:UIControlStateNormal];
                [phoneButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
                phoneButton.frame = CGRectMake(IMAGEVIEW_ORIGIN_X, IMAGEVIEW_ORIGIN_Y, imageviewWidth, imageviewHeight);
                [self.photosView addSubview:phoneButton];
                
            }
            else if (0 < n && n< takePicturesCount + 1 )//拍照的照片
            {
                
                NSString *urlString = [NSString stringWithFormat:@"takePictureURL%d",n-1];
                
                NSURL *URL = [NSURL URLWithString:urlString];
                
                UIImage *thumbnailImage = [self.takePicturesArray objectAtIndex:n-1];
                UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(fLeft, fTop, imageviewWidth, imageviewHeight)];
                [thumbnailView setImage:thumbnailImage];
                UIImage *phoneUnselect = [UIImage imageNamed:@"picture_selected"];
                [thumbnailView setTag:ChosenTagChosen];//0：未选择；1：已选择
                
                UIImageView *phoneUnselectImageview = [[UIImageView alloc]initWithImage:phoneUnselect];
                [phoneUnselectImageview setFrame:CGRectMake(imageviewWidth - 15, 0 , 15, 15)];
                [thumbnailView addSubview:phoneUnselectImageview];
                [thumbnailView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnTakeImageViewFromSender:)]];
                [thumbnailView setUserInteractionEnabled:YES];
                //replace selectedAllImageViewArray中相同url的imageview
                for (int i = 0; i< [self.selectedAllImageViewArray count]; i++) {
                    if ([URL   isEqual:[self.selectedAllURLArray objectAtIndex:i ]]) {
                        //                    phoneUnselect = [UIImage imageNamed:@"photoSelected"];
                        //                    [thumbnailView setTag:ChosenTagChosen];//0：未选择；1：已选择
                        [self.selectedAllImageViewArray replaceObjectAtIndex:i withObject:thumbnailView];
                    }
                }
                
                //            //replace selectedAllImageViewArray中相同url的imageview
                //            for (int i = 0; i< [self. count]; i++) {
                //                if ([URL   isEqual:[self.selectedAllURLArray objectAtIndex:i ]]) {
                //                    //                    phoneUnselect = [UIImage imageNamed:@"photoSelected"];
                //                    //                    [thumbnailView setTag:ChosenTagChosen];//0：未选择；1：已选择
                //                    [self.selectedAllImageViewArray replaceObjectAtIndex:i withObject:thumbnailView];
                //                }
                //            }
                
                [self.photosView addSubview:thumbnailView];
                [self.takePicturesImageViewArray addObject:thumbnailView];
                [self.imageViewsArray addObject:thumbnailView];
                [self.imageURLsArray addObject:urlString];
            }
            else//相册里选择的照片
            {
                if ([imagesArray count]<= 0) {
                    return;
                }
                //            ALAsset *photo = [imagesArray objectAtIndex:n - 1 - takePicturesCount];
                ALAsset *photo ;
                if (photoscount>0) {
                    photo = [imagesArray objectAtIndex:--photoscount];
                }
                
                //NSLog(@"%@",[photo valueForProperty:ALAssetPropertyDate]);
                //            if (takePicturesCount == 0) {
                //                photo = [imageArray objectAtIndex:n -1-takePicturesCount];
                //            }
                //            ALAsset *photo = [imageArray objectAtIndex:n -1-takePicturesCount];
                UIImage *thumbnailImage = [UIImage imageWithCGImage:[photo thumbnail]];
                UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(fLeft, fTop, imageviewWidth, imageviewHeight)];
                [thumbnailView setImage:thumbnailImage];
                UIImage *phoneUnselect = [UIImage imageNamed:@"picture_unselected"];
                
                //url
                NSURL *url = [photo valueForProperty:ALAssetPropertyAssetURL];
                [self.imageURLsArray addObject:url];
                
                
                [thumbnailView setTag:ChosenTagUnchosen];//0：未选择；1：已选择
                //replace selectedImageViewsArray中相同url的imageview
                for (int i = 0; i< [self.selectedImageViewsArray count]; i++) {
                    if ([url   isEqual:[self.chosenPhotoURLs objectAtIndex:i ]]) {
                        phoneUnselect = [UIImage imageNamed:@"picture_selected"];
                        [thumbnailView setTag:ChosenTagChosen];//0：未选择；1：已选择
                        [self.selectedImageViewsArray replaceObjectAtIndex:i withObject:thumbnailView];
                    }
                }
                //replace selectedAllImageViewArray中相同url的imageview
                for (int i = 0; i< [self.selectedAllImageViewArray count]; i++) {
                    if ([url   isEqual:[self.selectedAllURLArray objectAtIndex:i ]]) {
                        //                    phoneUnselect = [UIImage imageNamed:@"photoSelected"];
                        //                    [thumbnailView setTag:ChosenTagChosen];//0：未选择；1：已选择
                        [self.selectedAllImageViewArray replaceObjectAtIndex:i withObject:thumbnailView];
                    }
                }
                
                //            UIImage *phoneUnselect = [UIImage imageNamed:@"phoneUnselect"];
                UIImageView *phoneUnselectImageview = [[UIImageView alloc]initWithImage:phoneUnselect];
                [phoneUnselectImageview setFrame:CGRectMake(imageviewWidth - 15, 0 , 15, 15)];
                [thumbnailView addSubview:phoneUnselectImageview];
                [thumbnailView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnImageViewFromSender:)]];
                [thumbnailView setUserInteractionEnabled:YES];
                //        [thumbnailView setTag:ChosenTagUnchosen];//0：未选择；1：已选择
                [self.photosView addSubview:thumbnailView];
                [self.imageViewsArray addObject:thumbnailView];
                //        //url
                //        NSURL *url = [photo valueForProperty:ALAssetPropertyAssetURL];
                //        [self.imageURLsArray addObject:url];
            }
            fLeft = fLeft + imageviewWidth + IMAGEVIEW_HORIZONTALGAP;
            nCount ++;
            if (nCount >= 4) {
                nCount = 0;
                fLeft = IMAGEVIEW_ORIGIN_X;
                fTop = fTop + imageviewWidth + IMAGEVIEW_VERTICALGAP;
            }
            
            if (n>=4 &&nCount==1) {
                nLineCount ++;
            }
        }
        
        //content size
        CGFloat iamgeviewWidth = (self.view.frame.size.width - 5*IMAGEVIEW_HORIZONTALGAP)/4;
        int nTotalHeight = (nLineCount * iamgeviewWidth) + ((nLineCount + 1) * IMAGEVIEW_VERTICALGAP);
        int nOffset = nTotalHeight - self.photosView.contentSize.height;
        if (nOffset >= 0) {
            [self.photosView setContentSize:CGSizeMake(self.photosView.frame.size.width, nTotalHeight )];
        }

}

/**
 *  点击拍照的部分图片
 *
 *  @param sender UIImageView
 */
- (void)didTappedOnTakeImageViewFromSender:(UITapGestureRecognizer *)sender
{
    CGFloat imageviewWidth = (self.view.frame.size.width - 5*IMAGEVIEW_HORIZONTALGAP)/4;
    UIImageView *currentView = (UIImageView *)sender.view;
    switch (currentView.tag) {
        case ChosenTagChosen:
        {
            currentView.tag = ChosenTagUnchosen;
            [[currentView.subviews objectAtIndex:0] removeFromSuperview];
            //change image
            for (UIImageView *view in currentView.subviews) {
                [view removeFromSuperview];
            }
            UIImage *phoneUnselect = [UIImage imageNamed:@"picture_unselected"];
            UIImageView *phoneUnselectImageview = [[UIImageView alloc]initWithImage:phoneUnselect];
            [phoneUnselectImageview setFrame:CGRectMake(imageviewWidth - 15, 0 , 15, 15)];
            [currentView addSubview:phoneUnselectImageview];
            
            
            NSInteger indexAll = [self.selectedAllImageViewArray indexOfObject:currentView];
            [self.selectedAllImageViewArray removeObjectAtIndex:indexAll];
            [self.selectedAllURLArray removeObjectAtIndex:indexAll];
            [self.selectedAllImageArray removeObjectAtIndex:indexAll];
            
            
        }
            break;
        case ChosenTagUnchosen:
        {
            if ([self.chosenPhotos count] + [self.takePicturesArray count] >= maxNum) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择十张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            
            currentView.tag = ChosenTagChosen;
            [self.selectedAllImageViewArray addObject:currentView];
            
            //change image
            for (UIImageView *view in currentView.subviews) {
                [view removeFromSuperview];
            }
            UIImage *photoSelected = [UIImage imageNamed:@"picture_selected"];
            UIImageView *photoSelectedImageview = [[UIImageView alloc]initWithImage:photoSelected];
            [photoSelectedImageview setFrame:CGRectMake(imageviewWidth - 15, 0 , 15, 15)];
            [currentView addSubview:photoSelectedImageview];
//            //add to array
            UIImage *imageChosen = [currentView image];
            [self.selectedAllImageArray  addObject:imageChosen];
            NSInteger index = [self.imageViewsArray indexOfObject:currentView];
            NSURL *url = [self.imageURLsArray objectAtIndex:index];
            [self.selectedAllURLArray addObject:url];
            
            
        }
            break;
        default:
            break;
    }
}

/**
 *  点击相片选择的部分图片
 *
 *  @param sender UIImageView
 */
- (void)didTappedOnImageViewFromSender:(UITapGestureRecognizer *)sender
{
    CGFloat imageviewWidth = (self.view.frame.size.width - 5*IMAGEVIEW_HORIZONTALGAP)/4 ;
    UIImageView *currentView = (UIImageView *)sender.view;
    switch (currentView.tag) {
        case ChosenTagChosen:
        {
            
            
            
            currentView.tag = ChosenTagUnchosen;
            [[currentView.subviews objectAtIndex:0] removeFromSuperview];
            //change image
            for (UIImageView *view in currentView.subviews) {
                [view removeFromSuperview];
            }
            UIImage *phoneUnselect = [UIImage imageNamed:@"picture_unselected"];
            UIImageView *phoneUnselectImageview = [[UIImageView alloc]initWithImage:phoneUnselect];
            [phoneUnselectImageview setFrame:CGRectMake(imageviewWidth - 15, 0 , 15, 15)];
            [currentView addSubview:phoneUnselectImageview];
            

            NSInteger index = [self.selectedImageViewsArray indexOfObject:currentView];
            [self.chosenPhotos removeObjectAtIndex:index];
            [self.chosenPhotoURLs removeObjectAtIndex:index];
            [self.selectedImageViewsArray removeObjectAtIndex:index];
            
            NSInteger indexAll = [self.selectedAllImageViewArray indexOfObject:currentView];
            [self.selectedAllImageViewArray removeObjectAtIndex:indexAll];
            [self.selectedAllURLArray removeObjectAtIndex:indexAll];
             [self.selectedAllImageArray  removeObjectAtIndex:indexAll];
            
        }
            break;
        case ChosenTagUnchosen:
        {
            if ([self.chosenPhotos count] + [self.takePicturesArray count] >= maxNum) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择十张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            
            currentView.tag = ChosenTagChosen;
            [self.selectedImageViewsArray addObject:currentView];
            [self.selectedAllImageViewArray  addObject:currentView];
            
            //change image
            for (UIImageView *view in currentView.subviews) {
                [view removeFromSuperview];
            }
            UIImage *photoSelected = [UIImage imageNamed:@"picture_selected"];
            UIImageView *photoSelectedImageview = [[UIImageView alloc]initWithImage:photoSelected];
            [photoSelectedImageview setFrame:CGRectMake(imageviewWidth - 15, 0 , 15, 15)];
            [currentView addSubview:photoSelectedImageview];
            //add to array
            UIImage *imageChosen = [currentView image];
            [self.chosenPhotos addObject:imageChosen];
            [self.selectedAllImageArray  addObject:imageChosen];
            
            NSInteger index = [self.imageViewsArray indexOfObject:currentView];
            NSURL *url = [self.imageURLsArray objectAtIndex:index];
            [self.chosenPhotoURLs addObject:url];
            
            [self.selectedAllURLArray addObject:url];
            
            
            
        }
            break;
        default:
            break;
    }
}


- (void)addImageViewToChosenPanel:(UIImage *)image
{
    NSInteger currentCount = [self.chosenPhotos count];
    NSInteger currentOffset = (currentCount * IMAGEVIEW_SIZE_WIDTH) + (IMAGEVIEW_HORIZONTALGAP * currentCount);
    
    UIImageView *chooseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentOffset, 0.0, IMAGEVIEW_SIZE_WIDTH, IMAGEVIEW_SIZE_HEIGHT)];
    [chooseImageView setImage:image];
    [chooseImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnImageViewFromChosenPanel:)]];
    [chooseImageView setUserInteractionEnabled:YES];
    [self.chosenImagePanel addSubview:chooseImageView];
    [self.panelImageViewsArray addObject:chooseImageView];
    
    if (currentOffset >= [self.chosenImagePanel contentSize].width) {
        [self.chosenImagePanel setContentSize:CGSizeMake(self.chosenImagePanel.contentSize.width + IMAGEVIEW_SIZE_WIDTH + IMAGEVIEW_HORIZONTALGAP, self.chosenImagePanel.contentSize.height)];
        [self.chosenImagePanel setContentOffset:CGPointMake(currentOffset - (IMAGEVIEW_SIZE_WIDTH * 2) - (IMAGEVIEW_HORIZONTALGAP * 2), 0.0) animated:YES];
    }
}


- (void)didTappedOnImageViewFromChosenPanel:(UITapGestureRecognizer *)sender
{
    UIImageView *currentView = (UIImageView *)sender.view;
    //remove from data array
    NSInteger index = [self.panelImageViewsArray indexOfObject:currentView];
    [self.panelImageViewsArray removeObjectAtIndex:index];
    [self.chosenPhotos removeObjectAtIndex:index];
    [self.chosenPhotoURLs removeObjectAtIndex:index];
    //remove from view
    [currentView removeFromSuperview];
    UIImageView *imageView = [self.selectedImageViewsArray objectAtIndex:index];
    [[imageView.subviews objectAtIndex:0] removeFromSuperview];
    [imageView setTag:ChosenTagUnchosen];
    [self.selectedImageViewsArray removeObjectAtIndex:index];

    //resize content
    [self resizeChosenPanel];
}


- (void)resizeChosenPanel
{
    NSInteger nCount = [self.panelImageViewsArray count];
    CGFloat currentOffset = (nCount * IMAGEVIEW_SIZE_WIDTH) + (IMAGEVIEW_HORIZONTALGAP * nCount);
    
    for (int n = 0; n < nCount; n ++) {
        [[self.panelImageViewsArray objectAtIndex:n] setFrame:CGRectMake((IMAGEVIEW_SIZE_WIDTH + IMAGEVIEW_HORIZONTALGAP) * n, 0.0, IMAGEVIEW_SIZE_WIDTH, IMAGEVIEW_SIZE_HEIGHT)];
    }
    if (nCount <= 0) {
        [self.chosenImagePanel setContentOffset:CGPointMake(0.0, 0.0)];
        [self.chosenImagePanel setContentSize:self.chosenImagePanel.frame.size];
    } else {
        [self.chosenImagePanel setContentOffset:CGPointMake(currentOffset, 0.0)];
        [self.chosenImagePanel setContentSize:CGSizeMake(self.chosenImagePanel.contentSize.width - IMAGEVIEW_SIZE_WIDTH - IMAGEVIEW_HORIZONTALGAP, self.chosenImagePanel.contentSize.height)];
    }
}

//- (void)savePhotoArray
//{
////    NSMutableArray *array = [[NSMutableArray alloc]init];
////    array = [self.selectedImageViewsArray  mutableCopy];
//    NSArray * array = [NSArray arrayWithArray:self.selectedImageViewsArray];
//    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//    [userdefault setObject:array forKey:SAIDAN_PHOTOARRAY_USERDEFAULT];
//    [userdefault synchronize];
//}
//
//- (void)readPhotoArray
//{
//   
//    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//    self.selectedImageViewsArray = [NSMutableArray arrayWithArray:[userdefault objectForKey:SAIDAN_PHOTOARRAY_USERDEFAULT]];
//
//    NSInteger count = [self.selectedImageViewsArray count];
//}


#pragma mark getAllPicturesFromPhotoLibrary
- (void)getAllPicturesFromPhotoLibrary
{
//    NSMutableArray *tempTotalArray = [[NSMutableArray alloc] init];
   // NSMutableSet *temptotalSet = [[NSMutableSet alloc]init];
    NSMutableDictionary *temporateDictionary = [[NSMutableDictionary alloc]init];
    //get photos assets
    void (^assetsEnumerator) (ALAsset *, NSUInteger, BOOL *) = ^ (ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (!result) {
            if (index == NSNotFound/* && *stop == NO*/) {
                //enum done
                NSArray *userArray = [temporateDictionary  allValues];
//               NSMutableArray * tempTotalArray = [NSMutableArray arrayWithArray:userArray];
//               [ userArray u:^NSComparisonResult(id obj1, id obj2) {
//                   NSDate  *date1  = [(ALAsset *)obj1 valueForProperty:ALAssetPropertyDate];
//                    NSDate  *date2  = [(ALAsset *)obj2 valueForProperty:ALAssetPropertyDate];
//                    [date1 earlierDate:date2];
//               }];
              userArray =  [userArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSDate  *date1  = [(ALAsset *)obj1 valueForProperty:ALAssetPropertyDate];
                     NSDate  *date2  = [(ALAsset *)obj2 valueForProperty:ALAssetPropertyDate];
                    return [date1 compare:date2];
              }];
                
//                NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:[photo valueForProperty:ALAssetPropertyDate] ascending:YES];
//                NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
//                NSArray *userArray = [temptotalSet sortedArrayUsingDescriptors:sortDescriptors];
                [self hasGetAllPicturesFromLibrary:userArray];
            }
            return;
        }
        if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
            [temporateDictionary setObject:result forKey:[(ALAsset *)result valueForProperty:ALAssetPropertyAssetURL]];
//            [temptotalSet addObject:result];
            //            [tempTotalArray addObject:result];
            
            //NSLog(@"%@",[(ALAsset *)result valueForProperty:ALAssetPropertyAssetURL]);
        }
    };
    //get photo groups
    void (^assetsGroupsEnumerator)(ALAssetsGroup *, BOOL *) = ^ (ALAssetsGroup *group, BOOL *stop)
    {
        if (group == nil) {
            return;
        }
        
        //        NSString *assetsGroup = [NSString stringWithFormat:@"%@",group];//获取相簿的组
        //        NSString *groupInfo = [assetsGroup substringFromIndex:16 ] ;
        //        NSArray *arr = [[NSArray alloc] init];
        //        arr = [groupInfo componentsSeparatedByString:@","];
        //        NSString *groupType = [[arr objectAtIndex:1] substringFromIndex:6];
        //        if ([groupType isEqualToString:@"Album"]) {
        //
        //            [group enumerateAssetsUsingBlock:assetsEnumerator];
        //        }
        [group enumerateAssetsUsingBlock:assetsEnumerator];
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetsGroupsEnumerator failureBlock:^(NSError *){
        NSLog(@"Get saved photos failed.");}];
}


- (void)MC_PhotoAlbumViewController:(MC_PhotoAlbumViewController *)albumViewController didChooseAlbumGroup:(ALAssetsGroup *)group
{
    [self.indicatorView startAnimating];
    NSMutableArray *tempTotalArray = [[NSMutableArray alloc] init];
    
    //get photos assets
    void (^assetsEnumerator) (ALAsset *, NSUInteger, BOOL *) = ^ (ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (result == nil) {
            if (index == NSNotFound && *stop == NO) {
                //enum done
                [self hasGetAllPicturesFromLibrary:tempTotalArray];
            }
            return;
        }
        
        if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
            
            [tempTotalArray addObject:result];
        }
    };
    
    [group enumerateAssetsUsingBlock:assetsEnumerator];
}

#pragma mark systemn method

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//    [self getAllPicturesFromPhotoLibrary];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     [self getAllPicturesFromPhotoLibrary];
//    [self readPhotoArray];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
//    [self savePhotoArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initView];
//    [self getAllPicturesFromPhotoLibrary];
    [self addObservers];
    
//    [self savePhotoArray];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeObservers];
}

#pragma mark  NSNotificationCenter
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForegroundReload) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)enterForegroundReload
{
    [self getAllPicturesFromPhotoLibrary];
//    [self getAllPictures];
//      [self getAlumList];
    
}

#pragma mark take photo

-(void)takePhoto
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        //                     contentimageview.image=chosenImage;
        [self.takePicturesArray addObject:chosenImage];
        [self.selectedAllImageArray addObject:chosenImage];
       
//        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:self.chosenPhotos, PickedInfoImageArray, self.chosenPhotoURLs, PickedInfoImageURLArray,self.selectedImageViewsArray,PickedInfoImageViewArray,self.takePicturesArray,PickedInfoTakePicturesArray ,nil];
        
//        //删除拍照的照片中没被选择的照片
//        NSMutableArray *takephotosArray = [[NSMutableArray alloc]init];
//        for (int i = 0; i < [self.takePicturesImageViewArray count]; i++) {
//            
//            if (((UIImageView *)[self.takePicturesImageViewArray objectAtIndex:i]).tag == ChosenTagChosen) {
//                //               self.takePicturesArray addObject:<#(id)#>
//                [takephotosArray  addObject:[self.takePicturesArray objectAtIndex:i]];
//            }
//        }
//        [self.takePicturesURLArray removeAllObjects];
        NSMutableArray *takepicURLArray = [[NSMutableArray alloc]init];
        for (int i=0; i < [self.takePicturesURLArray count]; i++) {
            NSString *urlString = [NSString stringWithFormat:@"takePictureURL%d",i];
            NSURL *URL = [NSURL URLWithString:urlString];
            [takepicURLArray addObject:URL];
        }
        [self.takePicturesURLArray removeAllObjects];
        self.takePicturesURLArray =[takepicURLArray mutableCopy];
        //创建imagview
        
        NSInteger n = [self.takePicturesArray count] + 1;
        NSString *urlString = [NSString stringWithFormat:@"takePictureURL%ld",n-2];
        NSURL *URL = [NSURL URLWithString:urlString];
         [self.selectedAllURLArray addObject:URL];
        [self.takePicturesURLArray addObject:URL];
        CGFloat fLeft = IMAGEVIEW_ORIGIN_X;
        CGFloat fTop = IMAGEVIEW_ORIGIN_Y;
        CGFloat imageviewWidth = (self.view.frame.size.width - 5*IMAGEVIEW_HORIZONTALGAP)/4;
        CGFloat imageviewHeight = imageviewWidth;
        if (n%4 == 0) {
            fLeft = IMAGEVIEW_ORIGIN_X + (IMAGEVIEW_ORIGIN_X + imageviewWidth)*3;
        }
        else
        {
            fLeft = IMAGEVIEW_ORIGIN_X + (IMAGEVIEW_ORIGIN_X + imageviewWidth)*(n%4 -1);
        }
        NSInteger m = 0;
        if (n == 4) {
            m = 0;
        }
        else if(n == 8)
        {
            m = 1;
        }
        else
        {
            m = n/4;
        }
        fTop = IMAGEVIEW_ORIGIN_X + (IMAGEVIEW_ORIGIN_X + imageviewWidth)*m;
        UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(fLeft, fTop, imageviewWidth, imageviewHeight)];
        [thumbnailView setImage:chosenImage];
        UIImage *phoneUnselect = [UIImage imageNamed:@"picture_selected"];
        [thumbnailView setTag:ChosenTagChosen];//0：未选择；1：已选择
        
        UIImageView *phoneUnselectImageview = [[UIImageView alloc]initWithImage:phoneUnselect];
        [phoneUnselectImageview setFrame:CGRectMake(imageviewWidth - 15, 0 , 15, 15)];
        [thumbnailView addSubview:phoneUnselectImageview];
        [thumbnailView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnTakeImageViewFromSender:)]];
        [thumbnailView setUserInteractionEnabled:YES];
        [self.selectedAllImageViewArray addObject:thumbnailView];
        
        
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:self.chosenPhotos, PickedInfoImageArray, self.chosenPhotoURLs, PickedInfoImageURLArray,self.selectedImageViewsArray,PickedInfoImageViewArray,self.takePicturesArray,PickedInfoTakePicturesArray ,self.selectedAllImageViewArray,PickedInfoSelectAllPictureArray,self.selectedAllURLArray,PickedInfoSelectAllURLArray,self.selectedAllImageArray,PickedInfoSelectAllImageArray,self.takePicturesURLArray,PickedInfoTakePicturesURLArray, nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(getTakePicturePhoto:photosDictionary:)]) {
            [self.delegate getTakePicturePhoto:chosenImage photosDictionary:dataDic];
        }
    }
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self dismiss];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewControllerWillDismiss:)]) {
        [self.delegate pickerViewControllerWillDismiss:self];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
        picker.allowsEditing=NO;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)dismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewControllerWillDismiss:)]) {
        [self.delegate pickerViewControllerWillDismiss:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
