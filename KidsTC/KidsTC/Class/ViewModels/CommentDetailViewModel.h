//
//  CommentDetailViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/29/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "CommentDetailView.h"

@interface CommentDetailViewModel : BaseViewModel

@property (nonatomic, strong) CommentDetailModel *detailModel;

-(void)getMoreReplies;

@end
