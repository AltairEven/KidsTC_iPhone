//
//  NewsListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NewsTypeNews = 1,
    NewsTypeTopic
}NewsType;

@interface NewsListItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) NewsType type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *linkUrl;

@property (nonatomic, assign) NSUInteger viewCount;

@property (nonatomic, assign) NSUInteger commentCount;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
