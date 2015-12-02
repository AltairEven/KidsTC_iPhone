//
//  MyCommentListItemModel.h
//  KidsTC
//
//  Created by Altair on 12/1/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTCCommentManager.h"
#import "CommentScoreConfigModel.h"

@interface MyCommentListItemModel : NSObject

@property (nonatomic, copy) NSString *relationIdentifier;

@property (nonatomic, copy) NSString *commentIdentifier;

@property (nonatomic, assign) CommentRelationType relationType;

@property (nonatomic, copy) NSString *strategyIdentifier;

@property (nonatomic, copy) NSString *commentTime;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *linkUrl;

@property (nonatomic, strong) CommentScoreConfigModel *scoreConfigModel;

@property (nonatomic, copy) NSString *comments;

@property (nonatomic, copy) NSArray *originalPhotoUrlStringsArray; //原始图片url数组

@property (nonatomic, copy) NSArray *thumbnailPhotoUrlStringsArray; //缩略图片url数组

@property (nonatomic, copy) NSArray *photosArray; //MWPhoto

@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, assign) BOOL canDelete;

- (CGFloat)cellHeight;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (UIImage *)bizIcon;

@end
