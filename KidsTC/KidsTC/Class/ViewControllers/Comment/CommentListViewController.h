//
//  CommentListViewController.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListViewModel.h"

@interface CommentListViewController : GViewController

- (instancetype)initWithIdentifier:(NSString *)identifier relationType:(CommentRelationType)type commentNumberDic:(NSDictionary *)numberDic;

@end
