//
//  StoreAppointmentView.m
//  KidsTC
//
//  Created by 钱烨 on 7/30/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreAppointmentView.h"

typedef enum {
    StoreAppointmentViewTagStoreName,
    StoreAppointmentViewTagStoreAddress,
    StoreAppointmentViewTagAppointName,
    StoreAppointmentViewTagAppointTime,
    StoreAppointmentViewTagAppointPhone
}StoreAppointmentViewTag;

#define CellHeight  (44)

@interface StoreAppointmentView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *storeNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *storeAddressCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *appointNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *appointTimeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *appointPhoneCell;

//store info
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;
//name
@property (weak, nonatomic) IBOutlet UITextField *appointNameField;
//time
@property (weak, nonatomic) IBOutlet UIButton *appointDateButton;
@property (weak, nonatomic) IBOutlet UIButton *appointTimeButton;
//phone
@property (weak, nonatomic) IBOutlet UITextField *appointPhoneField;

@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, assign) NSIndexPath *currentEditingIndexPath;

@property (nonatomic, assign) BOOL keyboardIsShowing;

- (IBAction)didClickedDateButton:(id)sender;
- (IBAction)didClickedTimeButton:(id)sender;
- (void)didClickedSubmitButton;

@end

@implementation StoreAppointmentView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        StoreAppointmentView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    UIView *footBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 40)];
    [self.submitButton setBackgroundColor:COLOR_GLOBAL_NORMAL forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:COLOR_GLOBAL_HIGHLIGHT forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundColor:COLOR_GLOBAL_DISABLE forState:UIControlStateDisabled];
    [self.submitButton setTitle:@"提交预约" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(didClickedSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [footBG addSubview:self.submitButton];
    
    self.tableView.tableFooterView = footBG;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.appointNameField.delegate = self;
    self.appointPhoneField.delegate = self;
    
    self.appointDateButton.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.appointDateButton.layer.borderWidth = BORDER_WIDTH;
    self.appointDateButton.layer.cornerRadius = 5;
    self.appointDateButton.layer.masksToBounds = YES;
    
    self.appointTimeButton.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.appointTimeButton.layer.borderWidth = BORDER_WIDTH;
    self.appointTimeButton.layer.cornerRadius = 5;
    self.appointTimeButton.layer.masksToBounds = YES;
}

- (void)setStoreName:(NSString *)storeName {
    _storeName = storeName;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)setStoreAddress:(NSString *)storeAddress {
    _storeAddress = storeAddress;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSString *)appointName {
    return self.appointNameField.text;
}


- (NSString *)appointPhone {
    return self.appointPhoneField.text;
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger number = 0;
    switch (section) {
        case 0:
        {
            number = 2;
        }
            break;
        case 1:
        {
            number = 3;
        }
            break;
        default:
            break;
    }
    return number;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case StoreAppointmentViewTagStoreName:
            {
                [self.storeNameLabel setText:self.storeName];
                cell = self.storeNameCell;
            }
                break;
            case StoreAppointmentViewTagStoreAddress:
            {
                [self.storeAddressLabel setText:self.storeAddress];
                cell = self.storeAddressCell;
            }
                break;
            default:
                break;
        }
    } else {
        StoreAppointmentViewTag tag = (StoreAppointmentViewTag)(indexPath.row + 2);
        switch (tag) {
            case StoreAppointmentViewTagAppointName:
            {
                cell = self.appointNameCell;
            }
                break;
            case StoreAppointmentViewTagAppointTime:
            {
                cell = self.appointTimeCell;
            }
                break;
            case StoreAppointmentViewTagAppointPhone:
            {
                cell = self.appointPhoneCell;
            }
                break;
            default:
                break;
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self endEditing];
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.appointNameField) {
        self.currentEditingIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    } else if (textField == self.appointPhoneField) {
        self.currentEditingIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.appointNameField isEditing]) {
        [self.appointPhoneField becomeFirstResponder];
        CGPoint currentOffset = self.tableView.contentOffset;
        [self.tableView setContentOffset:CGPointMake(currentOffset.x, currentOffset.y + CellHeight * 2) animated:YES];
    } else {
        [self.appointPhoneField resignFirstResponder];
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark Private methods

- (IBAction)didClickedDateButton:(id)sender {
    [self endEditing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedDateButtonOnStoreAppointmentView:)]) {
        [self.delegate didClickedDateButtonOnStoreAppointmentView:self];
    }
}

- (IBAction)didClickedTimeButton:(id)sender {
    [self endEditing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedTimeButtonOnStoreAppointmentView:)]) {
        [self.delegate didClickedTimeButtonOnStoreAppointmentView:self];
    }
}

- (void)didClickedSubmitButton {
    [self endEditing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSubmitButtonOnStoreAppointmentView:)]) {
        [self.delegate didClickedSubmitButtonOnStoreAppointmentView:self];
    }
}


#pragma  mark Public methods

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)resetViewWithKeyboardShowing:(BOOL)showing height:(CGFloat)height {
    if (showing) {
        if (!self.keyboardIsShowing) {
            CGSize sizeNew = CGSizeMake(0, self.tableView.contentSize.height + height);
            [self.tableView setContentSize:sizeNew];
            CGFloat yOffset = CellHeight * 3 + 10 + (self.currentEditingIndexPath.row + 1) * CellHeight - (SCREEN_HEIGHT - 64 - height);
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, yOffset)];
            self.keyboardIsShowing = YES;
        }
    } else {
        if (self.keyboardIsShowing) {
            CGSize sizeNew = CGSizeMake(0, self.tableView.contentSize.height - height);
            [self.tableView setContentSize:sizeNew];
            self.keyboardIsShowing = NO;
        }
    }
}


- (void)endEditing {
    [self endEditing:YES];
}

- (void)setAppointDateString:(NSString *)dateString {
    [self.appointDateButton setTitle:dateString forState:UIControlStateNormal];
}

- (void)setAppointTimeString:(NSString *)timeString {
    [self.appointTimeButton setTitle:timeString forState:UIControlStateNormal];
}


@end
