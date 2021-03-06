//
//  CommentEditViewController.m
//  KidsTC
//
//  Created by Altair on 12/2/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentEditViewController.h"
#import "CommentEditView.h"
#import "MC_ImagePickerViewController.h"
#import "MWPhotoBrowser.h"
#import "ServiceDetailViewController.h"
#import "KTCImageUploader.h"
#import "MyCommentListItemModel.h"
#import "CommentEditingModel.h"

@interface CommentEditViewController () <CommentEditViewDelegate, MC_ImagePickerViewControllerDelegate, MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet CommentEditView *commentView;

@property (nonatomic, strong) CommentEditingModel *commentModel;

@property (nonatomic, strong) HttpRequestClient *loadScoreSettingRequest;

@property (nonatomic, strong) HttpRequestClient *submitCommentRequest;

@property (strong, nonatomic)  NSDictionary *photoDictionary;

@property (nonatomic, strong) NSArray *mwPhotosArray;

@property (nonatomic, strong) KTCCommentManager *commentManager;

- (void)makeMWPhotoFromImageUrlArray:(NSArray *)urlArray;

- (BOOL)isValidateComment;

- (void)getNeedUploadPhotosArray:(void(^)(NSArray *photosArray))finished;

- (void)submitComments;

- (void)submitCommentSucceed:(NSDictionary *)data;

- (void)submitCommentFailed:(NSError *)error;

@end

@implementation CommentEditViewController

- (instancetype)initWithMyCommentItem:(MyCommentListItemModel *)item {
    self = [super initWithNibName:@"CommentEditViewController" bundle:nil];
    if (self) {
        self.commentModel = [CommentEditingModel modelFromItem:item];
        self.commentManager = [[KTCCommentManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    self.bTapToEndEditing = YES;
    [super viewDidLoad];
    _navigationTitle = @"修改评价";
    // Do any additional setup after loading the view from its nib.
    self.commentView.delegate = self;
    [self.commentView setCommentModel:self.commentModel];
    self.mwPhotosArray = [NSArray arrayWithArray:self.commentModel.photosArray];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.commentView endEditing];
}

#pragma mark CommentEditViewDelegate

- (void)didClickedAddPhotoButtonOnCommentEditView:(CommentEditView *)editView {
    MC_ImagePickerViewController *mc_PhotoAlbumViewController = [[MC_ImagePickerViewController alloc]initWithMaxCount:10 - [self.commentModel.thumbnailPhotoUrlStringsArray count] andPhotoDictionary:self.photoDictionary];
    mc_PhotoAlbumViewController.hidesBottomBarWhenPushed = YES;
    mc_PhotoAlbumViewController.delegate = self;
    [self.navigationController presentViewController:mc_PhotoAlbumViewController animated:YES completion:nil];
}

- (void)commentEditView:(CommentEditView *)editView didClickedThumbImageAtIndex:(NSUInteger)index {
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:self.mwPhotosArray];
    [photoBrowser setCurrentPhotoIndex:index];
    [photoBrowser setShowDeleteButton:YES];
    photoBrowser.delegate = self;
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

- (void)didClickedSubmitButtonOnCommentEditView:(CommentEditView *)editView {
    if (![self isValidateComment]) {
        return;
    }
    if (self.photoDictionary) {
        __weak CommentEditViewController *weakSelf = self;
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [weakSelf getNeedUploadPhotosArray:^(NSArray *photosArray) {
            if ([photosArray count] == 0) {
                [weakSelf submitComments];
                return;
            }
            [[KTCImageUploader sharedInstance]  startUploadWithImagesArray:photosArray splitCount:2 withSucceed:^(NSArray *locateUrlStrings) {
                NSArray *remote = [weakSelf.commentModel remoteImageUrlStrings];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                if ([remote count] > 0) {
                    [tempArray addObjectsFromArray:remote];
                }
                [tempArray addObjectsFromArray:locateUrlStrings];
                weakSelf.commentModel.uploadPhotoLocationStrings = [NSArray arrayWithArray:tempArray];
                [weakSelf submitComments];
            } failure:^(NSError *error) {
                [[GAlertLoadingView sharedAlertLoadingView] hide];
                if (error.userInfo) {
                    NSString *errMsg = [error.userInfo objectForKey:@"data"];
                    if ([errMsg isKindOfClass:[NSString class]] && [errMsg length] > 0) {
                        
                        [[iToast makeText:errMsg] show];
                    } else {
                        [[iToast makeText:@"照片上传失败，请重新提交"] show];
                    }
                } else {
                    [[iToast makeText:@"照片上传失败，请重新提交"] show];
                }
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
    if ([self.commentModel.thumbnailPhotoUrlStringsArray count] > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if ([self.commentModel.thumbnailPhotoUrlStringsArray count] > 0) {
            [tempArray addObjectsFromArray:self.commentModel.thumbnailPhotoUrlStringsArray];
        }
        [tempArray addObjectsFromArray:imagearray];
        self.commentModel.combinedImagesArray = [NSArray arrayWithArray:tempArray];
    } else {
        self.commentModel.combinedImagesArray = imagearray;
    }
    [self.commentView resetPhotoViewWithImagesArray:self.commentModel.combinedImagesArray];
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
    if ([self.commentModel.thumbnailPhotoUrlStringsArray count] > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if ([self.commentModel.thumbnailPhotoUrlStringsArray count] > 0) {
            [tempArray addObjectsFromArray:self.commentModel.thumbnailPhotoUrlStringsArray];
        }
        [tempArray addObjectsFromArray:imagearray];
        self.commentModel.combinedImagesArray = [NSArray arrayWithArray:tempArray];
    } else {
        self.commentModel.combinedImagesArray = imagearray;
    }
    [self.commentView resetPhotoViewWithImagesArray:self.commentModel.combinedImagesArray];
    [self makeMWPhotoFromImageUrlArray:[photosdictionary objectForKey:PickedInfoSelectAllURLArray]];
}

#pragma mark MWPhotoBrowserDelegate

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didClickedDeleteButtonAtIndex:(NSUInteger)index {
    [self deletePhotoAtIndex:index];
    [self.commentView resetPhotoViewWithImagesArray:self.commentModel.combinedImagesArray];
}

- (void)deletePhotoAtIndex :(NSInteger)index
{
    NSInteger originIndex = index;
    if ([self.commentModel.thumbnailPhotoUrlStringsArray count] > index) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.commentModel.thumbnailPhotoUrlStringsArray];
        [tempArray removeObjectAtIndex:index];
        self.commentModel.thumbnailPhotoUrlStringsArray = [NSArray arrayWithArray:tempArray];
        
        [tempArray removeAllObjects];
        [tempArray addObjectsFromArray:self.commentModel.originalPhotoUrlStringsArray];
        [tempArray removeObjectAtIndex:index];
        self.commentModel.originalPhotoUrlStringsArray = [NSArray arrayWithArray:tempArray];
        
        [tempArray removeAllObjects];
        [tempArray addObjectsFromArray:self.commentModel.photosArray];
        [tempArray removeObjectAtIndex:index];
        self.commentModel.photosArray = [NSArray arrayWithArray:tempArray];
        
        [tempArray removeAllObjects];
        [tempArray addObjectsFromArray:self.commentModel.combinedImagesArray];
        [tempArray removeObjectAtIndex:index];
        self.commentModel.combinedImagesArray = [NSArray arrayWithArray:tempArray];
        
        [tempArray removeAllObjects];
        [tempArray addObjectsFromArray:self.mwPhotosArray];
        [tempArray removeObjectAtIndex:index];
        self.mwPhotosArray = [NSArray arrayWithArray:tempArray];
        
        [tempArray removeAllObjects];
        [tempArray addObjectsFromArray:self.commentModel.uploadPhotoLocationStrings];
        [tempArray removeObjectAtIndex:index];
        self.commentModel.uploadPhotoLocationStrings = [NSArray arrayWithArray:tempArray];
        
        return;
    } else {
        index -= [self.commentModel.thumbnailPhotoUrlStringsArray count];
    }
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
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.commentModel.combinedImagesArray];
    [tempArray removeObjectAtIndex:originIndex];
    self.commentModel.combinedImagesArray = [NSArray arrayWithArray:tempArray];
    [tempArray removeAllObjects];
    [tempArray addObjectsFromArray:self.mwPhotosArray];
    [tempArray removeObjectAtIndex:originIndex];
    self.mwPhotosArray = [NSArray arrayWithArray:tempArray];
}

#pragma mark Private methods

- (void)makeMWPhotoFromImageUrlArray:(NSArray *)urlArray {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if ([self.commentModel.photosArray count] > 0) {
        [temp addObjectsFromArray:self.commentModel.photosArray];
    }
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
    
    for (CommentScoreItem *item in [self.commentModel.scoreConfigModel allShowingScoreItems]) {
        if (item.score == 0) {
            [[iToast makeText:@"请给商品评分(1~5)"] show];
            return NO;
        }
    }
    
    return YES;
}

- (void)getNeedUploadPhotosArray:(void (^)(NSArray *))finished {
    NSArray *selectAllURLArray = [self.photoDictionary objectForKey:PickedInfoSelectAllURLArray];
    NSArray *selectAllImageArray = [[self.photoDictionary objectForKey:PickedInfoSelectAllImageArray]mutableCopy] ;
    NSUInteger allUrlsArrayCount = [selectAllURLArray count];
    if (allUrlsArrayCount == 0) {
        if (finished) {
            finished(nil);
        }
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
    KTCCommentObject *object = [[KTCCommentObject alloc] init];
    object.identifier = self.commentModel.relationIdentifier;
    object.relationType = self.commentModel.relationType;
    object.commentIdentifier = self.commentModel.commentIdentifier;
    object.isAnonymous = NO;
    object.isComment = YES;
    object.content = self.commentModel.commentText;
    object.uploadImageStrings = self.commentModel.uploadPhotoLocationStrings;
    if ([[self.commentModel.scoreConfigModel allShowingScoreItems] count] > 0) {
        object.totalScore = self.commentModel.scoreConfigModel.totalScoreItem.score;
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        for (CommentScoreItem *item in self.commentModel.scoreConfigModel.otherScoreItems) {
            [tempDic setObject:[NSNumber numberWithInteger:item.score] forKey:item.key];
        }
        object.scoresDetail = [[NSDictionary alloc] initWithDictionary:tempDic copyItems:YES];
    }
    
    if (!self.commentManager) {
        self.commentManager = [[KTCCommentManager alloc] init];
    }
    __weak CommentEditViewController *weakSelf = self;
    [weakSelf.commentManager modifyUserCommentWithObject:object succeed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitCommentSucceed:data];
    } failure:^(NSError *error) {
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentEditViewControllerDidFinishSubmitComment:)]) {
        [self.delegate commentEditViewControllerDidFinishSubmitComment:self];
    }
    [self goBackController:nil];
}

- (void)submitCommentFailed:(NSError *)error {
    NSString *errMsg = @"提交评论失败，请重新提交。";
    NSString *remoteErrMsg = [error.userInfo objectForKey:@"data"];
    if ([remoteErrMsg isKindOfClass:[NSString class]] && [remoteErrMsg length] > 0) {
        errMsg = remoteErrMsg;
    }
    [[iToast makeText:errMsg] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
