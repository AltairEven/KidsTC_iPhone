//
//  AppointmentOrderDetailView.h
//  KidsTC
//
//  Created by 钱烨 on 8/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentOrderModel.h"

@class AppointmentOrderDetailView;

@protocol AppointmentOrderDetailViewDataSource <NSObject>

- (AppointmentOrderModel *)orderModelForAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView;

@end

@protocol AppointmentOrderDetailViewDelegate <NSObject>

- (void)didClickedStoreOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView;

- (void)didClickedCommentButtonOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView;

- (void)didClickedCancelButtonOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView;

- (void)didClickedGetCodeButtonOnAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView;

@end

@interface AppointmentOrderDetailView : UIView

@property (nonatomic, assign) id<AppointmentOrderDetailViewDataSource> dataSource;

@property (nonatomic, assign) id<AppointmentOrderDetailViewDelegate> delegate;

- (void)reloadData;

@end
