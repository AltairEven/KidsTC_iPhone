//
//  SaiDanAndCommentView.h
//  ICSON
//
//  Created by 肖晓春 on 15/5/13.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiDanOrderView.h"
#import "SaiDanCommentView.h"
#import "SaiDanPhotoView.h"
#import "SaiDanCommitView.h"
@interface SaiDanAndCommentView : UIScrollView
@property (strong, nonatomic) IBOutlet SaiDanPhotoView *saiDanPhotoView;
@property (strong, nonatomic) IBOutlet SaiDanOrderView *saiDanOrderView;
@property (strong, nonatomic) IBOutlet SaiDanCommentView *saiDanCommentView;
@property (strong, nonatomic) IBOutlet SaiDanCommitView *saiDancomitView;

- (void)refresh : (NSDictionary *)dicInfo;
- (void)reloadData;
@end
