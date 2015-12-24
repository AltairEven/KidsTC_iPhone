//
//  KTCWebViewController.m
//  KidsTC
//
//  Created by 钱烨 on 9/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCWebViewController.h"
//#import "WXApi.h"
//#import "HttpCookieWrapper.h"
//#import "UIAlertView+Blocks.h"
#import "KTCTabBarController.h"
//#import "UIDevice+IdentifierAddition.h"
//#import "WeChatModel.h"
//#import "WebCookieCache.h"
#import "ServiceDetailViewController.h"
#import "AUIKeyboardAdhesiveView.h"
#import "CommonShareViewController.h"
#import "KTCCommentManager.h"
#import "MC_ImagePickerViewController.h"
#import "MWPhotoBrowser.h"
#import "KTCImageUploader.h"
#import "NSString+UrlEncode.h"
#import "HttpIcsonCookieManager.h"


#define Hook_Prefix (@"hook::")
#define Hook_ProductDetail (@"productdetail::")
#define Hook_Login (@"login::")
#define Hook_Comment (@"evaluate::")
#define Hook_Share (@"share::")

@interface KTCWebViewController () <UIWebViewDelegate, AUIKeyboardAdhesiveViewDelegate, MC_ImagePickerViewControllerDelegate, MWPhotoBrowserDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) KTCCommentManager *commentManager;

@property (nonatomic, strong) AUIKeyboardAdhesiveView *keyboardAdhesiveView;

@property (nonatomic, strong) NSDictionary *commentParam;

@property (nonatomic, copy) NSString *callBackJSString;

//photo

@property (nonatomic, strong) HttpRequestClient *submitCommentRequest;

@property (strong, nonatomic)  NSArray *photoArray;
@property (strong, nonatomic)  NSDictionary *photoDictionary;
@property (nonatomic, strong) NSDictionary *produceInfo;

@property (nonatomic, strong) NSArray *mwPhotosArray;

- (void)getNeedUploadPhotosArray:(void(^)(NSArray *photosArray))finished;

- (void)makeMWPhotoFromImageUrlArray:(NSArray *)urlArray;

//other
@property (weak, nonatomic) IBOutlet UIButton *backToTopButton;
@property (nonatomic, strong) UIButton *closeButton;

- (IBAction)didClickedBackToTopButton:(id)sender;

- (void)buildLeftBarButtonsWithCloseHidden:(BOOL)hidden;

- (BOOL)isValidateComment;

- (void)submitCommentsWithUploadLocations:(NSArray *)locationUrls;

- (void)submitCommentSucceed:(NSDictionary *)data;

- (void)submitCommentFailed:(NSError *)error;

- (void)pushToServiceDetailWithParams:(NSDictionary *)params;

- (void)commentWithParams:(NSDictionary *)params;

- (void)didClickedShareButton;

- (void)shareWithParams:(NSDictionary *)params;

@end

@implementation KTCWebViewController

+ (void)initialize
{
    // add extro info to user-agent
    UIWebView *webView = [[UIWebView alloc] init];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *extInfo = [NSString stringWithFormat:@"KidsTC/Iphone/%@", appVersion];
    if ([userAgent rangeOfString:extInfo].location == NSNotFound)
    {
        NSString *newUserAgent = [NSString stringWithFormat:@"%@ %@", userAgent, extInfo];
        // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isNavShowType = YES;
        self.backToLink = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.multipleTouchEnabled = NO;
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    if (self.webUrlString)
    {
        [self loadUrl:self.webUrlString];
    }
    
    [[HttpIcsonCookieManager sharedManager] setIcsonCookieWithName:@"population_type" andValue:[[KTCUser currentUser].userRole userRoleIdentifierString]];
    
    self.backToTopButton.layer.cornerRadius = 20;
    self.backToTopButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backToTopButton.layer.borderWidth = 2;
    self.backToTopButton.layer.masksToBounds = YES;
    [self.backToTopButton setHidden:YES];
    
    [self setupRightBarButton:@"" target:self action:@selector(didClickedShareButton) frontImage:@"share_n" andBackImage:@"share_n"];

    
}

- (void)viewDidUnload
{
    self.webView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self buildLeftBarButtonsWithCloseHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.commentManager stopAdding];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    _navigationTitle = title;
}

- (void)dealloc {
    self.webView.delegate = nil;
    if (self.keyboardAdhesiveView) {
        [self.keyboardAdhesiveView destroy];
    }
    
    [[HttpIcsonCookieManager sharedManager] deleteCookieWithName:@"population_type"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate

- (void)loadUrl:(NSString *)urlStr
{
    NSString *urlAddress = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *myurl = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:myurl];
    [self.webView loadRequest:requestObj];
}

- (void)setWebUrlString:(NSString *)webUrlString
{
    if (![webUrlString hasPrefix:@"http://"]) {
        webUrlString = [NSString stringWithFormat:@"http://%@", webUrlString];
    }
    if(self.webUrlString != webUrlString)
    {
        _webUrlString = webUrlString;
        if (self.webView)
        {
            [self loadUrl:webUrlString];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * requestUrl = [request URL];
    NSString *urlString = [requestUrl absoluteString];
    _currentUrlString = urlString;
    self.callBackJSString = nil;
    self.photoArray = nil;
    self.photoDictionary = nil;
    self.produceInfo = nil;
    self.mwPhotosArray = nil;
    /*
     @"wap2app://app.launch/param?" 走二维码扫描逻辑。待方案优化。
     iOS 5 和之前版本，不支持跳转到当前APP。
     */
    if ([requestUrl.host hasSuffix:@"itunes.apple.com"] || [urlString hasPrefix:@"wap2app://app.launch/param?"]) {
        [self.navigationController popViewControllerAnimated:NO];
        KTCTabBarController *rootVc = [KTCTabBarController shareTabBarController];
        [rootVc allPopToRoot];
        [rootVc setButtonSelected:KTCTabHome];
        [[UIApplication sharedApplication] openURL:requestUrl];
        
        return NO;
    } else if ([urlString hasPrefix:Hook_Prefix]) {
        NSString *hookString = [urlString substringFromIndex:[Hook_Prefix length]];
        if ([hookString hasPrefix:Hook_Login]) {
            [GToolUtil checkLogin:^(NSString *uid) {
                [self.webView reload];
            } target:self];
            return NO;
        } else if ([hookString hasPrefix:Hook_ProductDetail]) {
            NSString *jumpString = [hookString substringFromIndex:[Hook_ProductDetail length]];
            NSDictionary *params = [GToolUtil parsetUrl:jumpString];
            [self pushToServiceDetailWithParams:params];
            return NO;
        } else if ([hookString hasPrefix:Hook_Comment]) {
            NSString *paramString = [hookString substringFromIndex:[Hook_Comment length]];
            NSDictionary *params = [GToolUtil parsetUrl:paramString];
            [self commentWithParams:params];
            return NO;
        } else if ([hookString hasPrefix:Hook_Share]) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            NSArray *paramsArray = [hookString componentsSeparatedByString:@";"];
            for (NSString *string in paramsArray) {
                NSRange titleRange = [string rangeOfString:@"share::title="];
                NSRange descRange = [string rangeOfString:@"desc="];
                NSRange picRange = [string rangeOfString:@"pic="];
                NSRange urlRange = [string rangeOfString:@"url="];
                if (titleRange.location != NSNotFound) {
                    NSString *title = [string substringFromIndex:titleRange.length];
                    title = [title URLDecodedString];
                    [tempDic setObject:title forKey:@"title"];
                    continue;
                }
                if (descRange.location != NSNotFound) {
                    NSString *desc = [string substringFromIndex:descRange.length];
                    desc = [desc URLDecodedString];
                    [tempDic setObject:desc forKey:@"desc"];
                    continue;
                }
                if (picRange.location != NSNotFound) {
                    NSString *pic = [string substringFromIndex:picRange.length];
                    [tempDic setObject:pic forKey:@"pic"];
                    continue;
                }
                if (urlRange.location != NSNotFound) {
                    NSString *url = [string substringFromIndex:urlRange.length];
                    [tempDic setObject:url forKey:@"url"];
                    NSDictionary *urlParamsDic = [GToolUtil parsetUrl:url];
                    if ([urlParamsDic objectForKey:@"id"]) {
                        NSString *identifier = [NSString stringWithFormat:@"%@", [urlParamsDic objectForKey:@"id"]];
                        [tempDic setObject:identifier forKey:@"id"];
                        
                    }
                    continue;
                }
            }
            if ([tempDic count] == 0) {
                return YES;
            }
            [self shareWithParams:[NSDictionary dictionaryWithDictionary:tempDic]];
            return NO;
        }
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewControllerDidStartLoad:)]) {
        [self.delegate webViewControllerDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title)
    {
        self.title = title;
        _navigationTitle = title;
    } else {
        self.title = @"童成网";
        _navigationTitle = title;
    }
    [self.closeButton setHidden:![self.webView canGoBack]];
}

- (void)webView:(UIWebView *)webView_ didFailLoadWithError:(NSError *)error
{
    [self.closeButton setHidden:![self.webView canGoBack]];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.webView.scrollView && scrollView.contentOffset.y > 200) {
        [self.backToTopButton setHidden:NO];
    } else {
        [self.backToTopButton setHidden:YES];
    }
}

#pragma mark AUIKeyboardAdhesiveViewDelegate

- (void)keyboardAdhesiveView:(AUIKeyboardAdhesiveView *)view didClickedExtensionFunctionButtonWithType:(AUIKeyboardAdhesiveViewExtensionFunctionType)type {
    if (type == AUIKeyboardAdhesiveViewExtensionFunctionTypeImageUpload) {
        MC_ImagePickerViewController *mc_PhotoAlbumViewController = [[MC_ImagePickerViewController alloc]initWithMaxCount:4 andPhotoDictionary:self.photoDictionary];
        mc_PhotoAlbumViewController.delegate = self;
        [self.keyboardAdhesiveView hide];
        [self presentViewController:mc_PhotoAlbumViewController animated:YES completion:nil];
    }
}

- (void)didClickedSendButtonOnKeyboardAdhesiveView:(AUIKeyboardAdhesiveView *)view {
    if (!self.commentParam) {
        return;
    }
    if (![self isValidateComment]) {
        return;
    }
    [[GAlertLoadingView sharedAlertLoadingView] show];
    if (self.photoDictionary) {
        __weak KTCWebViewController *weakSelf = self;
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

- (void)keyboardAdhesiveView:(AUIKeyboardAdhesiveView *)view didClickedUploadImageAtIndex:(NSUInteger)index {
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:self.mwPhotosArray];
    [photoBrowser setCurrentPhotoIndex:index];
    [photoBrowser setShowDeleteButton:YES];
    photoBrowser.delegate = self;
    [self.keyboardAdhesiveView hide];
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

#pragma mark MC_ImagePickerViewControllerDelegate

- (void)pickerViewControllerWillDismiss:(MC_ImagePickerViewController *)controller {
    [self.keyboardAdhesiveView show];
}

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

- (void)photoBrowserDidDismissed:(MWPhotoBrowser *)photoBrowser {
    [self.keyboardAdhesiveView show];
}

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

- (void)buildLeftBarButtonsWithCloseHidden:(BOOL)hidden {
    CGFloat buttonWidth = 28;
    CGFloat buttonHeight = 28;
    CGFloat buttonGap = 15;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(-15, 0, buttonWidth * 2 + buttonGap, buttonHeight)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat xPosition = 0;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(xPosition, 0, buttonWidth, buttonHeight)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"navigation_back_n"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back_n"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(goBackController:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [bgView addSubview:backButton];
    
    xPosition += buttonWidth + buttonGap;
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setFrame:CGRectMake(xPosition, 0, buttonWidth, buttonHeight)];
    [self.closeButton setBackgroundColor:[UIColor clearColor]];
    [self.closeButton setImage:[UIImage imageNamed:@"navigation_close"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"navigation_close"] forState:UIControlStateHighlighted];
    [self.closeButton addTarget:self action:@selector(closeWebPage) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.closeButton];
    [self.closeButton setHidden:YES];
    
    UIBarButtonItem *lItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    self.navigationItem.leftBarButtonItem = lItem;
}

- (IBAction)didClickedBackToTopButton:(id)sender {
    [self.webView.scrollView scrollRectToVisible:CGRectMake(0, 0, self.webView.scrollView.frame.size.width, self.webView.scrollView.frame.size.height) animated:YES];
}

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

#pragma mark Jump Methods

- (void)pushToServiceDetailWithParams:(NSDictionary *)params {
    if (!params) {
        return;
    }
    NSString *serviceId = [params objectForKey:@"id"];
    NSString *channelId = [params objectForKey:@"chid"];
    if ([serviceId length] == 0) {
        return;
    }
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:serviceId channelId:channelId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Comment

- (void)commentWithParams:(NSDictionary *)params {
    self.commentParam = params;
    if (!params) {
        return;
    }
    if (!self.keyboardAdhesiveView) {
        AUIKeyboardAdhesiveViewExtensionFunction *photoFunc = [AUIKeyboardAdhesiveViewExtensionFunction funtionWithType:AUIKeyboardAdhesiveViewExtensionFunctionTypeImageUpload];
        self.keyboardAdhesiveView = [[AUIKeyboardAdhesiveView alloc] initWithAvailableFuntions:[NSArray arrayWithObject:photoFunc]];
        [self.keyboardAdhesiveView.headerView setBackgroundColor:[AUITheme theme].globalThemeColor];
        [self.keyboardAdhesiveView setTextLimitLength:100];
        [self.keyboardAdhesiveView setUploadImageLimitCount:4];
        self.keyboardAdhesiveView.delegate = self;
    }
    [GToolUtil checkLogin:^(NSString *uid) {
        [self.keyboardAdhesiveView expand];
        self.callBackJSString = [params objectForKey:@"callback"];
    } target:self];
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
    if ([self.commentParam objectForKey:@"relationSysNo"]) {
        object.identifier = [NSString stringWithFormat:@"%@", [self.commentParam objectForKey:@"relationSysNo"]];
    }
    object.relationType = (CommentRelationType)[[self.commentParam objectForKey:@"relationType"] integerValue];
    object.isAnonymous = NO;
    object.isComment = [[self.commentParam objectForKey:@"isComment"] boolValue];
    if ([self.commentParam objectForKey:@"replyId"]) {
        object.commentIdentifier = [NSString stringWithFormat:@"%@", [self.commentParam objectForKey:@"replyId"]];
    }
    object.content = self.keyboardAdhesiveView.text;
    object.uploadImageStrings = locationUrls;
    
    if (!self.commentManager) {
        self.commentManager = [[KTCCommentManager alloc] init];
    }
    __weak KTCWebViewController *weakSelf = self;
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
    if ([self.callBackJSString length] > 0) {
        [self.webView stringByEvaluatingJavaScriptFromString:self.callBackJSString];
    }
    self.callBackJSString = nil;
}

- (void)submitCommentFailed:(NSError *)error {
    NSString *errMsg = @"提交评论失败，请重新提交。";
    NSString *remoteErrMsg = [error.userInfo objectForKey:@"data"];
    if ([remoteErrMsg isKindOfClass:[NSString class]] && [remoteErrMsg length] > 0) {
        errMsg = remoteErrMsg;
    }
    [[iToast makeText:errMsg] show];
}

#pragma mark Share

- (void)didClickedShareButton {
}

- (void)shareWithParams:(NSDictionary *)params {
    NSString *title = [params objectForKey:@"title"];
    NSString *desc = [params objectForKey:@"desc"];
    NSString *thumbUrlString = [params objectForKey:@"pic"];
    NSString *linkUrlString = [params objectForKey:@"url"];
    NSString *identifier = [params objectForKey:@"id"];
    
    CommonShareObject *shareObject = [CommonShareObject shareObjectWithTitle:title description:desc thumbImageUrl:[NSURL URLWithString:thumbUrlString] urlString:linkUrlString];
    shareObject.identifier = identifier;
    shareObject.followingContent = @"【童成网】";
    CommonShareViewController *controller = [CommonShareViewController instanceWithShareObject:shareObject sourceType:KTCShareServiceTypeNews];
    
    [self presentViewController:controller animated:YES completion:nil] ;
}

#pragma mark Public Methods

- (void)closeWebPage
{
    self.webUrlString = nil;
    _currentUrlString = nil;
    [super goBackController:nil];
}

#pragma mark Super Methods

- (void)goBackController:(id)sender
{
    if([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        /*
         缓存Cookies, 用于再次进入WebView时保留QQ登录态。
         */
        //        if (self.webUrlString)
        //        {
        //            NSArray * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
        //            if (cookies)
        //            {
        //                [[WebCookieCache sharedWebCookieCache].cookiesDict setObject:cookies
        //                                                                      forKey:self.webUrlString];
        //            }
        //        }
        
        [super goBackController:sender];
        self.webUrlString = nil;
    }
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
