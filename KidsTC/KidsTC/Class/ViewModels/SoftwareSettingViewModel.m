//
//  SoftwareSettingViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "SoftwareSettingViewModel.h"

@interface SoftwareSettingViewModel () <SoftwareSettingViewDataSource>

@property (nonatomic, weak) SoftwareSettingView *view;

@end

@implementation SoftwareSettingViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (SoftwareSettingView *)view;
        self.view.dataSource = self;
        self.settingModel = [[SoftwareSettingModel alloc] init];
    }
    return self;
}

#pragma mark SoftwareSettingViewDataSource

- (SoftwareSettingModel *)modelForSoftwareSettingView:(SoftwareSettingView *)view {
    return self.settingModel;
}

#pragma mark Super methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    self.settingModel.cacheLength = [UIImageView getCacheLength];
    self.settingModel.version = [NSString stringWithFormat:@"v%@", [GConfig getCurrentAppVersionCode]];
    [self.view reloadData];
}

- (void)stopUpdateData {
    
}

@end
