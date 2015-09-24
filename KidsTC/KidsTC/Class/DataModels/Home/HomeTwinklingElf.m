//
//  HomeTwinklingElf.m
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeTwinklingElf.h"

@interface HomeTwinklingElf ()



@end

@implementation HomeTwinklingElf
@synthesize hasLocalImage = _hasLocalImage;

- (instancetype)initWithHomeData:(NSDictionary *)data {
    self = [super initWithHomeData:data];
    if (self) {
        
    }
    return self;
}


- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    //标题
    self.title = [data objectForKey:@"title"];
    
    //本地图片
    NSString *picUrl = [data objectForKey:@"imgUrl"];
    if ([picUrl hasPrefix:@"local://"]) {
        self.imageName = [picUrl substringFromIndex:[picUrl rangeOfString:@"local://"].length];
    }
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    if ([imageName length] > 0) {
        _hasLocalImage = YES;
    } else {
        _hasLocalImage = NO;
    }
}

@end
