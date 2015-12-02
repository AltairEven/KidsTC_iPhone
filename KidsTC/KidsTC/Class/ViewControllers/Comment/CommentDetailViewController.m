//
//  CommentDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 10/29/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "AUIKeyboardAdhesiveView.h"
#import "MC_ImagePickerViewController.h"
#import "MWPhotoBrowser.h"
#import "KTCImageUploader.h"
#import "ServiceDetailViewController.h"
#import "StoreDetailViewController.h"

@interface CommentDetailViewController () <CommentDetailViewDelegate, AUIKeyboardAdhesiveViewDelegate,MC_ImagePickerViewControllerDelegate, MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet CommentDetailView *detailView;
@property (nonatomic, strong) CommentDetailViewModel *viewModel;

@property (nonatomic, strong) AUIKeyboardAdhesiveView *keyboardAdhesiveView;

@property (nonatomic, strong) id headerModel;

@property (nonatomic, strong) HttpRequestClient *submitCommentRequest;

@property (strong, nonatomic)  NSArray *photoArray;
@property (strong, nonatomic)  NSDictionary *photoDictionary;
@property (nonatomic, strong) NSDictionary *produceInfo;

@property (nonatomic, strong) NSArray *mwPhotosArray;

@property (nonatomic, assign) BOOL isComment;

@property (nonatomic, strong) KTCCommentManager *commentManager;

- (void)makeMWPhotoFromImageUrlArray:(NSArray *)urlArray;

- (BOOL)isValidateComment;

- (void)getNeedUploadPhotosArray:(void(^)(NSArray *photosArray))finished;

- (void)submitCommentsWithUploadLocations:(NSArray *)locationUrls;

- (void)submitCommentSucceed:(NSDictionary *)data;

- (void)submitCommentFailed:(NSError *)error;

@end

@implementation CommentDetailViewController

- (instancetype)initWithSource:(CommentDetailSource)source relationType:(CommentRelationType)type headerModel:(id)model {
    self = [super initWithNibName:@"CommentDetailViewController" bundle:nil];
    if (self) {
        _viewSource = source;
        _relationType = type;
        self.headerModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navigationTitle = @"用户评价";
    // Do any additional setup after loading the view from its nib.
    self.detailView.delegate = self;
    self.viewModel = [[CommentDetailViewModel alloc] initWithView:self.detailView];
    [self.viewModel.detailModel setModelSource:self.viewSource];
    [self.viewModel.detailModel setRelationType:self.relationType];
    [self.viewModel.detailModel setIdentifier:self.commentIdentifier];
    [self.viewModel.detailModel setRelationIdentifier:self.relationIdentifier];
    [self.viewModel.detailModel setHeaderModel:self.headerModel];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.keyboardAdhesiveView) {
        self.keyboardAdhesiveView = [[AUIKeyboardAdhesiveView alloc] initWithAvailableFuntions:nil];
        [self.keyboardAdhesiveView.headerView setBackgroundColor:[AUITheme theme].globalThemeColor];
        [self.keyboardAdhesiveView setTextLimitLength:100];
        self.keyboardAdhesiveView.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.commentManager stopAdding];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
}

- (void)dealloc {
    if (self.keyboardAdhesiveView) {
        [self.keyboardAdhesiveView destroy];
    }
}

#pragma mark CommentDetailViewDelegate

- (void)commentDetailView:(CommentDetailView *)detailView didSelectedReplyAtIndex:(NSUInteger)index {
    [GToolUtil checkLogin:^(NSString *uid) {
        CommentReplyItemModel *model = [self.viewModel.detailModel.replyModels objectAtIndex:index];
        [self.keyboardAdhesiveView setPlaceholder:[NSString stringWithFormat:@"回复%@：",model.userName]];
        [self.keyboardAdhesiveView expand];
        if (self.viewSource == CommentDetailViewSourceStrategy || self.viewSource == CommentDetailViewSourceStrategyDetail) {
            self.isComment = YES;
            self.commentIdentifier = model.identifier;
        } else {
            self.isComment = NO;
        };
    } target:self];
}

- (void)didTappedOnCommentDetailView:(CommentDetailView *)detailView {
    [GToolUtil checkLogin:^(NSString *uid) {
        [self.keyboardAdhesiveView setPlaceholder:@"回复楼主："];
        [self.keyboardAdhesiveView expand];
        self.commentIdentifier = self.viewModel.detailModel.identifier;
        if (self.viewSource == CommentDetailViewSourceStrategy || self.viewSource == CommentDetailViewSourceStrategyDetail) {
            self.isComment = YES;
            self.commentIdentifier = nil;
        } else {
            self.isComment = NO;
        }
    } target:self];
}

- (void)commentDetailViewDidPulledDownToRefresh:(CommentDetailView *)detailView {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)commentDetailViewDidPulledUpToloadMore:(CommentDetailView *)detailView {
    [self.viewModel getMoreReplies];
}

#pragma mark AUIKeyboardAdhesiveViewDelegate

- (void)didClickedSendButtonOnKeyboardAdhesiveView:(AUIKeyboardAdhesiveView *)view {
    if (![self isValidateComment]) {
        return;
    }
    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.keyboardAdhesiveView];
    if (self.photoDictionary) {
        __weak CommentDetailViewController *weakSelf = self;
        [weakSelf getNeedUploadPhotosArray:^(NSArray *photosArray) {
            [[KTCImageUploader sharedInstance] startUploadWithImagesArray:photosArray splitCount:2 withSucceed:^(NSArray *locateUrlStrings) {
                [weakSelf submitCommentsWithUploadLocations:locateUrlStrings];
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
        [self submitCommentsWithUploadLocations:nil];
    }
}

- (void)keyboardAdhesiveView:(AUIKeyboardAdhesiveView *)view didClickedExtensionFunctionButtonWithType:(AUIKeyboardAdhesiveViewExtensionFunctionType)type {
    if (type == AUIKeyboardAdhesiveViewExtensionFunctionTypeImageUpload) {
        MC_ImagePickerViewController *mc_PhotoAlbumViewController = [[MC_ImagePickerViewController alloc]initWithMaxCount:10 andPhotoDictionary:self.photoDictionary];
        mc_PhotoAlbumViewController.hidesBottomBarWhenPushed = YES;
        mc_PhotoAlbumViewController.delegate = self;
        [self.navigationController presentViewController:mc_PhotoAlbumViewController animated:YES completion:nil];
    }
}

- (void)keyboardAdhesiveView:(AUIKeyboardAdhesiveView *)view didClickedUploadImageAtIndex:(NSUInteger)index {
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:self.mwPhotosArray];
    [photoBrowser setCurrentPhotoIndex:index];
    [photoBrowser setShowDeleteButton:YES];
    photoBrowser.delegate = self;
    [self presentViewController:photoBrowser animated:YES completion:nil];
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
    [self.keyboardAdhesiveView setUploadImages:self.photoArray];
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
    [self.keyboardAdhesiveView setUploadImages:self.photoArray];
    [self makeMWPhotoFromImageUrlArray:[photosdictionary objectForKey:PickedInfoSelectAllURLArray]];
}

#pragma mark MWPhotoBrowserDelegate

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didClickedDeleteButtonAtIndex:(NSUInteger)index {
    [self deletePhotoAtIndex:index];
    [self.keyboardAdhesiveView setUploadImages:self.photoArray];
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

#define MIN_COMMENTLENGTH (1)

- (BOOL)isValidateComment {
    NSString *commentText = self.keyboardAdhesiveView.text;
    commentText = [commentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([commentText length] < MIN_COMMENTLENGTH) {
        [[iToast makeText:@"请至少输入1个字"] show];
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

- (void)submitCommentsWithUploadLocations:(NSArray *)locationUrls {
    KTCCommentObject *object = [[KTCCommentObject alloc] init];
    object.identifier = self.relationIdentifier;
    object.relationType = self.relationType;
    object.isAnonymous = NO;
    object.isComment = self.isComment;
    if ([self.commentIdentifier length] > 0) {
        object.commentIdentifier = self.commentIdentifier;
    }
    object.content = self.keyboardAdhesiveView.text;
    object.uploadImageStrings = locationUrls;
    
    if (!self.commentManager) {
        self.commentManager = [[KTCCommentManager alloc] init];
    }
    __weak CommentDetailViewController *weakSelf = self;
    [weakSelf.commentManager addCommentWithObject:object succeed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitCommentSucceed:data];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitCommentFailed:error];
    }];
}

- (void)submitCommentSucceed:(NSDictionary *)data {
    [self.keyboardAdhesiveView shrink];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
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
