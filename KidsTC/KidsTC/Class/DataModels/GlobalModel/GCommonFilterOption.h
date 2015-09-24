//
//  GCommonFilterOption.h
//  iphone51buy
//
//  Created by CGS on 12-5-24.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCommonFilterOption : NSObject<NSCopying,NSCoding>

@property (nonatomic) NSInteger optionId;
@property (strong, nonatomic) NSString *optionName;
@property (nonatomic) BOOL selected;

-(id)initWithOptionId:(NSInteger)_optionId optionName:(NSString *) _optionName;
-(id)initWithOptionId:(NSInteger)_optionId optionName:(NSString *) _optionName selected:(BOOL)_selected;
@end

