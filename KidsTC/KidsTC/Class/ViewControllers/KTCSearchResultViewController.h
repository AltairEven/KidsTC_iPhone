//
//  KTCSearchResultViewController.h
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTCSearchResultViewController : GViewController

@property (nonatomic, strong) KTCSearchCondition *searchCondition;

@property (nonatomic, assign) KTCSearchType searchType;

@property (nonatomic, assign) BOOL needRefresh;

- (instancetype)initWithSearchType:(KTCSearchType)type condition:(KTCSearchCondition *)condition;

@end
