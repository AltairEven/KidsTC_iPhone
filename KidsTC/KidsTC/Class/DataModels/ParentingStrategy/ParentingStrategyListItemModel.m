//
//  ParentingStrategyListItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyListItemModel.h"

@implementation ParentingStrategyListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.title = [data objectForKey:@"title"];
        self.editorWord = [data objectForKey:@"editorWords"];
        self.isRecommend = [[data objectForKey:@"recommend"] boolValue];
        self.linkUrlString = [data objectForKey:@"url"];
        
        self.imageRatio = 0.4;
    }
    return self;
}


- (CGFloat)cellHeight {
    CGFloat height = 0;
    
    height += self.imageRatio * SCREEN_WIDTH;
    
    NSString *wholeString = [NSString stringWithFormat:@"小编推荐：%@", self.editorWord];
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 16)];
    [tempLabel setFont:[UIFont systemFontOfSize:13]];
    [tempLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [tempLabel setText:wholeString];
    height += [tempLabel sizeToFitWithMaximumNumberOfLines:2];
    height += 13;
    
    return height;
}

@end
