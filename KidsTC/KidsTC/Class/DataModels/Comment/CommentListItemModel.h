//
//  CommentListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentListItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *relationIdentifier;

@property (nonatomic, strong) NSURL *faceImageUrl;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userLevelDescription;

@property (nonatomic, copy) NSString *commentTime;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, copy) NSString *comments;

@property (nonatomic, copy) NSArray *originalPhotoUrlStringsArray; //图片url数组

@property (nonatomic, copy) NSArray *thumbnailPhotoUrlStringsArray; //图片url数组

@property (nonatomic, copy) NSArray *photosArray; //MWPhoto

@property (nonatomic, assign) BOOL isLiked;

@property (nonatomic, assign) NSUInteger likeNumber;

@property (nonatomic, assign) NSUInteger replyNumber;

- (CGFloat)cellHeight;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)storeDetailCellHeight;

@end
