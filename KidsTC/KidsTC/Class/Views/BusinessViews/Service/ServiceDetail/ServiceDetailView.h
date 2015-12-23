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

- (void)didClickedCouponOnServiceDetailView:(ServiceDetailView *)detailView;

- (void)serviceDetailView:(ServiceDetailView *)detailView didChangedMoreInfoViewTag:(ServiceDetailMoreInfoViewTag)viewTag;

- (void)serviceDetailView:(ServiceDetailView *)detailView didClickedStoreCellAtIndex:(NSUInteger)index;

- (void)serviceDetailView:(ServiceDetailView *)detailView didClickedCommentCellAtIndex:(NSUInteger)index;

- (void)didClickedMoreCommentOnServiceDetailView:(ServiceDetailView *)detailView;

@end

@interface ServiceDetailView : UIView

@property (nonatomic, assign) id<ServiceDetailViewDataSource> dataSource;
@property (nonatomic, assign) id<ServiceDetailViewDelegate> delegate;

- (void)setIntroductionUrlString:(NSString *)urlString;

- (void)reloadData;

@end
