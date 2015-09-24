//
//  StoreAppointmentViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreAppointmentViewController.h"
#import "StoreAppointmentView.h"
#import "StoreDetailModel.h"
#import "PMCalendar.h"
#import "AUIPickerView.h"
#import "StoreAppointmentModel.h"
#import "GValidator.h"

@interface StoreAppointmentViewController () <StoreAppointmentViewDelegate, PMCalendarControllerDelegate, AUIPickerViewDataSource, AUIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet StoreAppointmentView *appointmentView;

@property (weak, nonatomic) IBOutlet UIView *calendarAnchorView;
@property (nonatomic, strong) PMCalendarController *pmCC;
@property (nonatomic, strong) AUIPickerView *timePickerView;

@property (nonatomic, strong) NSArray *appointTimesArray;

@property (nonatomic, strong) StoreDetailModel *detailModel;

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, copy) NSString *selectedTimeString;

@property (nonatomic, strong) HttpRequestClient *submitOrderRequest;

@property (nonatomic, strong) GValidator *validator;

- (void)setupAppointTimes;

- (BOOL)allFieldsValid;

- (StoreAppointmentModel *)getStoreAppointmentModel;

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
        self.detailModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"门店预约";
    // Do any additional setup after loading the view from its nib.
    self.selectedDate = self.detailModel.appointmentStartDate;
    [self setupAppointTimes];
    self.selectedTimeString = [self.appointTimesArray firstObject];
    
    [self.appointmentView setStoreName:self.detailModel.storeName];
    [self.appointmentView setStoreAddress:self.detailModel.storeAddress];
    [self.appointmentView setAppointDateString:[self.selectedDate dateStringWithFormat:@"yyyy-MM-dd"]];
    [self.appointmentView setAppointTimeString:[self.appointTimesArray firstObject]];
    self.appointmentView.delegate = self;
    
    self.timePickerView = [[AUIPickerView alloc] initWithDataSource:self delegate:self];
    [self.appointmentView reloadData];
    
    self.validator = [[GValidator alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark StoreAppointmentViewDelegate


- (void)didClickedDateButtonOnStoreAppointmentView:(StoreAppointmentView *)appointmentView {
    self.pmCC = [[PMCalendarController alloc] init];
    self.pmCC.delegate = self;
    self.pmCC.mondayFirstDayOfWeek = YES;
    self.pmCC.showArrow = NO;
    self.pmCC.allowsPeriodSelection = NO;
    
    self.pmCC.allowedPeriod = [PMPeriod periodWithStartDate:self.detailModel.appointmentStartDate endDate:self.detailModel.appointmentEndDate];
    
    [self.pmCC setPeriod:[PMPeriod periodWithStartDate:self.selectedDate endDate:self.selectedDate]];
    
    [self.pmCC presentCalendarFromView:self.calendarAnchorView
         permittedArrowDirections:PMCalendarArrowDirectionUnknown
                         animated:YES];
}

- (void)didClickedTimeButtonOnStoreAppointmentView:(StoreAppointmentView *)appointmentView {
    [self.timePickerView show];
}

- (void)didClickedSubmitButtonOnStoreAppointmentView:(StoreAppointmentView *)appointmentView {
    if (![self allFieldsValid]) {
        return;
    }
    if (!self.submitOrderRequest) {
        self.submitOrderRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_CREATE_APPOINTMENTORDER"];
    }
    StoreAppointmentModel *model = [self getStoreAppointmentModel];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:model.storeId, @"storeno", model.appointmentName, @"name", model.appointmentTimeString, @"time", model.appointmentPhoneNumber, @"mobile", nil];
    __weak StoreAppointmentViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [weakSelf.submitOrderRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitOrderSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf submitOrderFailed:error];
    }];
}

#pragma mark PMCalendarControllerDelegate

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod {
    [self.pmCC dismissCalendarAnimated:YES];
    NSDate *selectedDate = [newPeriod.startDate dateWithoutTime];
    NSString *dateString = [selectedDate dateStringWithFormat:@"yyyy-MM-dd"];
    [self.appointmentView setAppointDateString:dateString];
    self.selectedDate = selectedDate;
}

#pragma mark UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(AUIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(AUIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.appointTimesArray count];
}

- (NSString *)pickerView:(AUIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.appointTimesArray objectAtIndex:row];
}

- (void)didCanceledPickerView:(AUIPickerView *)pickerView {
    
}

- (void)pickerView:(AUIPickerView *)pickerView didConfirmedWithSelectedIndexArrayOfAllComponent:(NSArray *)indexArray {
    NSString *string = [self.appointTimesArray objectAtIndex:[[indexArray firstObject] integerValue]];
    [self.appointmentView setAppointTimeString:string];
    self.selectedTimeString = string;
}

#pragma mark Private methods

- (void)setupAppointTimes {
    //times
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSString *time in self.detailModel.appointmentTimes) {
        NSString *appointmentTime = [NSString stringWithFormat:@"%@:00:00", time];
        [tempArray addObject:appointmentTime];
    }
    self.appointTimesArray = [NSArray arrayWithArray:tempArray];
}


- (BOOL)allFieldsValid {
    NSString *name = [self.appointmentView.appointName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([name length] == 0) {
        [[iToast makeText:@"请填写预约人姓名"] show];
        
        return NO;
    }
    
    NSString *phone = [self.appointmentView.appointPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([phone length] == 0) {
        [[iToast makeText:@"请填写预约手机号"] show];
        return NO;
    }
    
    if (![self.validator checkMobilePhone:phone]) {
        [[iToast makeText:@"请填写正确的手机号"] show];
        return NO;
    }
    
    return YES;
}

- (StoreAppointmentModel *)getStoreAppointmentModel {
    StoreAppointmentModel *model = [[StoreAppointmentModel alloc] init];
    model.storeId = self.detailModel.storeId;
    model.appointmentName = self.appointmentView.appointName;
    NSString *timeString = [NSString stringWithFormat:@"%@ %@.000",[self.selectedDate dateStringWithFormat:@"yyyy-MM-dd"], self.selectedTimeString];
    model.appointmentTimeString = timeString;
    model.appointmentPhoneNumber = self.appointmentView.appointPhone;
    return model;
}

- (void)submitOrderSucceed:(NSDictionary *)data {
    NSString *resp = [data objectForKey:@"data"];
    if (resp && [resp isKindOfClass:[NSString class]]) {
        [[iToast makeText:resp] show];
    }
    [self goBackController:nil];
}

- (void)submitOrderFailed:(NSError *)error {
    if ([[error userInfo] count] > 0) {
        NSString *errMsg = [[error userInfo] objectForKey:@"data"];
        [[iToast makeText:errMsg] show];
    }
}

#pragma mark keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    [self.appointmentView resetViewWithKeyboardShowing:YES height:self.keyboardHeight];
}


- (void)keyboardWillDisappear:(NSNotification *)notification {
    [super keyboardWillDisappear:notification];
    [self.appointmentView resetViewWithKeyboardShowing:NO height:self.keyboardHeight];
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
