//
//  CommonShareViewController.h
//  KidsTC
//
//  Created by Altair on 11/20/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonShareObject.h"
#import "KTCShareService.h"

@interface CommonShareViewController : UIViewController

@property (nonatomic, strong, readonly) CommonShareObject *shareObject;

@property (nonatomic, readonly) KTCShareServiceType sourceType;

+ (instancetype)instanceWithShareObject:(CommonShareObject *)object;

+ (instancetype)instanceWithShareObject:(CommonShareObject *)object sourceType:(KTCShareServiceType)type;

@end
