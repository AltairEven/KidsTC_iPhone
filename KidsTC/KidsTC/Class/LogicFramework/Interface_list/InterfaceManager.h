//
//  InterfaceManager.h
//  KidsTC
//
//  Created by 钱烨 on 8/4/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterfaceManager : NSObject

@property (nonatomic, strong, readonly) NSDictionary *interfaceData;

+ (instancetype)sharedManager;

- (void)updateInterface;

@end
