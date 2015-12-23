//
//  BigAdvertisementViewController.h
//  KidsTC
//
//  Created by Altair on 12/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ BigAdShowingCompleted)();

@interface BigAdvertisementViewController : UIViewController

@property (nonatomic, strong) BigAdShowingCompleted completionBlock;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images;

@end
