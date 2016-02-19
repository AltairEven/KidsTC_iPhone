//
//  SettlementScoreEditViewController.h
//  KidsTC
//
//  Created by Altair on 2/16/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ SettlementScoreDismissBlock)(NSUInteger usedScore);


@interface SettlementScoreEditViewController : UIViewController

@property (nonatomic, assign) NSUInteger totalScore;

@property (nonatomic, assign) NSUInteger usedScore;

@property (nonatomic, copy) SettlementScoreDismissBlock dismissBlock;

+ (instancetype)alertInstance;

@end
