//
//  CommentReplyItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentReplyItemModel : NSObject

@property (nonatomic, strong) NSURL *faceImageUrl;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *replyContent;

@property (nonatomic, copy) NSString *timeDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end
