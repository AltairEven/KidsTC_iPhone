//
//  SoftwareSettingModel.h
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoftwareSettingModel : NSObject

@property (nonatomic, assign) NSUInteger cacheLength;

@property (nonatomic, copy) NSString *version;

- (NSString *)cacheLengthDescription;

@end
