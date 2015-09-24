//
//  KTCWebViewController.m
//  KidsTC
//
//  Created by 钱烨 on 9/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCWebViewController.h"
#import "WXApi.h"
#import "HttpCookieWrapper.h"
#import "UIAlertView+Blocks.h"
#import "KTCTabBarController.h"
#import "UIDevice+IdentifierAddition.h"
#import "WeChatModel.h"
#import "WebCookieCache.h"
#import "ServiceDetailViewController.h"


#define Hook_Prefix (@"hook::")
#define Hook_ProductDetail (@"productdetail::")

@interface KTCWebViewController () <UIWebViewDelegate,UIActionSheetDelegate>

@property(nonatomic,strong)NSDictionary *weChatParam;

- (void)pushToServiceDetailWithParams:(NSDictionary *)params;

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
        self.title = @"童成网";
        self.backToLink = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.multipleTouchEnabled = NO;
    self.webView.delegate = self;
    if (self.webUrlString)
    {
        [self loadUrl:self.webUrlString];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccess:) name:kWeChatShareRespNotification object:nil];
}

- (void)viewDidUnload
{
    self.webView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
     当站点切换，用户登陆态改变
     刷新数据
     */
//    if (_currentDistrictID != [[UserWrapper shareMasterUser].districtId integerValue] || _currentUID != [UserWrapper shareMasterUser].uid)
//    {
//        [self loadUrl:self.linkURL];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeChatShareRespNotification object:nil];
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
    if(self.webUrlString != webUrlString)
    {
        _webUrlString = webUrlString;
        NSDictionary *dic = [GToolUtil parsetUrl:self.webUrlString];
        NSString *title = [dic objectForKey:@"title"];
        if (title)
        {
            self.title = title;
            _navigationTitle = title;
        }
        
        BOOL backToLink = [[dic objectForKey:@"wapBack"] boolValue];
        self.backToLink = backToLink;
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
        NSString *jumpString = nil;
        if ([hookString hasPrefix:Hook_ProductDetail]) {
            jumpString = [hookString substringFromIndex:[Hook_ProductDetail length]];
        }
        NSDictionary *params = [GToolUtil parsetUrl:jumpString];
        [self pushToServiceDetailWithParams:params];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView_
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewControllerDidStartLoad:)]) {
        [self.delegate webViewControllerDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView_
{
}

- (void)webView:(UIWebView *)webView_ didFailLoadWithError:(NSError *)error
{
}

#pragma mark Private methods
- (void)sharedToWeiXin:(NSDictionary*)param
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给微信好友", @"分享到微信朋友圈", nil];
    [actionSheet showInView:self.view];
    self.weChatParam = param;
}

- (void)getData:(NSDictionary*)param
{
    NSString*methodValue = [param objectForKey:@"key"];
    if([methodValue isEqualToString:@"siteid"])
    {
        //		NSString *siteId = [NSString stringWithFormat:@"%d", [UserWrapper shareMasterUser].siteID];
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 2)
    {
        return;
    }
    NSString *descOrigin = [self.weChatParam objectForKey:@"desc"];
    NSString *desc = [descOrigin stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *imgurlOrigin = [self.weChatParam objectForKey:@"imgurl"];
    NSString *imgurl = [imgurlOrigin stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *linkOrigin = [self.weChatParam objectForKey:@"link"];
    NSString *link = [linkOrigin stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *titleOrigin = [self.weChatParam objectForKey:@"title"];
    NSString *title = [titleOrigin stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi])
    {
        [UIAlertView displayAlertWithTitle:@"提示" message:@"您还没有安装微信，或者当前版本微信不支持分享功能，请更新后重试" leftButtonTitle:@"稍后再说" leftButtonAction:nil rightButtonTitle:@"去更新" rightButtonAction:^{
            NSString *url = [WXApi getWXAppInstallUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
    }
    [[DownLoadManager sharedDownLoadManager] downloadWithUrl:imgurl group:[IcsonImageView randomGroupName] successBlock:^(NSData * data) {
        UIImage * img = [UIImage imageWithData:data];
        if (img) {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = title;
            message.description =  desc;
            [message setThumbImage:img];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = link;
            message.mediaObject = ext;
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = (buttonIndex == 0 ? WXSceneSession : WXSceneTimeline);
            [WXApi sendReq:req];
        } else {
            [[iToast makeText:@"分享图片异常！"] show];
        }
    } failureBlock:^(NSError * err) {
        [[iToast makeText:@"分享图片异常！"] show];
    }];
}


- (void)shareSuccess:(NSNotification *)notification
{
    if (self.navigationController.topViewController == self) {
        NSDictionary *shareResp = notification.userInfo;
        int errCode = [[shareResp objectForKey:@"errCode"] intValue];
        if (errCode == 0)
        {
            int64_t delayInSeconds = .5f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
        else
        {
            NSString *errMsg = [shareResp objectForKey:@"errStr"];
            int64_t delayInSeconds = 1.0f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:errMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
    }
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
    if(self.backToLink && [self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        /*
         缓存Cookies, 用于再次进入WebView时保留QQ登录态。
         */
        if (self.webUrlString)
        {
            NSArray * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
            if (cookies)
            {
                [[WebCookieCache sharedWebCookieCache].cookiesDict setObject:cookies
                                                                      forKey:self.webUrlString];
            }
        }
        
        [super goBackController:sender];
        self.webUrlString = nil;
    }
}

#pragma mark Provate Jump Methods

- (void)pushToServiceDetailWithParams:(NSDictionary *)params {
    if (!params) {
        return;
    }
    NSString *serviceId = [params objectForKey:@"id"];
    NSString *channelId = [params objectForKey:@"chid"];
    if ([serviceId length] == 0 || [channelId length] == 0) {
        return;
    }
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:serviceId channelId:channelId];
    [self.navigationController pushViewController:controller animated:YES];
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
