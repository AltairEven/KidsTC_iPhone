//
//  ServiceMoreDetailView.h
//  KidsTC
//
//  Created by 钱烨 on 7/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceMoreDetailView;

@protocol ServiceMoreDetailViewDelegate <NSObject>

- (void)didPulledAtHeaderOnServiceMoreDetailView:(ServiceMoreDetailView *)moreDetailView;

@end

@interface ServiceMoreDetailView : UIView

@property (nonatomic, assign) id<ServiceMoreDetailViewDelegate> delegate;
@property (nonatomic, assign) BOOL supportStairsController;

@property (nonatomic, copy) NSString *htmlString;

@end