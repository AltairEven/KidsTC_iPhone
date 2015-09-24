//
//  StoreAppointmentView.h
//  KidsTC
//
//  Created by 钱烨 on 7/30/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreAppointmentView;

@protocol StoreAppointmentViewDelegate <NSObject>

- (void)didClickedDateButtonOnStoreAppointmentView:(StoreAppointmentView *)appointmentView;

- (void)didClickedTimeButtonOnStoreAppointmentView:(StoreAppointmentView *)appointmentView;

- (void)didClickedSubmitButtonOnStoreAppointmentView:(StoreAppointmentView *)appointmentView;

@end

@interface StoreAppointmentView : UIView

@property (nonatomic, assign) id<StoreAppointmentViewDelegate> delegate;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *storeAddress;

@property (nonatomic, copy, readonly) NSString *appointName;

@property (nonatomic, copy, readonly) NSString *appointPhone;

- (void)reloadData;

- (void)endEditing;

- (void)resetViewWithKeyboardShowing:(BOOL)showing height:(CGFloat)height;

- (void)setAppointDateString:(NSString *)dateString;

- (void)setAppointTimeString:(NSString *)timeString;

@end
