//
//  KTCArea.h
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTCAreaItem;

@interface KTCArea : NSObject

@property (nonatomic, strong, readonly) NSArray *areaItems;

@property (nonatomic, strong, readonly) NSArray *areaNames;

+ (instancetype)area;

- (void)synchronizeArea;

- (NSInteger)indexOfAreaIdentifier:(NSString *)identifier;

- (NSInteger)indexOfAreaItem:(KTCAreaItem *)item;

@end


@interface KTCAreaItem : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *identifier;

@end