//
//  KTCAgeScope.h
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTCAgeScope : NSObject

@property (nonatomic, strong) NSArray *ageItems;

+ (instancetype)sharedAgeScope;

- (void)setAgeItemsWithRawDataArray:(NSArray *)dataArray;

@end



@interface KTCAgeItem : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *identifier;

@end