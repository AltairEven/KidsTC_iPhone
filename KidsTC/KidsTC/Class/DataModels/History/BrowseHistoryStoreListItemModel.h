//
//  BrowseHistoryStoreListItemModel.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrowseHistoryStoreListItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *bizZone;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
