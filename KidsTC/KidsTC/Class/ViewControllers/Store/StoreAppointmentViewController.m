//
//  StoreAppointmentViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreAppointmentViewController.h"
#import "StoreAppointmentModel.h"
#import "GValidator.h"

#define StandardBGHeight (150)

@interface StoreAppointmentViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UIView *appointmentBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appointmentBGHeight;
@property (weak, nonatomic) IBOutlet UIView *businessTimeBGView;
@property (weak, nonatomic) IBOutlet UILabel *businessTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *phoneBGView;
@property (weak, nonatomic) IBOutlet UITextField *phoneFiled;
@property (weak, nonatomic) IBOutlet UIButton *appointmentButton;

@property (nonatomic, strong) StoreAppointmentModel *appointmentModel;

@property (nonatomic, strong) HttpRequestClient *submitOrderRequest;

- (void)buidlSubViews;

- (void)buildActivitysViewWithActivityLogoItems:(NSArray *)items;

- (void)didClickedOnTapView;

- (IBAction)didClickedAppointmentButton:(id)sender;

- (BOOL)allFieldsValid;

- (void)submitOrderSucceed:(NSDictionary *)data;

- (void)submitOrderFailed:(NSError *)error;

@end

@implementation StoreAppointmentViewController

- (instancetype)initWithStoreDetailModel:(StoreDetailModel *)model {
    if (!model) {
        return nil;
    }
    self = [super initWithNibName:@"StoreAppointmentViewController" bundle:nil];
    if (self) {
        self.appointmentModel = [StoreAppointmentModel appointmentModelFromStroeDetailModel:model];
    }
    return self;
}

+ (instancetype)instanceWithStoreDetailModel:(StoreDetailModel *)model {
    StoreAppointmentViewController *controller = [[StoreAppointmentViewController alloc] initWithStoreDetailModel:model];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"门店预约";
    // Do any additional setup after loading the view from its nib.
    [self buidlSubViews];
    [self.tapView setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view.superview setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tapView setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tapView setHidden:YES];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
    [self.submitOrderRequest cancel];
    [self.phoneFiled resignFirstResponder];
}

#pragma mark Private methods

- (void)buidlSubViews {
    //tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedOnTapView)];
    [self.tapView addGestureRecognizer:tap];
    //activity
    BOOL hasActivities = NO;
    if ([self.appointmentModel.activities count] > 0) {
        [self buildActivitysViewWithActivityLogoItems:self.appointmentModel.activities];
        hasActivities = YES;
    } else {
        self.appointmentBGHeight.constant = StandardBGHeight;
    }
    //lines
    CGPoint start = CGPointMake(0, 0);
    CGPoint end = CGPointMake(SCREEN_WIDTH, 0);
    CGFloat lineWidth = 0.5;
    CGFloat gap = 2;
    CGFloat sectionLength = 2;
    UIColor *color = RGBA(245, 245, 245, 1);
    if (hasActivities) {
        [GToolUtil drawLineOnView:self.businessTimeBGView withStartPoint:start endPoint:end lineWidth:lineWidth gap:gap sectionLength:sectionLength color:color isVirtual:YES];
    }
    start = CGPointMake(0, self.businessTimeBGView.bounds.size.height);
    end = CGPointMake(SCREEN_WIDTH, self.businessTimeBGView.bounds.size.height);
    [GToolUtil drawLineOnView:self.businessTimeBGView withStartPoint:start endPoint:end lineWidth:lineWidth gap:gap sectionLength:sectionLength color:color isVirtual:YES];
    [self.businessTimeLabel setText:self.appointmentModel.appointmentTimeString];
    //button
    self.appointmentButton.layer.cornerRadius = 5;
    self.appointmentButton.layer.masksToBounds = YES;
    [self.appointmentButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.appointmentButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
}

- (void)buildActivitysViewWithActivityLogoItems:(NSArray *)items {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor darkGrayColor]];
    [titleLabel setText:@"童成为您谋福利，预约即可享受"];
    [bgView addSubview:titleLabel];
    
    UIScrollView *activityBGView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 60)];
    [activityBGView setBackgroundColor:[UIColor clearColor]];
    [activityBGView setShowsHorizontalScrollIndicator:NO];
    [activityBGView setShowsVerticalScrollIndicator:NO];
    [bgView addSubview:activityBGView];
    
    CGFloat xPosition = 10;
    CGFloat yPosition = 5;
    for (ActivityLogoItem *item in items) {
        UIView *singleBGView = [[UIView alloc] initWithFrame:CGRectMake(xPosition, yPosition, activityBGView.frame.size.width, 20)];
        UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [checkImageView setImage:item.image];
        [singleBGView addSubview:checkImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, singleBGView.frame.size.width - 20, 20)];
        [label setTextColor:[UIColor orangeColor]];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setText:item.itemDescription];
        [singleBGView addSubview:label];
        
        [activityBGView addSubview:singleBGView];
        
        yPosition += singleBGView.frame.size.height + 5;
    }
    CGFloat bgHeight = yPosition;
    [activityBGView setContentSize:CGSizeMake(0, bgHeight)];
    if (bgHeight > 60) {
        bgHeight = 60;
    }
    [activityBGView setFrame:CGRectMake(activityBGView.frame.origin.x, activityBGView.frame.origin.y, activityBGView.frame.size.width, bgHeight)];
    [bgView setFrame:CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, activityBGView.frame.origin.y + activityBGView.frame.size.height)];
    
    [GToolUtil drawLineOnView:bgView withStartPoint:CGPointMake(5, 30) endPoint:CGPointMake(SCREEN_WIDTH - 5, 30) lineWidth:0.5 gap:0 sectionLength:0 color:RGBA(245, 245, 245, 1) isVirtual:NO];
    
    CGFloat height = self.appointmentBGHeight.constant;
    self.appointmentBGHeight.constant = height + bgView.frame.size.height;
    [self.appointmentBGView addSubview:bgView];
}

- (void)didClickedOnTapView {
    if ([self.phoneFiled isFirstResponder]) {
        [self.phoneFiled resignFirstResponder];
    } else {
        [self goBackController:nil];
    }
}

- (IBAction)didClickedAppointmentButton:(id)sender {
    if (![self allFieldsValid]) {
        return;
    }
    if (!self.submitOrderRequest) {
        self.submitOrderRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_CREATE_APPOINTMENTORDER"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.appointmentModel.storeId, @"storeno", self.appointmentModel.appointmentPhoneNumber, @"mobile", nil];
    __weak StoreAppointmentViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
    [weakSelf.submitOrderRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitOrderSucceed:responseData];
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_appoint_result" props:trackParam];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitOrderFailed:error];
        NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:@"false", @"result", nil];
        [MTA trackCustomKeyValueEvent:@"event_result_appoint_result" props:trackParam];
    }];

}

- (BOOL)allFieldsValid {
    NSString *phone = [self.phoneFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([phone length] == 0) {
        [[iToast makeText:@"请填写预约手机号"] show];
        return NO;
    }
    
    if (![GValidator checkMobilePhone:phone]) {
        [[iToast makeText:@"请填写正确的手机号"] show];
        return NO;
    }
    
    self.appointmentModel.appointmentPhoneNumber = phone;
    return YES;
}

- (void)submitOrderSucceed:(NSDictionary *)data {
    NSString *resp = [data objectForKey:@"data"];
    if (resp && [resp isKindOfClass:[NSString class]]) {
        [[iToast makeText:resp] show];
    } else {
        [[iToast makeText:@"恭喜您，预约成功！"] show];
    }
    [self goBackController:nil];
}

- (void)submitOrderFailed:(NSError *)error {
    if ([[error userInfo] count] > 0) {
        NSString *errMsg = [[error userInfo] objectForKey:@"data"];
        [[iToast makeText:errMsg] show];
    } else {
        [[iToast makeText:@"预约失败"] show];
    }
}

#pragma mark keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - self.keyboardHeight, self.view.frame.size.width, self.view.frame.size.height)];
}


- (void)keyboardWillDisappear:(NSNotification *)notification {
    [super keyboardWillDisappear:notification];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.keyboardHeight, self.view.frame.size.width, self.view.frame.size.height)];
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
