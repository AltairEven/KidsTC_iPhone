//
//  GCommonFilterAttr.h
//  iphone51buy
//
//  Created by CGS on 12-5-24.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCommonFilterAttr : NSObject<NSCopying,NSCoding>

@property (nonatomic) NSInteger attrId;
@property (strong, nonatomic) NSString *attrName;
@property (strong, nonatomic) NSArray *optionList;

-(id)initWithAttrId:(NSInteger)_attrId attrName:(NSString *) _attrName;
-(id)initWithAttrId:(NSInteger)_attrId attrName:(NSString *) _attrName optionList:(NSArray *)_optionList;
@end
