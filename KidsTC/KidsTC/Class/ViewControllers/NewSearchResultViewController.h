//
//  NewSearchResultViewController.h
//  KidsTC
//
//  Created by Altair on 12/2/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"

@interface NewSearchResultViewController : GViewController

@property (nonatomic, strong) KTCSearchNewsCondition *searchCondition;

@property (nonatomic, assign) BOOL needRefresh;

- (instancetype)initWithSearchCondition:(KTCSearchNewsCondition *)condition;

@end
