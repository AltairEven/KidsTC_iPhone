//
//  BaseViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/4/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (instancetype)initWithView:(UIView *)view {
    return [super init];
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    
}


- (void)stopUpdateData {
    
}

@end
