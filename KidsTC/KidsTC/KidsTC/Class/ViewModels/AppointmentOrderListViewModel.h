//
//  AppointmentOrderListViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "AppointmentOrderListView.h"

@interface AppointmentOrderListViewModel : BaseViewModel

- (NSArray *)currentResultArray;

- (void)startUpdateDataWithOrderListStatus:(AppointmentOrderListStatus)status;

- (void)getMoreDataWithOrderListStatus:(AppointmentOrderListStatus)status;

- (void)resetResultWithOrderListStatus:(AppointmentOrderListStatus)status;

@end
