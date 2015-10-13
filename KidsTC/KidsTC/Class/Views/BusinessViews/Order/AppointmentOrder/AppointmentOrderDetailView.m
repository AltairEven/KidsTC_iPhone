//
//  AppointmentOrderDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 8/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppointmentOrderDetailView.h"

@interface AppointmentOrderDetailView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *storeInfoCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *orderInfoCell;

//store
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentTimeDesLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelAppointmentButton;
//order
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentNameLabel;

@property (nonatomic, strong) UIButton *getCodeButton;

@property (nonatomic, strong) AppointmentOrderModel *orderModel;

- (IBAction)didClickedCommentButton:(id)sender;
- (IBAction)didClickedCancelButton:(id)sender;

- (void)didClickedGetCodeButton:(id)sender;

@end

@implementation AppointmentOrderDetailView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        AppointmentOrderDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.commentButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.commentButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    
    self.cancelAppointmentButton.layer.borderWidth = BORDER_WIDTH;
    self.cancelAppointmentButton.layer.borderColor = RGBA(255, 125, 125, 1).CGColor;
    [self.cancelAppointmentButton.layer setMasksToBounds:YES];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getCodeButton setFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 40)];
    [self.getCodeButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.getCodeButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.getCodeButton setTitle:@"获取消费码" forState:UIControlStateNormal];
    [self.getCodeButton addTarget:self action:@selector(didClickedGetCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:self.getCodeButton];
    self.tableView.tableFooterView = footerView;
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderModel) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderModel) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            [self.storeImageView setImageWithURL:self.orderModel.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
            [self.storeNameLabel setText:self.orderModel.storeName];
            [self.appointmentTimeDesLabel setText:self.orderModel.appointmentTimeDes];
            [self.commentButton setHidden:[self.orderModel canComment]];
            [self.cancelAppointmentButton setHidden:[self.orderModel canCancel]];
            [self.storeInfoCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.storeInfoCell;
        }
            break;
        case 1:{
            [self.orderIdLabel setText:self.orderModel.orderId];
            [self.orderStatusDesLabel setText:self.orderModel.statusDescription];
            [self.phoneLabel setText:self.orderModel.phoneNumber];
            [self.appointmentNameLabel setText:self.orderModel.appointmentName];
            [self.orderInfoCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.orderInfoCell;
        }
            break;
        default:
            break;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
        {
            height = self.storeInfoCell.frame.size.height;
        }
            break;
        case 1:
        {
            height = self.orderInfoCell.frame.size.height;
        }
            break;
        default:
            break;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section > 0) {
        height = 2.5;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedStoreOnAppointmentOrderDetailView:)]) {
            [self.delegate didClickedStoreOnAppointmentOrderDetailView:self];
        }
    }
}

#pragma mark Private methods

- (IBAction)didClickedCommentButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCommentButtonOnAppointmentOrderDetailView:)]) {
        [self.delegate didClickedCommentButtonOnAppointmentOrderDetailView:self];
    }
}

- (IBAction)didClickedCancelButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCancelButtonOnAppointmentOrderDetailView:)]) {
        [self.delegate didClickedCancelButtonOnAppointmentOrderDetailView:self];
    }
}

- (void)didClickedGetCodeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGetCodeButtonOnAppointmentOrderDetailView:)]) {
        [self.delegate didClickedGetCodeButtonOnAppointmentOrderDetailView:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(orderModelForAppointmentOrderDetailView:)]) {
        self.orderModel = [self.dataSource orderModelForAppointmentOrderDetailView:self];
        [self.tableView reloadData];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
