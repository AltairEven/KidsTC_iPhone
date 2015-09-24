//
//  OrderCommentViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderCommentViewController.h"
#import "OrderCommentView.h"
#import "OrderCommentBottomView.h"
#import "MC_ImagePickerViewController.h"
#import "MWPhotoBrowser.h"
#import "ServiceDetailViewController.h"
#import "KTCImageUploader.h"

@interface OrderCommentViewController () <OrderCommentViewDelegate, OrderCommentBottomViewDelegate, MC_ImagePickerViewControllerDelegate, MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet OrderCommentView *commentView;
//@property (weak, nonatomic) IBOutlet OrderCommentBottomView *bottomView;

@property (nonatomic, strong) OrderCommentModel *commentModel;

@property (nonatomic, strong) HttpRequestClient *submitCommentRequest;

@property (strong, nonatomic)  NSArray *photoArray;
@property (strong, nonatomic)  NSDictionary *photoDictionary;
@property (nonatomic, strong) NSDictionary *produceInfo;

@property (nonatomic, strong) NSArray *mwPhotosArray;

- (void)makeMWPhotoFromImageUrlArray:(NSArray *)urlArray;

- (BOOL)isValidateComment;

- (void)getNeedUploadPhotosArray:(void(^)(NSArray *photosArray))finished;

- (void)submitComments;

- (void)submitCommentSucceed:(NSDictionary *)data;

- (void)submitCommentFailed:(NSError *)error;

@end

@implementation OrderCommentViewController

- (instancetype)initWithOrderCommentModel:(OrderCommentModel *)model {
    self = [super initWithNibName:@"OrderCommentViewController" bundle:nil];
    if (self) {
        self.commentModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"服务评价";
    // Do any additional setup after loading the view from its nib.
    [self.commentView setCommentModel:self.commentModel];
    self.commentView.delegate = self;
    [self.commentView reloadData];
    
//    self.bottomView.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.commentView endEditing];
}

#pragma mark OrderCommentViewDelegate

- (void)didClickedAddPhotoButtonOnOrderCommentView:(OrderCommentView *)commentView {
    MC_ImagePickerViewController *mc_PhotoAlbumViewController = [[MC_ImagePickerViewController alloc]initWithMaxCount:10 andPhotoDictionary:self.photoDictionary];
    mc_PhotoAlbumViewController.hidesBottomBarWhenPushed = YES;
    mc_PhotoAlbumViewController.delegate = self;
    [self.navigationController presentViewController:mc_PhotoAlbumViewController animated:YES completion:nil];
}

- (void)orderCommentView:(OrderCommentView *)commentView didClickedThumbImageAtIndex:(NSUInteger)index {
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:self.mwPhotosArray];
    [photoBrowser setCurrentPhotoIndex:index];
    [photoBrowser setShowDeleteButton:YES];
    photoBrowser.delegate = self;
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

- (void)didClickedSubmitButtonOnOrderCommentView:(OrderCommentView *)commentView {
    if (![self isValidateComment]) {
        return;
    }
    if (self.photoDictionary) {
        __weak OrderCommentViewController *weakSelf = self;
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [weakSelf getNeedUploadPhotosArray:^(NSArray *photosArray) {
            [[KTCImageUploader sharedInstance] startUploadWithImagesArray:photosArray withSucceed:^(NSArray *locateUrlStrings) {
                weakSelf.commentModel.uploadPhotoLocationStrings = photosArray;
                [weakSelf submitComments];
            } failure:^(NSError *error) {
                [[GAlertLoadingView sharedAlertLoadingView] hide];
                [[iToast makeText:@"照片上传失败，请重新提交"] show];
            }];
        }];
    } else {
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [self submitComments];
    }
}


#pragma mark OrderCommentBottomViewDelegate

- (void)didClickedSubmitButtonOnOrderCommentBottomView:(OrderCommentBottomView *)bottomView {
    if (![self isValidateComment]) {
        return;
    }
    if (self.photoDictionary) {
        __weak OrderCommentViewController *weakSelf = self;
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [weakSelf getNeedUploadPhotosArray:^(NSArray *photosArray) {
            [[KTCImageUploader sharedInstance] startUploadWithImagesArray:photosArray withSucceed:^(NSArray *locateUrlStrings) {
                weakSelf.commentModel.uploadPhotoLocationStrings = photosArray;
                [weakSelf submitComments];
            } failure:^(NSError *error) {
                [[GAlertLoadingView sharedAlertLoadingView] hide];
                [[iToast makeText:@"照片上传失败，请重新提交"] show];
            }];
        }];
    } else {
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [self submitComments];
    }
}

#pragma mark MC_ImagePickerViewControllerDelegate

- (void)MC_ImagePickerViewController:(MC_ImagePickerViewController *)controller didFinishPickingImageWithInfo:(NSDictionary *)info
{
    self.photoDictionary = info;
    //    self.photoArray = [info objectForKey:@"imageArray"];
    
    NSMutableArray *imagearray = [NSMutableArray arrayWithArray:[info objectForKey:PickedInfoImageArray]];
    NSMutableArray *takepictures = [[NSMutableArray alloc ]init];
    takepictures = [info objectForKey:PickedInfoTakePicturesArray];
    [takepictures enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [imagearray addObject:obj];
    }];
    self.photoArray = imagearray;
    [self.commentView resetPhotoViewWithImagesArray:self.photoArray];
    [self makeMWPhotoFromImageUrlArray:[info objectForKey:PickedInfoSelectAllURLArray]];
}


- (void)getTakePicturePhoto : (UIImage *)image photosDictionary:(NSDictionary *)photosdictionary
{
    self.photoDictionary = photosdictionary;
    NSMutableArray *imagearray = [NSMutableArray arrayWithArray:[photosdictionary objectForKey:PickedInfoImageArray]];
    NSMutableArray *takepictures = [[NSMutableArray alloc ]init];
    takepictures = [photosdictionary objectForKey:PickedInfoTakePicturesArray];
    [takepictures enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [imagearray addObject:obj];
    }];
    self.photoArray = imagearray;
    [self.commentView resetPhotoViewWithImagesArray:self.photoArray];
    [self makeMWPhotoFromImageUrlArray:[photosdictionary objectForKey:PickedInfoSelectAllURLArray]];
}

#pragma mark MWPhotoBrowserDelegate

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didClickedDeleteButtonAtIndex:(NSUInteger)index {
    [self deletePhotoAtIndex:index];
    [self.commentView resetPhotoViewWithImagesArray:self.photoArray];
}

- (void)deletePhotoAtIndex :(NSInteger)index
{
    NSDictionary *dic = [self.photoDictionary mutableCopy];
    
    NSMutableArray *infoImageArray = [[NSMutableArray alloc]init];
    infoImageArray = [[dic objectForKey:PickedInfoImageArray]mutableCopy] ;
    NSMutableArray *infoImageViewArray = [[NSMutableArray alloc]init];
    infoImageViewArray = [[dic objectForKey:PickedInfoImageViewArray]mutableCopy] ;
    NSMutableArray *infoImageURLArray = [[NSMutableArray alloc]init];
    infoImageURLArray = [[dic objectForKey:PickedInfoImageURLArray]mutableCopy] ;
    
    NSMutableArray *selectAllImageArray = [[NSMutableArray alloc]init];
    selectAllImageArray = [[dic objectForKey:PickedInfoSelectAllImageArray]mutableCopy] ;
    NSMutableArray *selectAllPictureArray = [[NSMutableArray alloc]init];
    selectAllPictureArray = [[dic objectForKey:PickedInfoSelectAllPictureArray]mutableCopy] ;
    NSMutableArray *selectAllURLArray = [[NSMutableArray alloc]init];
    selectAllURLArray = [[dic objectForKey:PickedInfoSelectAllURLArray]mutableCopy] ;
    
    NSMutableArray *takePicturesArray = [[NSMutableArray alloc]init];
    takePicturesArray = [[dic objectForKey:PickedInfoTakePicturesArray]mutableCopy] ;
    NSMutableArray *takePicturesURLArray = [[NSMutableArray alloc]init];
    takePicturesURLArray = [[dic objectForKey:PickedInfoTakePicturesURLArray]mutableCopy] ;
    
    NSURL *url = [selectAllURLArray objectAtIndex:index];
    NSString *urlString = [url absoluteString];
    NSRange range = [urlString rangeOfString:@"takePictureURL"];//判断字符串是否包含
    if (range.location ==NSNotFound)//不包含
    {
        NSInteger indexurl = [infoImageURLArray indexOfObject:url];
        [infoImageViewArray removeObjectAtIndex:indexurl];
        [infoImageURLArray removeObjectAtIndex:indexurl];
        [infoImageArray removeObjectAtIndex:indexurl];
    }
    else{
        NSInteger indexurl = [takePicturesURLArray indexOfObject:url];
        [takePicturesArray removeObjectAtIndex:indexurl];
        [takePicturesURLArray removeObjectAtIndex:indexurl];
    }
    [selectAllImageArray removeObjectAtIndex:index];
    [selectAllPictureArray removeObjectAtIndex:index];
    [selectAllURLArray removeObjectAtIndex:index];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:infoImageArray, PickedInfoImageArray, infoImageURLArray, PickedInfoImageURLArray,infoImageViewArray,PickedInfoImageViewArray,takePicturesArray,PickedInfoTakePicturesArray ,selectAllPictureArray,PickedInfoSelectAllPictureArray,selectAllURLArray,PickedInfoSelectAllURLArray,selectAllImageArray,PickedInfoSelectAllImageArray,takePicturesURLArray,PickedInfoTakePicturesURLArray, nil];
    
    
    
    self.photoDictionary = dataDic;
    
    
    ////////
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.photoArray];
    [temp removeObjectAtIndex:index];
    self.photoArray = [NSArray arrayWithArray:temp];
    [temp removeAllObjects];
    [temp addObjectsFromArray:self.mwPhotosArray];
    [temp removeObjectAtIndex:index];
    self.mwPhotosArray = [NSArray arrayWithArray:temp];
}

#pragma mark Private methods

- (void)makeMWPhotoFromImageUrlArray:(NSArray *)urlArray {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSURL *url in urlArray) {
        MWPhoto *photo = [[MWPhoto alloc] initWithURL:url];
        if (photo) {
            [temp addObject:photo];
        }
    }
    self.mwPhotosArray = [NSArray arrayWithArray:temp];
}

- (BOOL)isValidateComment {
    self.commentModel = self.commentView.commentModel;
    NSString *commentText = self.commentModel.commentText;
    if ([commentText length] < MINCOMMENTLENGTH) {
        [[iToast makeText:@"请输入至少10个字的评价。"] show];
        return NO;
    }
    
    commentText = [commentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([commentText length] < MINCOMMENTLENGTH - 7) {
        [[iToast makeText:@"请输入有效的评论内容。"] show];
        return NO;
    }
    
    if (self.commentModel.environmentStarNumber == 0 || self.commentModel.serviceStarNumber == 0 || self.commentModel.qualityStarNumber == 0) {
        [[iToast makeText:@"请给商品评分(1~5)"] show];
        return NO;
    }
    
    return YES;
}

- (void)getNeedUploadPhotosArray:(void (^)(NSArray *))finished {
    NSArray *selectAllURLArray = [self.photoDictionary objectForKey:PickedInfoSelectAllURLArray];
    NSArray *selectAllImageArray = [[self.photoDictionary objectForKey:PickedInfoSelectAllImageArray]mutableCopy] ;
    NSUInteger allUrlsArrayCount = [selectAllURLArray count];
    if (allUrlsArrayCount == 0) {
        return;
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSUInteger index = 0; index < [selectAllURLArray count]; index ++) {
        NSURL *url = [selectAllURLArray objectAtIndex:index];
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)
         {
             ALAssetRepresentation* representation = [asset defaultRepresentation];
             UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
             
             if (image) {
                 [tempArray addObject:image];
             } else {
                 [tempArray addObject:[selectAllImageArray objectAtIndex:index]];
             }
             
             if ([tempArray count] == [selectAllURLArray count]) {
                 finished([NSArray arrayWithArray:tempArray]);
             }
             
         }failureBlock:^(NSError *err) {
             NSLog(@"Error: %@",[err localizedDescription]);
         }];
    }
}

- (void)submitComments {
    if (!self.submitCommentRequest) {
        self.submitCommentRequest = [HttpRequestClient clientWithUrlAliasName:@"COMMENT_ADD"];
    }
    [self.submitCommentRequest cancel];
    NSString *uploadLocation = [self.commentModel.uploadPhotoLocationStrings componentsJoinedByString:@","];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:self.commentModel.qualityStarNumber], @"commentScore",
                           [NSNumber numberWithInteger:self.commentModel.environmentStarNumber], @"environmentScore",
                           [NSNumber numberWithInteger:self.commentModel.qualityStarNumber], @"costPerformanceScore",
                           [NSNumber numberWithInteger:self.commentModel.serviceStarNumber], @"serviceScore",
                           self.commentModel.commentText, @"comment",
                           self.commentModel.orderId, @"orderId",
                           self.commentModel.objectId, @"id",
                           self.commentModel.objectName, @"name",
                           [NSNumber numberWithInteger:self.commentModel.type], @"type",
                           uploadLocation, @"imgstr", nil];
    
    __weak OrderCommentViewController *weakSelf = self;
    [weakSelf.submitCommentRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitCommentSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitCommentFailed:error];
    }];
}

- (void)submitCommentSucceed:(NSDictionary *)data {
    NSString *respString = [data objectForKey:@"data"];
    if ([respString isKindOfClass:[NSString class]] && [respString length] > 0) {
        [[iToast makeText:respString] show];
    } else {
        [[iToast makeText:@"评论成功"] show];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCommentVCDidFinishSubmitComment:)]) {
        [self.delegate orderCommentVCDidFinishSubmitComment:self];
    }
    [self goBackController:nil];
}

- (void)submitCommentFailed:(NSError *)error {
    [[iToast makeText:@"提交评论失败，请重新提交。"] show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
