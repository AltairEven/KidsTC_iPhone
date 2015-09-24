//
//  GConnectUselessView.h
//  iPhone51Buy
//
//  Created by chu gene on 1/15/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GConnectUselessViewDelegate;

@interface GConnectUselessView : UIView
@property (nonatomic, strong) UIImageView *signImage;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic)BOOL opaqueBG;
@property (nonatomic, weak) id<GConnectUselessViewDelegate> delegate;

@end

@protocol GConnectUselessViewDelegate <NSObject>

- (void)connectUselessViewTryReconnect:(GConnectUselessView *)aView;

@end