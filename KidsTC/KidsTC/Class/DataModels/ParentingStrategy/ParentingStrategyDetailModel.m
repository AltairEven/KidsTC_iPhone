//
//  ParentingStrategyDetailModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailModel.h"

@implementation ParentingStrategyDetailModel

- (void)fillWithRawData:(NSDictionary *)data {
//    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//    self.isFavourite = [[data objectForKey:@"isFavor"] boolValue];
//    self.mainImageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
//    self.title = [data objectForKey:@"title"];
//    self.tagNames = [data objectForKey:@"tag"];
//    self.strategyDescription = [data objectForKey:@"desc"];
    
    self.isFavourite = NO;
    self.mainImageUrl = [NSURL URLWithString:@"http://img.sqkids.com:7500/v1/img/T1KtETBjVT1RCvBVdK.jpg"];
    self.title = @"亲子攻略标题";
    self.tagNames = [NSArray arrayWithObjects:@"小河马", @"小河马爱洗澡", @"河马妈妈", @"打屁", @"哈哈哈哈", @"满地跑", @"捣", nil];
    self.strategyDescription = @"小河马爱洗澡，萌萌哒满地跑，一不小心摔一跤，呜啊呜啊哭又闹。河马妈妈来看到，二话不说拿棍捣，小河马被打屁了，哈哈哈哈真搞笑。";
    NSArray *cellDataArray = [data objectForKey:@"step"];
    cellDataArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    if ([cellDataArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *cellData in cellDataArray) {
            ParentingStrategyDetailCellModel *model = [[ParentingStrategyDetailCellModel alloc] initWithRawData:cellData];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.cellModels = [NSArray arrayWithArray:tempArray];
    }
    self.mainImageRatio = 0.618;
}

- (CGFloat)mainImageHeight {
    return self.mainImageRatio * SCREEN_WIDTH;
}

- (CGFloat)titleHeight {
    return 50;
}

- (CGFloat)tagViewHeight {
    CGFloat leftMargin = 10;
    CGFloat rightMargin = 10;
    CGFloat cellHMargin = 10;
    CGFloat cellVMargin = 10;
    CGFloat topMargin = 10;
    CGFloat viewWidth = SCREEN_WIDTH - 80;
    
    CGFloat xPosition = leftMargin;
    CGFloat yPosition = topMargin;
    CGFloat height = 0;
    
    CGFloat fontSize = 15;
    CGFloat marginAdjustH = 10;
    CGFloat titleHeight = 20;
    
    for (NSUInteger index = 0; index < [self.tagNames count]; index ++) {
        NSString *title = [self.self.tagNames objectAtIndex:index];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setFrame:CGRectMake(xPosition, yPosition, 10, 10)];
//        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [button setTitle:title forState:UIControlStateNormal];
//        [button sizeToFit];
//        
//        //加点边距
//        [button setFrame:CGRectMake(xPosition, yPosition, button.frame.size.width + 10, 30)];
//        //下一个按钮位置调整
//        xPosition += button.frame.size.width + cellHMargin;
//        CGFloat rightM = button.frame.origin.x + button.frame.size.width;
//        CGFloat rightLimit = viewWidth - rightMargin;
//        if (rightM > rightLimit) {
//            xPosition = leftMargin;
//            yPosition += cellVMargin;
//            height = yPosition + 30 + topMargin;
//        }
        
        CGFloat titleWidth = fontSize * [title length] + marginAdjustH;
        if (index + 1 < [self.tagNames count]) {
            NSString *nextTitle = [self.tagNames objectAtIndex:index + 1];
            titleWidth = fontSize * [nextTitle length] + marginAdjustH;
            //下一个按钮位置调整
            xPosition += titleWidth + cellHMargin;
        } else {
            titleWidth = 0;
        }
        CGFloat rightM = xPosition + titleWidth;
        CGFloat rightLimit = viewWidth - rightMargin;
        if (rightM > rightLimit) {
            xPosition = leftMargin;
            yPosition += cellVMargin + titleHeight;
            height = yPosition + titleHeight + topMargin;
        }
    }
    
    return height;
}

- (CGFloat)strategyDescriptionViewHeight {
    CGFloat contentHeight = 0;
    if ([self.strategyDescription length] > 0) {
        contentHeight = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 80 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:14] topGap:10 bottomGap:10 andText:self.strategyDescription];
    }
    return contentHeight;
}

@end



@implementation ParentingStrategyDetailCellModel

- (instancetype)initWithRawData:(NSDictionary *)data {
//    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
//        return nil;
//    }
    self = [super init];
    if (self) {
//        self.title = [data objectForKey:@"title"];
//        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
//        self.cellContentString = [data objectForKey:@"content"];
//        self.timeDescription = [data objectForKey:@"time"];
//        self.coordinate = [GToolUtil coordinateFromString:[data objectForKey:@"mapAddr"]];
//        NSDictionary *relatedDic = [data objectForKey:@"serve"];
//        if ([relatedDic isKindOfClass:[NSDictionary class]]) {
//            HomeSegueDestination dest = (HomeSegueDestination)[[relatedDic objectForKey:@"type"] integerValue];
//            self.relatedInfoModel = [[HomeSegueModel alloc] initWithDestination:dest paramRawData:[relatedDic objectForKey:@"params"]];
//            self.relatedInfoTitle = [relatedDic objectForKey:@"title"];
//        }
//        self.commentCount = [[data objectForKey:@"commentCount"] integerValue];
        
        self.title = @"小河马爱洗澡，萌萌哒满地跑";
        self.imageUrl = [NSURL URLWithString:@"http://img.sqkids.com:7500/v1/img/T1KtETBjVT1RCvBVdK.jpg"];
        self.cellContentString = @"小河马爱洗澡，萌萌哒满地跑，一不小心摔一跤，呜啊呜啊哭又闹。河马妈妈来看到，二话不说拿棍捣，小河马被打屁了，哈哈哈哈真搞笑。";
        self.timeDescription = @"2015-10-16";
        self.coordinate = [GToolUtil coordinateFromString:@"34.50000,121.43333"];
        self.relatedInfoModel = [[HomeSegueModel alloc] initWithDestination:HomeSegueDestinationServiceDetail paramRawData:[NSDictionary dictionaryWithObject:@"1" forKey:@"1"]];
        self.relatedInfoTitle = @"河马之家";
        self.commentCount = 10086;
        self.ratio = 0.618;
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 40; //时间栏高度
    CGFloat cellWidth = SCREEN_WIDTH - 20;
    height += cellWidth * self.ratio; //图片
    height += [GConfig heightForLabelWithWidth:cellWidth - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:15] topGap:10 bottomGap:10 andText:self.cellContentString]; //内容
    return height + 3;
}

@end