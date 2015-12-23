//
//  SoftwareSettingView.h
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoftwareSettingModel.h"

typedef enum {
    SoftwareSettingViewTagCache,
    SoftwareSettingViewTagVersion,
    SoftwareSettingViewTagAbout,
    SoftwareSettingViewTagFeedback
}SoftwareSettingViewTag;

@class SoftwareSettingView;

@protocol SoftwareSettingViewDataSource <NSObject>

- (SoftwareSettingModel *)modelForSoftwareSettingView:(SoftwareSettingView *)view;

@end

@protocol SoftwareSettingViewDelegate <NSObject>

- (void)softwareSettingView:(SoftwareSettingView *)view didClickedWithViewTag:(SoftwareSettingViewTag)tag;

- (void)softwareSettingView:(SoftwareSettingView *)view didClickedSegueButtonWithSysNo:(NSString *)number;

@end

@interface SoftwareSettingView : UIView

@property (nonatomic, assign) id<SoftwareSettingViewDataSource> dataSource;

@property (nonatomic, assign) id<SoftwareSettingViewDelegate> delegate;

- (void)reloadData;

@end
