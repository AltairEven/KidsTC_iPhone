//
//  CommentDetailViewController.h
//  KidsTC
//
//  Created by 钱烨 on 10/29/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"
#import "CommentDetailViewModel.h"

@interface CommentDetailViewController : GViewController

@property (nonatomic, assign) CommentDetailSource viewSource;

@property (nonatomic, assign) CommentRelationType relationType;

@property (nonatomic, copy) NSString *relationIdentifier;

@property (nonatomic, strong) NSString *commentIdentifier;

- (instancetype)initWithSource:(CommentDetailSource)source relationType:(CommentRelationType)type headerModel:(id)model;

@end
