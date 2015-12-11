//
//  KTCAnnotationTipWelfareItemView.h
//  KidsTC
//
//  Created by Altair on 12/11/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@class KTCAnnotationTipWelfareItemView;
@class KTCAnnotationTipWelfareItem;

@protocol KTCAnnotationTipWelfareItemViewDelegate <NSObject>

- (void)didClickedGotoButtonOnAnnotationTipWelfareItemView:(KTCAnnotationTipWelfareItemView *)view;

- (void)didClickedGoDetailButtonOnAnnotationTipWelfareItemView:(KTCAnnotationTipWelfareItemView *)view;

@end

@interface KTCAnnotationTipWelfareItemView : UIView

@property (nonatomic, strong) KTCAnnotationTipWelfareItem *itemModel;

@property (nonatomic, assign) id<BMKAnnotation> annotation;

@property (nonatomic, assign) id<KTCAnnotationTipWelfareItemViewDelegate> delegate;

@end

@class LoveHouseListItemModel;
@class HospitalListItemModel;

@interface KTCAnnotationTipWelfareItem : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *welfareDescription;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *distanceDescription;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

+ (instancetype)welfareItemFromLoveHouseListItemModel:(LoveHouseListItemModel *)itemModel;

+ (instancetype)welfareItemFromHospitalListItemModel:(HospitalListItemModel *)itemModel;

@end
