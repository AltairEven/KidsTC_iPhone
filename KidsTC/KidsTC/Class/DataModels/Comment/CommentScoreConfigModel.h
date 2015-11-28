//
//  CommentScoreConfigModel.h
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentScoreItem;

@interface CommentScoreConfigModel : NSObject

@property (nonatomic, readonly) BOOL needShowScore;

@property (nonatomic, strong, readonly) CommentScoreItem *totalScoreItem;

@property (nonatomic, strong, readonly) NSArray<CommentScoreItem *> *otherScoreItems;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (NSArray<CommentScoreItem *> *)allShowingScoreItems;

@end

@interface CommentScoreItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) NSUInteger score;

+ (instancetype)scoreItemWithTitle:(NSString *)title andKey:(NSString *)key;

@end