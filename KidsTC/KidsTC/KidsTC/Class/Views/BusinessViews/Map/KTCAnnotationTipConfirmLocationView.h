//
//  KTCAnnotationTipConfirmLocationView.h
//  KidsTC
//
//  Created by 钱烨 on 8/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@class KTCAnnotationTipConfirmLocationView;

@protocol KTCAnnotationTipConfirmViewDelegate <NSObject>

- (void)didClickedCancelButtonOnAnnotationTipConfirmView:(KTCAnnotationTipConfirmLocationView *)view;

- (void)didClickedConfirmButtonOnAnnotationTipConfirmView:(KTCAnnotationTipConfirmLocationView *)view;

@end

@interface KTCAnnotationTipConfirmLocationView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, assign) id<BMKAnnotation> annotation;

@property (nonatomic, assign) id<KTCAnnotationTipConfirmViewDelegate> delegate;

- (void)setConfirmText:(NSString *)text;

- (void)setCancelText:(NSString *)text;

@end
