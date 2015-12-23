//
//  HomeEventItem.m
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeEventItem.h"

@interface HomeEventItem ()

@end

@implementation HomeEventItem

- (instancetype)initWithHomeData:(NSDictionary *)data {
    self = [super initWithHomeData:data];
    if (self) {
        
    }
    return self;
}



- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    //促销语
    self.promotionWords = [data objectForKey:@"promotion"];
    
    //展示的商品
    self.showingProducts = [data objectForKey:@"products"];
    
    //徽章图标名称
    NSString *badgeTag = [data objectForKey:@"tag"];
    self.badgeImageName = [badgeTag substringFromIndex:[badgeTag rangeOfString:@"local://"].length];
    
    if (self.showingProducts && [self.showingProducts count] > 0) {
        //原价
        self.price = [[self.showingProducts objectAtIndex:0] objectForKey:@"info"];
        
        //促销价
        self.promotePrice = [[self.showingProducts objectAtIndex:0] objectForKey:@"msg"];
        //图片
        NSString *productCharId = [[self.showingProducts objectAtIndex:0] objectForKey:@"charId"];
        self.pictureUrlString = [GToolUtil getProductPic:productCharId  type: @"mpic" index: 0];
    }
}


@end
