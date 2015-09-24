//
//  SaidanPhotoView.m
//  ICSON
//
//  Created by 肖晓春 on 15/5/13.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import "SaiDanPhotoView.h"
#import "MC_ImagePickerViewController.h"
#import "PhotoItem.h"
#import "UIImage+GImageExtension.h"
@interface SaiDanPhotoView()<MC_ImagePickerViewControllerDelegate>
@property(strong,nonatomic) NSMutableArray *photosArray;
@property (nonatomic, strong) NSMutableArray *thumImageArray;
//@property (nonatomic ,strong)IcsonImageView *
@end

@implementation SaiDanPhotoView

/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/
#pragma mark Initialization

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        SaiDanPhotoView *saidanPhotoView = [self getObjectFromNibWithClass:[self class]];
        [self replaceAutolayoutConstrainsFromView:self toView:saidanPhotoView];
        [self buildSubviews];
        return saidanPhotoView;
    }
    bLoad = NO;
    return self;
}

- (void)replaceAutolayoutConstrainsFromView:(UIView *)placeholderView toView:(UIView *)realView
{
    realView.autoresizingMask = placeholderView.autoresizingMask;
    realView.translatesAutoresizingMaskIntoConstraints = placeholderView.translatesAutoresizingMaskIntoConstraints;
    
    // Copy autolayout constrains from placeholder view to real view
    if (placeholderView.constraints.count > 0) {
        
        // We only need to copy "self" constraints (like width/height constraints)
        // from placeholder to real view
        for (NSLayoutConstraint *constraint in placeholderView.constraints) {
            
            NSLayoutConstraint* newConstraint;
            
            // "Height" or "Width" constraint
            // "self" as its first item, no second item
            if (!constraint.secondItem) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:nil
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            // "Aspect ratio" constraint
            // "self" as its first AND second item
            else if ([constraint.firstItem isEqual:constraint.secondItem]) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:realView
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            
            // Copy properties to new constraint
            if (newConstraint) {
                newConstraint.shouldBeArchived = constraint.shouldBeArchived;
                newConstraint.priority = constraint.priority;
                if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
                    newConstraint.identifier = constraint.identifier;
                }
                [realView addConstraint:newConstraint];
            }
        }
    }
}
//
- (id)getObjectFromNibWithClass:(Class)class {
    
    NSString *className = NSStringFromClass(class);
    
    NSArray *topObjArray = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    
    for (id anObj in topObjArray) {
        if ([anObj isKindOfClass:class]) {
            return anObj;
        }
    }
    
    return nil;
}


#pragma mark Self Methods
- (void)buildSubviews
{
    self.addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"addPhoto"];
    [self.addPhotoBtn setBackgroundImage:image forState:UIControlStateNormal];
    CGFloat imageWidth = (SCREEN_WIDTH - 5*10 )/4;
    self.addPhotoBtn.frame = CGRectMake(10, 10, imageWidth, imageWidth);
    [self addSubview:self.addPhotoBtn];
//    [self.addPhotoBtn addTarget:self action:@selector(takePhotos) forControlEvents:UIControlEventTouchUpInside];
}



- (void)resetProductReviewImageViews:(NSArray *)imagesArray thumbnailArray:(NSArray *)thumbnailArray
{
    self.addPhotoBtn.hidden = YES;
    self.thumImageArray = [[NSMutableArray alloc]init];
    
    
//    imagesArray = [[NSArray alloc] initWithObjects:
//                   @"http://img10.360buyimg.com/yixun_zdm/jfs/t1147/344/1068901203/124511/81aa785b/556c2501Nfe3e8dbc.jpg",
//                   @"http://img10.360buyimg.com/yixun_zdm/jfs/t1570/257/272340806/87680/a2a6718d/556c251bN6c90dc9b.jpg",
//                   @"http://img10.360buyimg.com/yixun_zdm/jfs/t1384/313/260216069/109713/7db72bef/556c251cN39be39c2.jpg",
//                   @"http://img10.360buyimg.com/yixun_zdm/jfs/t1417/193/262889483/118695/c201814f/556c2520N365c0126.jpg",
//                   @"http://img10.360buyimg.com/yixun_zdm/jfs/t1147/344/1068901203/124511/81aa785b/556c2501Nfe3e8dbc.jpg",nil];
//    thumbnailArray = [NSArray arrayWithArray:imagesArray];
    
    
    for (UIView *views in self.subviews) {
        [views removeFromSuperview];
    }
    //add photos
    CGFloat imageGap = 10;
    CGFloat imageWidth = (SCREEN_WIDTH - 10 - 5*imageGap )/4;
    CGFloat imageHeight = imageWidth;
    CGFloat imageTop = imageGap;
    CGFloat imageLeft = imageGap;
    NSInteger imagecount = [thumbnailArray count];
    for (int i = 0; i< imagecount; i++) {
        imageTop =   i/4*(imageWidth + imageGap);
        imageLeft = (i%4)*(imageHeight + imageGap)+imageGap;
            UIImageView *imageView = [[UIImageView alloc]init];
        
        __weak UIImageView *weakBanner = imageView;
        [weakBanner setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[thumbnailArray objectAtIndex:i]]] placeholderImage:PLACEHOLDERIMAGE_SMALL success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            if (image.size.height < image.size.width) {
                
              weakBanner.image  = [ image imageByScalingProportionallyToMinimumSize:CGSizeMake(imageWidth, imageWidth)];
                
            }
            else if(image.size.height > image.size.width){
                
                weakBanner.image  = [ image imageByScalingProportionallyToMinimumSize:CGSizeMake(imageWidth, imageWidth)];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        } ];
        
        
        imageView.frame = CGRectMake(imageLeft, imageTop, imageWidth, imageHeight);
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
        [imageView addGestureRecognizer:tap];
        
        //        //初始化图片model
        PhotoItem *zoomItem = [[PhotoItem alloc] initWithImageView:imageView];
        zoomItem.urlString = [imagesArray objectAtIndex:i];
        zoomItem.tag = i;
        
        
        [self addSubview:weakBanner];
        [self.thumImageArray addObject:zoomItem];
    }
    //add button
//    imageTop = imageGap;
//    imageLeft = imageGap;
//    imageTop += (imagecount/4)*(imageWidth + imageGap)+2*imageGap;
//    imageLeft = imageGap + (imagecount%4)*(imageHeight + imageGap);
//    self.addPhotoBtn.hidden = YES;
//    [self addSubview:self.addPhotoBtn];
    
    [self setProductReviewPhotoHeight:imagecount];
}




//- (void)resetProductReviewImageViews:(NSArray *)imagesArray thumbnailArray:(NSArray *)thumbnailArray
//{
//    self.addPhotoBtn.hidden = YES;
//    self.thumImageArray = [[NSMutableArray alloc]init];
//    
//
//    
////    NSArray *array = [[NSArray alloc] initWithObjects:@"http://img10.360buyimg.com/yixun_zdm/jfs/t1303/99/338230831/6015/32e0b3bb/55695f07N86ea0796.jpg",@"http://img10.360buyimg.com/yixun_zdm/jfs/t1147/344/1068901203/124511/81aa785b/556c2501Nfe3e8dbc.jpg",@"http://img10.360buyimg.com/yixun_zdm/jfs/t1570/257/272340806/87680/a2a6718d/556c251bN6c90dc9b.jpg",@"http://img10.360buyimg.com/yixun_zdm/jfs/t1384/313/260216069/109713/7db72bef/556c251cN39be39c2.jpg",@"http://img10.360buyimg.com/yixun_zdm/jfs/t1417/193/262889483/118695/c201814f/556c2520N365c0126.jpg",@"http://img10.360buyimg.com/yixun_zdm/jfs/t1147/344/1068901203/124511/81aa785b/556c2501Nfe3e8dbc.jpg",@"http://img10.360buyimg.com/yixun_zdm/jfs/t1570/257/272340806/87680/a2a6718d/556c251bN6c90dc9b.jpg",nil];
//    
//
//    for (UIView *views in self.subviews) {
//        [views removeFromSuperview];
//    }
//    //add photos
//    CGFloat imageGap = 4;
//    CGFloat imageWidth = (SCREEN_WIDTH -15 - 5*imageGap )/4;
//    CGFloat imageHeight = imageWidth;
//    CGFloat imageTop = imageGap;
//    CGFloat imageLeft = imageGap;
//    NSInteger imagecount = [thumbnailArray count];
//    for (int i = 0; i< imagecount; i++) {
////        __block UIImage *image = [[UIImage alloc]init];
////        image =[self.photosArray objectAtIndex:i];
//        imageTop =   i/4*(imageWidth + imageGap);
//        imageLeft = (i%4)*(imageHeight + imageGap)+imageGap;
////        UIImageView *imageView = [[UIImageView alloc]init];
//        
//        IcsonImageView *imageView = [[IcsonImageView alloc]init];
//
//        
//        [imageView loadAsyncImage:[thumbnailArray objectAtIndex:i]];
//        imageView.frame = CGRectMake(imageLeft, imageTop, imageWidth, imageHeight);
//        imageView.tag = i;
//        imageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
//        [imageView addGestureRecognizer:tap];
//        
////        //初始化图片model
//        PhotoItem *zoomItem = [[PhotoItem alloc] initWithImageView:imageView.imgView];
//        zoomItem.urlString = [imagesArray objectAtIndex:i];
//        zoomItem.tag = i;
//
//        
//        [self addSubview:imageView];
//        [self.thumImageArray addObject:zoomItem];
//    }
//    //add button
//    imageTop = imageGap;
//    imageLeft = imageGap;
//    imageTop += (imagecount/4)*(imageWidth + imageGap)+2*imageGap;
//    imageLeft = imageGap + (imagecount%4)*(imageHeight + imageGap);
////    self.addPhotoBtn.frame = CGRectMake(imageLeft, imageTop, imageWidth, imageHeight);
//    self.addPhotoBtn.hidden = YES;
//    [self addSubview:self.addPhotoBtn];
//
//    [self setProductReviewPhotoHeight:imagecount];
//}

- (void)resetImageViews:(NSDictionary *)dic andArray :(NSArray *)imagesArray
{
     self.addPhotoBtn.hidden = NO;
    
    self.addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"addPhoto"];
    [self.addPhotoBtn setBackgroundImage:image forState:UIControlStateNormal];
    self.thumImageArray = [[NSMutableArray alloc]init];

    self.photosArray = [[dic objectForKey:PickedInfoSelectAllImageArray]mutableCopy] ;
    
    NSArray *uRLarray = [[dic objectForKey:PickedInfoSelectAllURLArray]mutableCopy] ;
    self.addPhotoBtn.hidden = NO;
    for (UIView *views in self.subviews) {
        [views removeFromSuperview];
    }
    //add photos
    CGFloat imageTopGap = 10;
    CGFloat imageGap = 10;
    CGFloat imageWidth = (SCREEN_WIDTH - 5*imageGap )/4;
    CGFloat imageHeight = imageWidth;
    CGFloat imageTop = imageGap;
    CGFloat imageLeft = imageGap;
    NSInteger imagecount = [self.photosArray count];
    int i = 0;
    for (; i< imagecount; i++) {
        __block UIImage *image = [[UIImage alloc]init];
        image =[self.photosArray objectAtIndex:i];
        imageTop =   i/4*(imageWidth + imageGap)+ imageTopGap;
        imageLeft = (i%4)*(imageHeight + imageGap)+imageGap;
        UIImageView *imageView = [[UIImageView alloc]init];
        

        NSString * tempString = [[uRLarray objectAtIndex:i] absoluteString];
        NSRange range = [tempString rangeOfString:@"takePictureURL"];//判断字符串是否包含
        if (range.location ==NSNotFound)//不包含
        {
             imageView = [[UIImageView alloc]initWithImage:[self.photosArray objectAtIndex:i]];
        }
        else{
            imageView = [[UIImageView alloc]initWithImage:[ [self.photosArray objectAtIndex:i] imageByScalingProportionallyToMinimumSize:CGSizeMake(imageWidth, imageWidth)]];
            
//             imageView = [[UIImageView alloc]initWithImage:[self scaleImage:[self.photosArray objectAtIndex:i] toScale:0.1]];
        }
        imageView.frame = CGRectMake(imageLeft, imageTop, imageWidth, imageHeight);
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
        [imageView addGestureRecognizer:tap];
        
        //初始化图片model
        PhotoItem *zoomItem = [[PhotoItem alloc] initWithImageView:imageView];
        //        [self scaleImage:image toScale:0.33];
        zoomItem.hignImage = [self scaleImage:image toScale:0.33];
        zoomItem.tag = i;
 
        if (range.location ==NSNotFound)//不包含
        {
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:uRLarray[i] resultBlock:^(ALAsset *asset)
             {
                 ALAssetRepresentation* representation = [asset defaultRepresentation];
                 image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                 if (image) {
                     zoomItem.hignImage = image;
                 }
                 else{
                     zoomItem.hignImage = [self.photosArray objectAtIndex:i];
                 }
                 
             }failureBlock:^(NSError *err) {
                 NSLog(@"Error: %@",[err localizedDescription]);
             }];
        }

        [self addSubview:imageView];
        [self.thumImageArray addObject:zoomItem];
    }
    //add button
    imageTop =   i/4*(imageWidth + imageGap)+ imageTopGap;
    imageLeft = (i%4)*(imageHeight + imageGap)+imageGap;
    self.addPhotoBtn.frame = CGRectMake(imageLeft, imageTop, imageWidth, imageHeight);
    [self.addPhotoBtn addTarget:self action:@selector(touchTakephotos:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addPhotoBtn];
    if (imagecount >= 10) {
        self.addPhotoBtn.hidden = YES;
    }
    [self setsaiDanPhotoHeight:imagecount];
}



- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;
                                
}


- (void)setProductReviewPhotoHeight : (NSInteger)photoCount{
    CGFloat imageTopGap = 4;
    CGFloat imageBottomGap = 4;
    CGFloat imageGap = 4;
    CGFloat imageheight = (SCREEN_WIDTH - 5*imageGap )/4;
    CGFloat height = photoCount/4*(imageheight+imageGap) + imageheight+imageTopGap +imageBottomGap ;
    //    self.frame = CGRectMake(0, 298, SCREEN_WIDTH, height);
    self.productReviewPhotoViewHeight = height;
//    //刷新高度
//    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshSaiDanPhotoViewHeight)]) {
//        [self.delegate refreshSaiDanPhotoViewHeight];
//    }
}

- (void)setsaiDanPhotoHeight : (NSInteger)photoCount{
    CGFloat imageTopGap = 10;
    CGFloat imageBottomGap = 10;
    CGFloat imageGap = 10;
    CGFloat imageheight = (SCREEN_WIDTH - 5*imageGap )/4;
    CGFloat height = photoCount/4*(imageheight+imageGap) + imageheight+imageTopGap +imageBottomGap ;
//    self.frame = CGRectMake(0, 298, SCREEN_WIDTH, height);
    self.saiDanPhotoViewHeight = height;
    //刷新高度
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshSaiDanPhotoViewHeight)]) {
        [self.delegate refreshSaiDanPhotoViewHeight];
    }
}


- (void)imageViewClick:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(imageClick:thumImageArray:atIndex:)])
    {
        UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
        NSLog(@"%@",NSStringFromCGRect(((PhotoItem *)self.thumImageArray[0]).itemFrame));
        [self.delegate imageClick:imageView thumImageArray:self.thumImageArray atIndex:imageView.tag ];
    }
}

- (IBAction)touchTakephotos:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SaiDanTakePhotos)]) {
        [self.delegate SaiDanTakePhotos];
    }
}







@end
