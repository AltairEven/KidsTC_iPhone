//
//  SaidanCommitView.h
//  ICSON
//
//  Created by 肖晓春 on 15/5/13.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SaiDanCommitViewDelegate <NSObject>
@optional
- (void)saiDanRule;
@end

@interface SaiDanCommitView : UIView
@property (nonatomic, assign) id<SaiDanCommitViewDelegate> delegate;

- (IBAction)saiDanRule:(id)sender;

@end
