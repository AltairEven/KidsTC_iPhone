//
//  BigAdvertisementViewController.h
//  KidsTC
//
//  Created by Altair on 12/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTCAdvertisementItem.h"

typedef void(^ BigAdShowingCompleted)(HomeSegueModel *segueModel);

@interface BigAdvertisementViewController : UIViewController

@property (nonatomic, strong) BigAdShowingCompleted completionBlock;

- (instancetype)initWithAdvertisementItems:(NSArray<KTCAdvertisementItem *> *)adItems;

@end
