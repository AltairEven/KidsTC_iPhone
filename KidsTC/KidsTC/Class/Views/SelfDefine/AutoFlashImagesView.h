//
//  AutoFlashImagesView.h
//  ICSON
//
//  Created by 钱烨 on 4/9/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoFlashImagesView : UIView

@property (nonatomic, readonly) NSArray *imagesArray;

@property (nonatomic, assign) NSTimeInterval flashDuration;

@property (nonatomic, strong) NSArray *imageUrlsArray;

- (instancetype)initWithFrame:(CGRect)frame andImageUrlStrings:(NSArray *)urlStrings;

@end
