/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GViewController.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：12-18-2012
 */

#import "GViewController.h"
#import "BaseViewModel.h"

typedef enum {
    CusNavButtonLeft,
    CusNavButtonRight,
} CusNavButtonPosition;

@interface CusNavButton : UIButton
@property (nonatomic) CusNavButtonPosition postion;

@end


@implementation CusNavButton

- (UIEdgeInsets)alignmentRectInsets
{
    UIEdgeInsets insets;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        insets = UIEdgeInsetsZero;
    }
    else
    {
        if (self.postion == CusNavButtonLeft)
        {
            insets = UIEdgeInsetsMake(0, 9.0f, 0, 0);
        }
        else
        {
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            insets = UIEdgeInsetsMake(0, 0, 0, 9.0f);
        }
    }
    
    return insets;
}

@end

@interface GViewController() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) CusNavButton *rightBarButton;

@end

@implementation GViewController
@synthesize  isNavShowType;
@synthesize keyboardHeight = _keyboardHeight;


- (id)init
{
    self = [super init];
    if (self != nil) {
        self.isNavShowType = TRUE;
        [self.navigationItem setHidesBackButton:YES];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.isNavShowType = YES;
    }
    
    return self;
}

+ (GPageID)pageID
{
    return GPageIDRoot;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.bTapToEndEditing) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView:)];
        [self.view addGestureRecognizer:_tapGesture];
    }
    //keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    showFirstTime = YES;
}



- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


- (void)buildNav
{
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftBarButtonItem = nil;
    if ([self.navigationController.viewControllers count] > 1) {
		
		CusNavButton *backButton = [CusNavButton buttonWithType:UIButtonTypeCustom];
        backButton.postion = CusNavButtonLeft;
		backButton.backgroundColor = [UIColor clearColor];
        UIImage *imageNormal = [UIImage imageNamed:@"navigation_back_n"];
        UIImage *imageHighlight = [UIImage imageNamed:@"back_highlight"];
		
		if (!self.isNavShowType)
		{
			backButton.frame = CGRectMake(0.0f, 0.0f, 28.0f, 28.0f);
		}
        else
		{
			[backButton setImage:imageNormal forState:UIControlStateNormal];
			[backButton setImage:imageHighlight forState:UIControlStateHighlighted];
			backButton.frame = CGRectMake(0.0f, 0.0f, 28.f, 28.0f);
		}

        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
        
		[backButton addTarget:self action:@selector(goBackController:) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
		self.navigationItem.leftBarButtonItem = item;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self buildNav];
    
    //重新赋值delegate
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController.navigationBarHidden)
    {
        CGRect aRect = self.view.bounds;
        aRect.origin.y = self.navigationController.navigationBar.frame.size.height;
        aRect.size.height -= self.navigationController.navigationBar.frame.size.height;
        _statusView.frame =aRect;
    }
    else
    {
        _statusView.frame = self.view.bounds;
    }
    
    self.navigationItem.title = _navigationTitle;
    //开启侧滑返回, ios 7以上
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //防止子类切换页面时造成crash
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    showFirstTime = NO;
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationItem.title = @"";
}

- (void)setupBackBarButton
{
	CusNavButton *backButton = [CusNavButton buttonWithType:UIButtonTypeCustom];
    [backButton setPostion:CusNavButtonLeft];
    backButton.backgroundColor = [UIColor clearColor];
    UIImage *imageNormal = [UIImage imageNamed:@"navigation_back_n"];
    UIImage *imageHighlight = [UIImage imageNamed:@"back_highlight"];

	if (!self.isNavShowType)
	{
		[backButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
		backButton.frame = CGRectMake(0.0f, 0.0f, 28.0f, 28.0f);
	}
    else
	{
		[backButton setImage:imageNormal forState:UIControlStateNormal];
		[backButton setImage:imageHighlight forState:UIControlStateHighlighted];
		backButton.frame = CGRectMake(0.0f, 0.0f, 28.0f, 28.0f);
	}
    
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -15.f, 0, 0)];
    
	[backButton addTarget:self action:@selector(goBackController:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.backBarButtonItem = item;
}

- (void)setupLeftBarButton
{
    CusNavButton *backButton = [CusNavButton buttonWithType:UIButtonTypeCustom];
    [backButton setPostion:CusNavButtonLeft];
    backButton.backgroundColor = [UIColor clearColor];
    UIImage *imageNormal = [UIImage imageNamed:@"navigation_back_n"];
    UIImage *imageHighlight = [UIImage imageNamed:@"back_highlight"];
    
    if (!self.isNavShowType)
    {
        [backButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0.0f, 0.0f, 28.0f, 28.0f);
    }
    else
    {
        [backButton setImage:imageNormal forState:UIControlStateNormal];
        [backButton setImage:imageHighlight forState:UIControlStateHighlighted];
        backButton.frame = CGRectMake(0.0f, 0.0f, 28.0f, 28.0f);
    }
    
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
    
    [backButton addTarget:self action:@selector(goBackController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setupLeftBarButtonWithFrontImage:(NSString*)frontImgName andBackImage:(NSString *)backImgName {
    CusNavButton *backButton = [CusNavButton buttonWithType:UIButtonTypeCustom];
    [backButton setPostion:CusNavButtonLeft];
    backButton.backgroundColor = [UIColor clearColor];
    UIImage *imageNormal = [UIImage imageNamed:frontImgName];
    UIImage *imageHighlight = [UIImage imageNamed:backImgName];
    
    if (!self.isNavShowType)
    {
        [backButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0.0f, 0.0f, 28.0f, 28.0f);
    }
    else
    {
        [backButton setImage:imageNormal forState:UIControlStateNormal];
        [backButton setImage:imageHighlight forState:UIControlStateHighlighted];
        backButton.frame = CGRectMake(0.0f, 0.0f, 28.0f, 28.0f);
    }
    
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
    
    [backButton addTarget:self action:@selector(goBackController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setupRightBarButton:(NSString*)title target:(id)object action:(SEL)selector frontImage:(NSString *)frontImgName andBackImage:(NSString *)backImgName
{
	CusNavButton *rightButton = [CusNavButton buttonWithType:UIButtonTypeCustom];
    [rightButton setPostion:CusNavButtonRight];
	rightButton.backgroundColor = [UIColor clearColor];
	rightButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
	
	if (title != nil && [title length] > 0)
	{
		[rightButton setTitle:title forState:UIControlStateNormal];
		[rightButton setTitle:title forState:UIControlStateHighlighted];
		rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [rightButton setTitleColor:[AUITheme theme].navibarTitleColor_Normal forState:UIControlStateNormal];
        [rightButton setTitleColor:[AUITheme theme].navibarTitleColor_Highlight forState:UIControlStateHighlighted];
        
        if (title.length > 3) {
            CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15.0] forKey:NSFontAttributeName]];
            CGRect rect = CGRectMake(rightButton.frame.origin.x, rightButton.frame.origin.y, size.width + 40.0f, rightButton.frame.size.height);
            rightButton.frame = rect;
        }
	}
    
	if (frontImgName != nil)
    {
		if ([frontImgName rangeOfString:@".png"].location != NSNotFound)
		{
			NSUInteger index = [frontImgName rangeOfString:@".png"].location;
			frontImgName = [frontImgName substringToIndex:index];
		}
        
		UIImage *imageFront = [UIImage imageNamed:frontImgName];
		CGFloat scaleFactor = imageFront.scale;
		CGRect rect = rightButton.frame;
		CGSize imageSize = imageFront.size;
		CGFloat l = (rect.size.width - imageSize.width*scaleFactor/2.0f)/2.0f;
		CGFloat w = (rect.size.height - imageSize.height*scaleFactor/2.0f)/2.0f;
		if(w <= 0.0000001) w = 0.0f;
		if(l <= 0.0000001) l = 0.0f;
        
        UIImage *imageBack = [UIImage imageNamed:backImgName];
        
        UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsZero;
        if ([rightButton respondsToSelector:@selector(alignmentRectInsets)])
        {
            buttonEdgeInsets = [rightButton alignmentRectInsets];
        }
        
		[rightButton setImage:imageFront forState:UIControlStateNormal];
		[rightButton setImage:imageBack forState:UIControlStateHighlighted];
	}

	
    if (object != nil && selector != nil)
    {
		[rightButton addTarget:object action:selector forControlEvents:UIControlEventTouchUpInside];
	}
    
    self.rightBarButton = rightButton;
	UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	self.navigationItem.rightBarButtonItem = rItem;
}

- (void)setRightBarButtonTitle:(NSString *)title frontImage:(NSString *)frontImgName andBackImage:(NSString *)backImgName {
    
    if (title != nil && [title length] > 0)
    {
        [self.rightBarButton setTitle:title forState:UIControlStateNormal];
        [self.rightBarButton setTitle:title forState:UIControlStateHighlighted];
        
        if (title.length > 3) {
            CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15.0] forKey:NSFontAttributeName]];
            CGRect rect = CGRectMake(self.rightBarButton.frame.origin.x, self.rightBarButton.frame.origin.y, size.width + 40.0f, self.rightBarButton.frame.size.height);
            self.rightBarButton.frame = rect;
        }
    }
    
    if (frontImgName != nil)
    {
        if ([frontImgName rangeOfString:@".png"].location != NSNotFound)
        {
            NSUInteger index = [frontImgName rangeOfString:@".png"].location;
            frontImgName = [frontImgName substringToIndex:index];
        }
        
        UIImage *imageFront = [UIImage imageNamed:frontImgName];
        CGFloat scaleFactor = imageFront.scale;
        CGRect rect = self.rightBarButton.frame;
        CGSize imageSize = imageFront.size;
        CGFloat l = (rect.size.width - imageSize.width*scaleFactor/2.0f)/2.0f;
        CGFloat w = (rect.size.height - imageSize.height*scaleFactor/2.0f)/2.0f;
        if(w <= 0.0000001) w = 0.0f;
        if(l <= 0.0000001) l = 0.0f;
        
        UIImage *imageBack = [UIImage imageNamed:backImgName];
        
        UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsZero;
        if ([self.rightBarButton respondsToSelector:@selector(alignmentRectInsets)])
        {
            buttonEdgeInsets = [self.rightBarButton alignmentRectInsets];
        }
        
        [self.rightBarButton setImage:imageFront forState:UIControlStateNormal];
        [self.rightBarButton setImage:imageBack forState:UIControlStateHighlighted];
    }
}

- (void)goBackController:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated: YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
 显示网络异常状态，监听点击事件
 */
- (void)showConnectError:(BOOL)show
{
    BOOL opaque = YES;
    if (_statusView != nil)
    {
        opaque = _statusView.opaqueBG;
    }
    [self showConnectError:show opaqueBG:opaque];
}

- (void)showConnectError:(BOOL)show opaqueBG:(BOOL)opaque
{
    if (_isConnectFailed != show)
    {
        if (show)
        {
            if (!_statusView)
            {
                _statusView = [[GConnectUselessView alloc] initWithFrame:self.view.bounds];
                _statusView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                _statusView.hidden = YES;
                _statusView.delegate = self;
                
                [self.view addSubview:_statusView];
                
                if (self.navigationController.navigationBarHidden)
                {
                    CGRect aRect = self.view.bounds;
                    aRect.origin.y = self.navigationController.navigationBar.frame.size.height;
                    aRect.size.height -= self.navigationController.navigationBar.frame.size.height;
                    _statusView.frame =aRect;
                }
                else
                {
                    _statusView.frame = self.view.bounds;
                }
                
            }
            _statusView.opaqueBG = opaque;
            
            [self.view bringSubviewToFront:_statusView];
            _statusView.hidden = NO;
        }
        else
        {
            _statusView.hidden = YES;
        }
        _isConnectFailed = show;
    }
}
#pragma - GConnectUselessViewDelegate
/*
 Overwrite buy subclass to reload data.
 当前页面为空时调用
 */
- (void)reloadNetworkData
{
    [self showConnectError:YES];
}
- (void)connectUselessViewTryReconnect:(GConnectUselessView *)aView
{
    [self showConnectError:NO];
    [self reloadNetworkData];
}

- (void)setupWechatBackButton
{
	UIButton*butonGoBackWeChat = [UIButton buttonWithType:UIButtonTypeCustom];
	[GToolUtil configureButton:butonGoBackWeChat withFont:20 withTextColor:[UIColor whiteColor] withTitle:@"回到微信" withNorImage:nil withHighImage:nil];
	[butonGoBackWeChat addTarget:self action:@selector(goBackWeChat) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goBackWeChat
{
//	[WXApi openWXApp];
}



#pragma mark Gesture

- (void)didTapOnView:(id)Sender {
    [self.view endEditing:YES];
}



#pragma mark Keyboard Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    _keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}


- (void)keyboardWillDisappear:(NSNotification *)notification {
}



#pragma mark UIGestureRecognizerDelegate


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL bShouldBegin = YES;
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        if ([self.navigationController.viewControllers count] == 1) {
            //栈底不响应
            bShouldBegin = NO;
        }
    }
    return bShouldBegin;
}

#pragma mark AUIStairsController

- (UIView *)stairControledView {
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
