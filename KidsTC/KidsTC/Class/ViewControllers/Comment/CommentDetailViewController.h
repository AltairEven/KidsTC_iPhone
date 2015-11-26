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

@property (nonatomic, readonly) CommentDetailSource viewSource;

- (instancetype)initWithSource:(CommentDetailSource)source headerModel:(id)model;

- (instancetype)initWithSource:(CommentDetailSource)source identifier:(NSString *)identifier;

@end
