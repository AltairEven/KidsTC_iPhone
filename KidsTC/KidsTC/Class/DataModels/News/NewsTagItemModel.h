//
//  NewsTagItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/15/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsTagItemModel;
@class NewsTagTypeModelMetaData;

@interface NewsTagTypeModel : NSObject

@property (nonatomic, assign) NSUInteger type;

@property (nonatomic, copy) NSString *typeDescription;

@property (nonatomic, strong) NSArray<NewsTagItemModel *> *tagItems;

@property (nonatomic, strong) NewsTagTypeModelMetaData *metaData;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end

@interface NewsTagItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL isHot;

@property (nonatomic, assign) NSUInteger type;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (KTCUserRole *)relatedUserRole;

@end

@interface NewsTagTypeModelMetaData : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *mainTitle;

@property (nonatomic, copy) NSString *subTitle;

@end