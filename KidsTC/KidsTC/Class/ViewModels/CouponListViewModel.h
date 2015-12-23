//
//  CouponListViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 9/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "CouponListView.h"

@interface CouponListViewModel : BaseViewModel

- (void)startUpdateDataWithViewTag:(CouponListViewTag)tag;

- (void)getMoreDataWithViewTag:(CouponListViewTag)tag;

- (void)resetResultWithViewTag:(CouponListViewTag)tag;

- (NSArray *)resultOfCurrentViewTag;

@end
