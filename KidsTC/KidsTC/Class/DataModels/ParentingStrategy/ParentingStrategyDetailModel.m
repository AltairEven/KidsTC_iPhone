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
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.tagNames = [data objectForKey:@"flag"];
    NSDictionary *infoDic = [data objectForKey:@"info"];
    if ([infoDic isKindOfClass:[NSDictionary class]]) {
        self.isFavourite = [[infoDic objectForKey:@"isCollect"] boolValue];
//        self.mainImageUrl = [NSURL URLWithString:[infoDic objectForKey:@"image"]];
        NSArray *array = [infoDic objectForKey:@"image"];
        self.mainImageUrl = [NSURL URLWithString:[array lastObject]];
        self.title = [infoDic objectForKey:@"title"];
        self.authorName = [infoDic objectForKey:@"authorName"];
        self.strategyDescription = [infoDic objectForKey:@"simply"];
        self.shareObject = [CommonShareObject shareObjectWithRawData:[infoDic objectForKey:@"share"]];
        if (self.shareObject) {
            self.shareObject.identifier = self.identifier;
            self.shareObject.followingContent = @"【童成】";
        }
    }
    NSArray *cellDataArray = [data objectForKey:@"items"];
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
        }
        height = yPosition + titleHeight + topMargin;
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
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.title = [data objectForKey:@"title"];
//        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"image"]];
        NSArray *array = [data objectForKey:@"image"];
        self.imageUrl = [NSURL URLWithString:[array lastObject]];
        self.cellContentString = [data objectForKey:@"desc"];
        self.timeDescription = [data objectForKey:@"time"];
        
        CLLocationCoordinate2D coordinate = [GToolUtil coordinateFromString:[data objectForKey:@"mapAddress"]];
        NSString *address = [data objectForKey:@"address"];
        if (CLLocationCoordinate2DIsValid(coordinate)) {
            self.location = [[KTCLocation alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] locationDescription:address];
        }
        
        HomeSegueDestination dest = (HomeSegueDestination)[[data objectForKey:@"linkType"] integerValue];
        self.relatedInfoModel = [[HomeSegueModel alloc] initWithDestination:dest paramRawData:[data objectForKey:@"params"]];
        self.relatedInfoTitle = [data objectForKey:@"linkTitle"];
        self.commentCount = [[data objectForKey:@"commentCount"] integerValue];
        
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