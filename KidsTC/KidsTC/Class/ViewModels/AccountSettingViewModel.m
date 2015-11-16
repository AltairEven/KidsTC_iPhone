//
//  AccountSettingViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "AccountSettingViewModel.h"

@interface AccountSettingViewModel () <AccountSettingViewDataSource>

@property (nonatomic, weak) AccountSettingView *view;

@end

@implementation AccountSettingViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (AccountSettingView *)view;
        self.view.dataSource = self;
    }
    return self;
}

#pragma mark SoftwareSettingViewDataSource

- (AccountSettingModel *)modelForAccountSettingView:(AccountSettingView *)view {
    return self.settingModel;
}

#pragma mark Super methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    [self.view reloadData];
}

- (void)stopUpdateData {
    
}

#pragma mark Public methods

- (void)resetFaceImage:(UIImage *)image {
    self.settingModel.faceImage = image;
    [self.view reloadData];
}

@end
