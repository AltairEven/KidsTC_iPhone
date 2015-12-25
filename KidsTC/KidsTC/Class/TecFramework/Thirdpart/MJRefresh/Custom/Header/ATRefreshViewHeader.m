//
//  ATRefreshViewHeader.m
//  ICSON
//
//  Created by 钱烨 on 4/23/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "ATRefreshViewHeader.h"
#import "HeaderRefreshView.h"
#import "UIView+MJExtension.h"

@interface ATRefreshViewHeader ()

@property (nonatomic, strong)  HeaderRefreshView *refreshView;

@end

@implementation ATRefreshViewHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pullingPercent = 2;
        self.refreshView = [[HeaderRefreshView alloc] init];
        [self.refreshView setDuration:0.5];
        [self addSubview:self.refreshView];
    }
    return self;
}


- (void)layoutSubviews {
    self.mj_h = self.refreshView.frame.size.height;
    [super layoutSubviews];
}

- (void)setState:(MJRefreshState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshState oldState = self.state;
    
    switch (state) {
        case MJRefreshStateIdle: {
            if (oldState == MJRefreshStateRefreshing) {
                [self.refreshView stopAnimation];
            }
            break;
        }
            
        case MJRefreshStatePulling: {
            break;
        }
            
        case MJRefreshStateRefreshing: {
            [self.refreshView startAnimation];
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)beginRefreshing {
    [super beginRefreshing];
    [self.refreshView startAnimation];
}



- (void)endRefreshing {
    [super endRefreshing];
    [self.refreshView stopAnimation];
}


@end
