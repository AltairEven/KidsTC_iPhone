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
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.faceImageUrl = [NSURL URLWithString:[data objectForKey:@"userImgUrl"]];
        self.userName = [data objectForKey:@"userName"];
        self.replyContent = [data objectForKey:@"content"];
        self.timeDescription = [data objectForKey:@"time"];
        self.replyCount = [[data objectForKey:@"replyCount"] integerValue];
        self.isLiked = [[data objectForKey:@"isPrasise"] boolValue];
        self.likeCount = [[data objectForKey:@"praiseCount"] integerValue];
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
