//
//  CommentScoreConfigModel.m
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentScoreConfigModel.h"

@implementation CommentScoreConfigModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _needShowScore = [[data objectForKey:@"isNeedScore"] boolValue];
        if (self.needShowScore) {
            _totalScoreItem = [CommentScoreItem scoreItemWithTitle:@"总体评价" andKey:@"total"];
        }
        NSArray *othrerScoreArray = [data objectForKey:@"types"];
        if ([othrerScoreArray isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *singleElem in othrerScoreArray) {
                NSString *title = [singleElem objectForKey:@"name"];
                NSString *key = [singleElem objectForKey:@"key"];
                CommentScoreItem *scoreItem = [CommentScoreItem scoreItemWithTitle:title andKey:key];
                if (scoreItem) {
                    [tempArray addObject:scoreItem];
                }
            }
            _otherScoreItems = [NSArray arrayWithArray:tempArray];
        }
    }
    return self;
}

- (NSArray<CommentScoreItem *> *)allShowingScoreItems {
    if (!self.needShowScore) {
        return nil;
    }
    NSMutableArray *showingArray = [[NSMutableArray alloc] init];
    if ([self.otherScoreItems count] > 0) {
        [showingArray addObjectsFromArray:self.otherScoreItems];
    }
    [showingArray addObject:self.totalScoreItem];
    
    return [NSArray arrayWithArray:showingArray];
}

@end




@implementation CommentScoreItem

+ (instancetype)scoreItemWithTitle:(NSString *)title andKey:(NSString *)key {
    if (!title || ![title isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (!key || ![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    CommentScoreItem *item = [[CommentScoreItem alloc] init];
    item.title = title;
    item.key = key;
    return item;
}

@end