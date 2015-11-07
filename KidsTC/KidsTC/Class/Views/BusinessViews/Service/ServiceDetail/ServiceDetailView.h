//
//  ServiceDetailView.h
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDetailModel.h"
#import "ServiceDetailMoreInfoView.h"

#define PULL_THRESHOLD (120)

@class ServiceDetailView;

@protocol ServiceDetailViewDataSource <NSObject>

- (ServiceDetailModel *)detailModelForServiceDetailView:(ServiceDetailView *)detailView;

@end

@protocol ServiceDetailViewDelegate <NSObject>

- (void)didClickedCouponButtonOnServiceDetailView:(ServiceDetailView *)detailView;

- (void)serviceDetailView:(ServiceDetailView *)detailView didChangedMoreInfoViewTag:(ServiceDetailMoreInfoViewTag)viewTag;

@end

@interface ServiceDetailView : UIView

@property (nonatomic, assign) id<ServiceDetailViewDataSource> dataSource;
@property (nonatomic, assign) id<ServiceDetailViewDelegate> delegate;

- (void)setIntroductionHtmlString:(NSString *)htmlString;

- (void)reloadData;

@end
