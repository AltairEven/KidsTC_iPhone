//
//  KTCAnnotationTipDestinationView.h
//  KidsTC
//
//  Created by 钱烨 on 8/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@class KTCAnnotationTipDestinationView;

@protocol KTCAnnotationTipDestinationViewDelegate <NSObject>

- (void)didClickedConfirmButtonOnAnnotationTipDestinationView:(KTCAnnotationTipDestinationView *)view;

@end

@interface KTCAnnotationTipDestinationView : UIView

@property (nonatomic, assign) id<BMKAnnotation> annotation;

@property (nonatomic, assign) id<KTCAnnotationTipDestinationViewDelegate> delegate;

- (void)setContentText:(NSString *)text;

- (void)setConfirmText:(NSString *)text;

@end
