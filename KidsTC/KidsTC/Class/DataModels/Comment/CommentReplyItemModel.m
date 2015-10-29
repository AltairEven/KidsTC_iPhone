//
//  CommentReplyItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentReplyItemModel.h"

@implementation CommentReplyItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.faceImageUrl = [NSURL URLWithString:[data objectForKey:@"face"]];
        self.userName = [data objectForKey:@"user"];
        self.replyContent = [data objectForKey:@"content"];
        self.timeDescription = [data objectForKey:@"time"];
        self.userName = @"小河马";
        self.replyContent = @"小河马爱洗澡，萌萌哒满地跑";
        self.timeDescription = @"2015-10-30";
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.replyContent];
    height += 40;
    if (height < 80) {
        height = 80;
    }
    
    return height;
}

@end
