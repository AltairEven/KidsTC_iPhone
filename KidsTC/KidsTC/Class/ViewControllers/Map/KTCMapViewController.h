//
//  KTCMapViewController.h
//  KidsTC
//
//  Created by 钱烨 on 8/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"
#import <BaiduMapAPI/BMapKit.h>

typedef enum {
    KTCMapTypeLocate,
    KTCMapTypeStoreGuide
}KTCMapType;

@interface KTCMapViewController : GViewController

- (instancetype)initWithMapType:(KTCMapType)type destination:(KTCLocation *)destination;

@end
