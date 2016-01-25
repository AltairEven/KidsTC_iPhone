//
//  KTCEmptyDataView.h
//  KidsTC
//
//  Created by Altair on 12/5/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTCEmptyDataView;

@protocol KTCEmptyDataViewDelegate <NSObject>

- (void)didClickedGoHomeButtonOnEmptyView:(KTCEmptyDataView *)emptyView;

@end

@interface KTCEmptyDataView : UIView

@property (nonatomic, assign) id<KTCEmptyDataViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img description:(NSString *)des;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img description:(NSString *)des needGoHome:(BOOL)bNeed;

@end
