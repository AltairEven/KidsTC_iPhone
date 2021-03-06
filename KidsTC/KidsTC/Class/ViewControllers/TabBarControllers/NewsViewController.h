//
//  NewsViewController.h
//  KidsTC
//
//  Created by 钱烨 on 9/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"
#import "NewsViewModel.h"

@interface NewsViewController : GViewController

- (void)setSelectedTagType:(NSUInteger)type andTagId:(NSString *)tagId;

- (void)setSelectedViewTag:(NewsViewTag)viewTag;

@end
