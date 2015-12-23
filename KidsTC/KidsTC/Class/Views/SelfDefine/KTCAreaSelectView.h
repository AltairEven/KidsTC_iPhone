//
//  KTCAreaSelectView.h
//  KidsTC
//
//  Created by 钱烨 on 10/12/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTCAreaSelectView;

//@protocol KTCAreaSelectViewDataSource <NSObject>
//
//@required
//
//- (NSArray *)addressStringArrayForAddressSelectView:(KTCAreaSelectView *)selectView;
//
//- (NSInteger)selectedIndexForAddressSelectView:(KTCAreaSelectView *)selectView;
//
//- (BOOL)addressSelectViewShouldDispalyBackArrow;
//
//- (NSString *)selectedAddressFullNameForAddressSelectView:(KTCAreaSelectView *)selectView;
//
//@end
//
//@protocol KTCAreaSelectViewDelegate <NSObject>
//
//- (void)addressSelectView:(KTCAreaSelectView *)selectView didSelectAtIndex:(NSUInteger)index;
//
//- (void)didTappedOnTransparentAreaOfAddressSelectView:(KTCAreaSelectView *)selectView;
//
//- (void)didSwipedOnAddressSelectView:(KTCAreaSelectView *)selectView;
//
//- (void)didTappedOnBackArrow;
//
//@end

@interface KTCAreaSelectView : UIView

//@property (nonatomic, assign) id<KTCAreaSelectViewDataSource> dataSource;
//
//@property (nonatomic, assign) id<KTCAreaSelectViewDelegate> delegate;

+ (instancetype)areaSelecteView;

- (void)showAddressSelectViewWithCurrent:(KTCAreaItem *)currentItem Selection:(void(^)(KTCAreaItem *areaItem))selection;

- (void)hideAddressSelectView;

- (void)destroy;

@end
