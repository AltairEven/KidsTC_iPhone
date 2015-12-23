//
//  BaseViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/4/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SucceedBlock)(NSDictionary *data);
typedef void(^FailureBlock)(NSError *error);

@interface BaseViewModel : NSObject

@property (nonatomic, strong) SucceedBlock refreshSucceedBlock;

@property (nonatomic, strong) failureDlBlock refreshFailedBlock;

@property (nonatomic, strong) NetworkErrorBlcok netErrorBlock;

- (instancetype)initWithView:(UIView *)view;

- (void)startUpdateDataWithSucceed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

- (void)stopUpdateData;

@end
