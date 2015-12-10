//
//  ServiceDetailModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailModel.h"

@interface ServiceDetailModel ()

@property (nonatomic, assign) CGFloat noticeHeight;

@end

@implementation ServiceDetailModel

- (void)fillWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"chId"]];
    self.type = [[data objectForKey:@"productType"] integerValue];
    NSArray *imageUrlStrings = [data objectForKey:@"imgUrl"];
    if ([imageUrlStrings isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSString *urlString in imageUrlStrings) {
            NSURL *url = [NSURL URLWithString:urlString];
            if (url) {
                [tempArray addObject:url];
            }
        }
        self.imageUrls = [NSArray arrayWithArray:tempArray];
    }
    
    self.serviceName = [data objectForKey:@"serveName"];
    self.starNumber = [[data objectForKey:@"level"] floatValue];
    self.commentsNumber = [[data objectForKey:@"evaluate"] integerValue];
    self.saleCount = [[data objectForKey:@"saleCount"] integerValue];
    self.price = [[data objectForKey:@"price"] floatValue];
    self.priceDescription = [data objectForKey:@"priceSortName"];
    NSArray *coupons = [data objectForKey:@"coupons"];
    if ([coupons isKindOfClass:[NSArray class]] && [coupons count] > 0) {
        self.couponName = [coupons firstObject];
    }
    self.couponUrlString = [data objectForKey:@"couponLink"];
    self.countdownTime = [[data objectForKey:@"remainCount"] integerValue];
    self.showCountdown = [[data objectForKey:@"showCountDown"] integerValue];
    self.supportedInsurances = [Insurance InsurancesWithRawData:[data objectForKey:@"insurance"]];
    
    NSArray *array = [data objectForKey:@"buyNotice"];
    self.noticeHeight = 0;
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *singleEle in array) {
            ServiceDetailNoticeItem *item = [[ServiceDetailNoticeItem alloc] initWithRawData:singleEle];
            if (item) {
                [tempArray addObject:item];
                self.noticeHeight += [item itemHeight] + 10;
            }
        }
        self.noticeArray = [NSArray arrayWithArray:tempArray];
    }
    
    NSDictionary *recommendDic = [data objectForKey:@"note"];
    if ([recommendDic isKindOfClass:[NSDictionary class]] && [recommendDic count] > 0) {
        self.recommenderFaceImageUrl = [NSURL URLWithString:[recommendDic objectForKey:@"imgUrl"]];
        self.recommenderName = [recommendDic objectForKey:@"name"];
        self.recommendString = [recommendDic objectForKey:@"note"];
    }
    
    self.introductionUrlString = [data objectForKey:@"detailUrl"];
    
    self.isFavourate = [[data objectForKey:@"isFavor"] boolValue];
    self.phoneNumber = [data objectForKey:@"phone"];
    
    self.stockNumber = [[data objectForKey:@"remainCount"] integerValue];
    self.maxLimit = [[data objectForKey:@"buyMaxNum"] integerValue];
    self.minLimit = [[data objectForKey:@"buyMinNum"] integerValue];
    
    NSArray *storesArray = [data objectForKey:@"store"];
    if ([storesArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *singleDic in storesArray) {
            StoreListItemModel *item = [[StoreListItemModel alloc] initWithRawData:singleDic];
            [tempArray addObject:item];
        }
        self.storeItemsArray = [NSArray arrayWithArray:tempArray];
    }
    
    
    NSArray *commentsArray = [data objectForKey:@"commentList"];
    if ([commentsArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *singleDic in commentsArray) {
            CommentListItemModel *item = [[CommentListItemModel alloc] initWithRawData:singleDic];
            [tempArray addObject:item];
        }
        self.commentItemsArray = [NSArray arrayWithArray:tempArray];
    }
    
    
    NSDictionary *commentDic = [data objectForKey:@"comment"];
    if ([commentDic isKindOfClass:[NSDictionary class]] && [commentDic count] > 0) {
        self.commentAllNumber = [[commentDic objectForKey:@"all"] integerValue];
        self.commentGoodNumber = [[commentDic objectForKey:@"good"] integerValue];
        self.commentNormalNumber = [[commentDic objectForKey:@"normal"] integerValue];
        self.commentBadNumber = [[commentDic objectForKey:@"bad"] integerValue];
        self.commentPictureNumber = [[commentDic objectForKey:@"pic"] integerValue];
    }
    
    self.shareObject = [CommonShareObject shareObjectWithRawData:[data objectForKey:@"share"]];
    if (self.shareObject) {
        self.shareObject.identifier = self.serviceId;
        self.shareObject.followingContent = @"【童成】";
    }
}


- (CGFloat)topCellHeight {
    //image
    CGFloat height = SCREEN_WIDTH * 1;
    //service name
    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:17] topGap:10 bottomGap:10 maxLine:2 andText:self.serviceName];
    //service description
    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:3 andText:self.serviceDescription];
    
    return height;
}

- (CGFloat)priceCellHeight {
    return 40;
}

- (CGFloat)insuranceCellHeight {
    return 30;
}

- (CGFloat)couponCellHeight {
    return 40;
}

- (CGFloat)noticeTitleCellHeight {
    return 40;
}

- (CGFloat)noticeCellHeight {
    return self.noticeHeight;
}

- (CGFloat)recommendCellHeight {
    CGFloat height = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.recommendString];
    if (height < 80) {
        height = 80;
    }
    
    return height;
}

- (BOOL)hasCoupon {
    return ([self.couponName length] > 0);
}

@end

@implementation ServiceDetailNoticeItem

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.title = [NSString stringWithFormat:@"%@：", [data objectForKey:@"clause"]];
        self.content = [data objectForKey:@"notice"];
    }
    return self;
}

- (CGFloat)itemHeight {
    CGFloat wordWidth = 13;
    CGFloat margin = 10;
    CGFloat height = 0;
    CGFloat labelWidth = SCREEN_WIDTH - margin * 2 - ([self.title length] + 1) * wordWidth;
    if (labelWidth < 100) {
        height += wordWidth + margin;
    }
    
    height += [GConfig heightForLabelWithWidth:labelWidth LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:wordWidth] topGap:10 bottomGap:10 andText:self.content];
    
    return height;
}

@end
