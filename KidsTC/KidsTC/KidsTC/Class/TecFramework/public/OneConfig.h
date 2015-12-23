//
//  OneConfig.h
//  iPhone51Buy
//
//  Created by alex tao on 2/18/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneConfig : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong)   NSString *              name;
@property (nonatomic, strong)   NSDate *                expireDate;
@property (nonatomic, strong)   NSDate *                latestDate;
@property (nonatomic, strong)   NSMutableDictionary *   configDict;

- (id) initWithName:(NSString*)name andConfig:(NSMutableDictionary*)config;

- (id) configForKey:(NSString*)key;

@end
