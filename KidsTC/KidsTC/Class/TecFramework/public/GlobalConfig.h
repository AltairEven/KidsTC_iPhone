//
//  GlobalConfig.h
//  iPhone51Buy
//
//  Created by alex tao on 2/18/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONF_STR(key, subkey)          [[GlobalConfig sharedInstance] configForKey:(key) andSubkey:(subkey)]
#define CONF_INT(key, subkey)          [[[GlobalConfig sharedInstance] configForKey:(key) andSubkey:(subkey)] integerValue]


@interface GlobalConfig : NSObject

@property (nonatomic, strong)   NSMutableDictionary *   allConfig;

+ (GlobalConfig*) sharedInstance;

- (id) configForKey:(NSString*)key andSubkey:(NSString*)subkey;



@end
