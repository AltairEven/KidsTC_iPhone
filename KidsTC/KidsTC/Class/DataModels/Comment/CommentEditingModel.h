//
//  CommentEditingModel.h
//  KidsTC
//
//  Created by Altair on 12/2/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTCCommentManager.h"
#import "CommentScoreConfigModel.h"
#import "MyCommentListItemModel.h"

@interface CommentEditingModel : NSObject

@property (nonatomic, copy) NSString *relationIdentifier;

@property (nonatomic, copy) NSString *commentIdentifier;

@property (nonatomic, copy) NSString *strategyIdentifier;

@property (nonatomic, copy) NSString *linkUrl;

@property (nonatomic, assign) CommentRelationType relationType;

@property (nonatomic, copy) NSString *objectName;

@property (nonatomic, copy) NSString *commentText;

@property (nonatomic, strong) NSArray *uploadPhotoLocationStrings;

@property (nonatomic, strong) CommentScoreConfigModel *scoreConfigModel;

@property (nonatomic, assign) BOOL needHideName;

@property (nonatomic, copy) NSArray *originalPhotoUrlStringsArray; //原始图片url数组

@property (nonatomic, copy) NSArray *thumbnailPhotoUrlStringsArray; //缩略图片url数组

@property (nonatomic, strong)  NSArray *combinedImagesArray;

@property (nonatomic, copy) NSArray *photosArray; //MWPhoto

@property (nonatomic, assign) BOOL showPhotoGrid;

+ (instancetype)modelFromItem:(MyCommentListItemModel *)item;

- (NSArray *)remoteImageUrlStrings;

@end
