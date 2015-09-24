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

@interface CommentListViewModel : BaseViewModel

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) KTCCommentObject commentObject;

- (void)startUpdateDataWithType:(KTCCommentType)type;

- (void)getMoreDataWithType:(KTCCommentType)type;

- (void)resetResultWithType:(KTCCommentType)type;

- (NSArray *)resultOfCurrentType;

@end
