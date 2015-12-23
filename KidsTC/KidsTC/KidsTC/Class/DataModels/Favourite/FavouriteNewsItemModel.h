//
//  FavouriteNewsItemModel.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavouriteNewsItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *authorName;

@property (nonatomic, copy) NSString *linkUrlString;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
