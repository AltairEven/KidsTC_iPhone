//
//  FlashDetailView.h
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashDetailModel.h"
#import "ServiceDetailMoreInfoView.h"

@class FlashDetailView;

@protocol FlashDetailViewDataSource <NSObject>

- (ServiceDetailModel *)detailModelForFlashDetailView:(FlashDetailView *)detailView;

@end

@protocol FlashDetailViewDelegate <NSObject>

- (void)FlashDetailView:(FlashDetailView *)detailView didChangedMoreInfoViewTag:(ServiceDetailMoreInfoViewTag)viewTag;

- (void)FlashDetailView:(FlashDetailView *)detailView didClickedStoreCellAtIndex:(NSUInteger)index;

- (void)FlashDetailView:(FlashDetailView *)detailView didClickedCommentCellAtIndex:(NSUInteger)index;

- (void)didClickedMoreCommentOnFlashDetailView:(FlashDetailView *)detailView;

- (void)FlashDetailView:(FlashDetailView *)detailView didScrolledAtOffset:(CGPoint)offset;

- (void)FlashDetailView:(FlashDetailView *)detailView didSelectedLinkWithSegueModel:(HomeSegueModel *)model;

- (void)didClickedStoreBriefOnFlashDetailView:(FlashDetailView *)detailView;

@end

@interface FlashDetailView : UIView

@property (nonatomic, assign) id<FlashDetailViewDataSource> dataSource;
@property (nonatomic, assign) id<FlashDetailViewDelegate> delegate;

- (void)setIntroductionUrlString:(NSString *)urlString;

- (void)reloadData;

@end
