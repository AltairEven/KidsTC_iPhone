//
//  CommentListViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "KTCCommentManager.h"
#import "CommentListView.h"

#define CommentListTabNumberKeyAll (@"CommentListTabNumberKeyAll")
#define CommentListTabNumberKeyGood (@"CommentListTabNumberKeyGood")
#define CommentListTabNumberKeyNormal (@"CommentListTabNumberKeyNormal")
#define CommentListTabNumberKeyBad (@"CommentListTabNumberKeyBad")
#define CommentListTabNumberKeyPicture (@"CommentListTabNumberKeyPicture")

@interface CommentListViewModel : BaseViewModel

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) CommentRelationType relationType;

@property (nonatomic, strong) NSDictionary *numbersDic;

- (void)startUpdateDataWithType:(KTCCommentType)type;

- (void)getMoreDataWithType:(KTCCommentType)type;

- (void)resetResultWithType:(KTCCommentType)type;

- (NSArray *)resultOfCurrentType;

@end
