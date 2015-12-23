//
//  TiledImageView.h
//  iphone
//
//  Created by icson apple on 12-3-31.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiledImageView : UIView {
@private
    UIImage *image_;
}
- (id)initWithFrame:(CGRect)frame tiledImage:(UIImage *)_image;
@end

