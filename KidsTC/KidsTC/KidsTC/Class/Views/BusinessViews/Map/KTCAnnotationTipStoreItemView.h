//
//  KTCAnnotationTipStoreItemView.h
//  KidsTC
//
//  Created by Altair on 12/11/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@class KTCAnnotationTipStoreItemView;
@class KTCAnnotationTipStoreItem;

@protocol KTCAnnotationTipStoreItemViewDelegate <NSObject>

- (void)didClickedGotoButtonOnAnnotationTipStoreItemView:(KTCAnnotationTipStoreItemView *)view;

- (void)didClickedGoDetailButtonOnAnnotationTipStoreItemView:(KTCAnnotationTipStoreItemView *)view;

@end

@interface KTCAnnotationTipStoreItemView : UIView

@property (nonatomic, strong) KTCAnnotationTipStoreItem *storeItem;

@property (nonatomic, assign) id<BMKAnnotation> annotation;

@property (nonatomic, assign) id<KTCAnnotationTipStoreItemViewDelegate> delegate;

@end

@class StoreListItemModel;
@class StoreDetailModel;

@interface KTCAnnotationTipStoreItem : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, assign) NSUInteger starNumber;

+ (instancetype)annotationStoreItemFromStoreListItemModel:(StoreListItemModel *)model;

+ (instancetype)annotationStoreItemFromStoreDetailModel:(StoreDetailModel *)model;

@end
