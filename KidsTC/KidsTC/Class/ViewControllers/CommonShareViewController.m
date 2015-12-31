//
//  CommonShareViewController.m
//  KidsTC
//
//  Created by Altair on 11/20/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommonShareViewController.h"
#import "CommonShareService.h"
#import "KTCShareService.h"

@interface CommonShareViewController ()

@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UIView *displayBGView;

@property (weak, nonatomic) IBOutlet UIButton *wechatSessionButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatTimeLineButton;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *qzoneButton;
@property (weak, nonatomic) IBOutlet UIButton *canceButton;

@property (weak, nonatomic) IBOutlet UILabel *wechatSessionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatTimeLineTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weiboTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qzoneTitleLabel;

- (void)resetShareButtonStatus;

- (IBAction)didClickedShareButton:(id)sender;

- (IBAction)didClickedCancelButton:(id)sender;

@end

@implementation CommonShareViewController

- (instancetype)initWithShareObject:(CommonShareObject *)object sourceType:(KTCShareServiceType)type {
    self = [super initWithNibName:@"CommonShareViewController" bundle:nil];
    if (self) {
        _shareObject = object;
        _sourceType = type;
    }
    return self;
}

+ (instancetype)instanceWithShareObject:(CommonShareObject *)object {
    CommonShareViewController *controller = [[CommonShareViewController alloc] initWithShareObject:object sourceType:KTCShareServiceTypeUnknow];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    return controller;
}

+ (instancetype)instanceWithShareObject:(CommonShareObject *)object sourceType:(KTCShareServiceType)type {
    CommonShareViewController *controller = [[CommonShareViewController alloc] initWithShareObject:object sourceType:type];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.displayBGView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    [self.tapView setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetShareButtonStatus];
    [self.view.superview setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tapView setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tapView setHidden:YES];
    _shareObject = nil;
}

#pragma mark Private methods

- (void)resetShareButtonStatus {
    NSDictionary *shareAvailableDic = [CommonShareService shareTypeAvailablities];
    
    BOOL canShare = [[shareAvailableDic objectForKey:kCommonShareTypeWechatSessionKey] boolValue];
    if (canShare) {
        [self.wechatSessionButton setEnabled:YES];
        [self.wechatSessionTitleLabel setAlpha:1];
    } else {
        [self.wechatSessionButton setEnabled:NO];
        [self.wechatSessionTitleLabel setAlpha:0.4];
    }
    canShare = [[shareAvailableDic objectForKey:kCommonShareTypeWechatTimeLineKey] boolValue];
    if (canShare) {
        [self.wechatTimeLineButton setEnabled:YES];
        [self.wechatTimeLineTitleLabel setAlpha:1];
    } else {
        [self.wechatTimeLineButton setEnabled:NO];
        [self.wechatTimeLineTitleLabel setAlpha:0.4];
    }
    canShare = [[shareAvailableDic objectForKey:kCommonShareTypeWeiboKey] boolValue];
    if (canShare) {
        [self.weiboButton setEnabled:YES];
        [self.weiboTitleLabel setAlpha:1];
    } else {
        [self.weiboButton setEnabled:NO];
        [self.weiboTitleLabel setAlpha:0.4];
    }
    canShare = [[shareAvailableDic objectForKey:kCommonShareTypeQQKey] boolValue];
    if (canShare) {
        [self.qqButton setEnabled:YES];
        [self.qqTitleLabel setAlpha:1];
    } else {
        [self.qqButton setEnabled:NO];
        [self.qqTitleLabel setAlpha:0.4];
    }
    canShare = [[shareAvailableDic objectForKey:kCommonShareTypeQZoneKey] boolValue];
    if (canShare) {
        [self.qzoneButton setEnabled:YES];
        [self.qzoneTitleLabel setAlpha:1];
    } else {
        [self.qzoneButton setEnabled:NO];
        [self.qzoneTitleLabel setAlpha:0.4];
    }
}

- (IBAction)didClickedShareButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    CommonShareType type = (CommonShareType)button.tag;
    CommonShareObject *object = [self.shareObject copyObject];
    [[CommonShareService sharedService] startThirdPartyShareWithType:type object:object succeed:^{
        [[iToast makeText:@"分享成功"] show];
        [[KTCShareService service] sendShareSucceedFeedbackToServerWithIdentifier:object.identifier channel:type + 1 type:self.sourceType title:object.title];
    } failure:^(NSError *error) {
        NSString *errMsg = [error.userInfo objectForKey:kErrMsgKey];
        if ([errMsg length] == 0) {
            errMsg = @"分享失败";
        }
        [[iToast makeText:errMsg] show];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
