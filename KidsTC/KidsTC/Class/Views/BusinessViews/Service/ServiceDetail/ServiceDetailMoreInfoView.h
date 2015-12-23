//
//  ServiceDetailMoreInfoView.h
//  KidsTC
//
//  Created by 钱烨 on 10/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListItemModel.h"
#import "CommentListItemModel.h"

@class ServiceDetailMoreInfoView;

typedef  enum {
    ServiceDetailMoreInfoViewTagIntroduction,
    ServiceDetailMoreInfoViewTagStore,
    ServiceDetailMoreInfoViewTagComment
}ServiceDetailMoreInfoViewTag;

@protocol ServiceDetailMoreInfoViewDelegate <NSObject>

- (void)serviceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView didChangedViewContentSize:(CGSize)size;

- (void)serviceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView didClickedStoreAtIndex:(NSUInteger)index;

- (void)serviceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView didClickedCommentAtIndex:(NSUInteger)index;

- (void)didClickedMoreCommentButtonOnServiceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView;

@end

@interface ServiceDetailMoreInfoView : UIView

@property (nonatomic, assign) id<ServiceDetailMoreInfoViewDelegate> delegate;

@property (nonatomic, assign) CGSize standardViewSize;

@property (nonatomic, assign) ServiceDetailMoreInfoViewTag viewTag;

@property (nonatomic, copy) NSString *introductionUrlString;

@property (nonatomic, strong) NSArray *storeListModels;

@property (nonatomic, strong) NSArray *commentListModels;

- (void)setScrollEnabled:(BOOL)enabled;

@end
