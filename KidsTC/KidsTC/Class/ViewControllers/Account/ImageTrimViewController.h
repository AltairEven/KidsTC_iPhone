//
//  ImageTrimViewController.h
//  KidsTC
//
//  Created by Altair on 11/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"

@class ImageTrimViewController;

@protocol ImageTrimViewControllerDelegate <NSObject>

- (void)imageTrimViewController:(ImageTrimViewController *)controller didFinishedTrimmingWithNewImage:(UIImage *)image;

@end

@interface ImageTrimViewController : GViewController

@property (nonatomic, weak) id<ImageTrimViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image targetSize:(CGSize)size;

@end
