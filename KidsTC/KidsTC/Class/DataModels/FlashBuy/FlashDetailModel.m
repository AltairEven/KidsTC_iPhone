//
//  FlashDetailModel.m
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "FlashDetailModel.h"

@interface FlashDetailModel ()

@property (nonatomic, assign) CGFloat noticeHeight;

@end

@implementation FlashDetailModel

- (BOOL)fillWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return NO;
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
    NSArray *narrowimageUrlStrings = [data objectForKey:@"narrowImg"];
    if ([narrowimageUrlStrings isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSString *urlString in narrowimageUrlStrings) {
            NSURL *url = [NSURL URLWithString:urlString];
            if (url) {
                [tempArray addObject:url];
            }
        }
        self.narrowImageUrls = [NSArray arrayWithArray:tempArray];
    }
    self.imageRatio = [[data objectForKey:@"picRate"] floatValue];
    self.relationType = (CommentRelationType)[[data objectForKey:@"productType"] integerValue];
    
    self.serviceName = [data objectForKey:@"serveName"];
    self.serviceBriefName = [data objectForKey:@"simpleName"];
    if (![self.serviceBriefName isKindOfClass:[NSString class]] || [self.serviceBriefName length] == 0) {
        self.serviceBriefName = @"服务详情";
    }
    self.starNumber = [[data objectForKey:@"level"] floatValue];
    self.commentsNumber = [[data objectForKey:@"evaluate"] integerValue];
    self.saleCount = [[data objectForKey:@"saleCount"] integerValue];
    self.currentPrice = [[data objectForKey:@"price"] floatValue];
    self.originalPrice = [[data objectForKey:@"originalPrice"] floatValue];
    self.priceDescription = [data objectForKey:@"priceSortName"];
    if ([self.priceDescription length] > 0) {
        self.priceDescription = [NSString stringWithFormat:@"%@: ", self.priceDescription];
    }
    self.serviceContent = [data objectForKey:@"content"];
    if (![self.serviceContent isKindOfClass:[NSString class]]) {
        self.serviceContent = @"";
    }

    
    self.countdownTime = [[data objectForKey:@"countDownTime"] integerValue];
    self.showCountdown = [[data objectForKey:@"showCountDown"] integerValue];
    
    NSArray *array = [data objectForKey:@"buyNotice"];
    self.noticeHeight = 0;
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *singleEle in array) {
            ServiceDetailNoticeItem *item = [[ServiceDetailNoticeItem alloc] initWithRawData:singleEle];
            if (item) {
                [tempArray addObject:item];
                self.noticeHeight += [item itemHeight];
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
    
    self.serviceDescription = [data objectForKey:@"promote"];
    if (!self.serviceDescription) {
        self.serviceDescription = @"";
    }
    NSArray *promotionLinks = [data objectForKey:@"promotionLink"];
    if ([promotionLinks isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *rawData in promotionLinks) {
            TextSegueModel *model = [[TextSegueModel alloc] initWithLinkParam:rawData promotionWords:self.serviceDescription];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.promotionSegueModels = [NSArray arrayWithArray:tempArray];
    }
    
    self.introductionUrlString = [data objectForKey:@"detailUrl"];
    
    self.isFavourate = [[data objectForKey:@"isFavor"] boolValue];
    
    self.stockNumber = [[data objectForKey:@"remainCount"] integerValue];
    self.maxLimit = [[data objectForKey:@"buyMaxNum"] integerValue];
    self.minLimit = [[data objectForKey:@"buyMinNum"] integerValue];
    if (self.stockNumber < self.maxLimit) {
        self.maxLimit = self.stockNumber;
    }
    
    NSArray *storesArray = [data objectForKey:@"store"];
    if ([storesArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempPhoneArray = [[NSMutableArray alloc] init];
        for (NSDictionary *singleDic in storesArray) {
            StoreListItemModel *item = [[StoreListItemModel alloc] initWithRawData:singleDic];
            if (item) {
                [tempArray addObject:item];
                ServiceDetailPhoneItem *phoneItem = [[ServiceDetailPhoneItem alloc] initWithTitle:item.storeName andPhoneNumberString:item.phoneNumber];
                if (phoneItem) {
                    [tempPhoneArray addObject:phoneItem];
                }
            }
            
        }
        self.storeItemsArray = [NSArray arrayWithArray:tempArray];
        _phoneItems = [NSArray arrayWithArray:tempPhoneArray];
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
    
    NSUInteger status = [[data objectForKey:@"status"] integerValue];
    if (status == 1) {
        self.canBuy = YES;
    } else {
        self.canBuy = NO;
    }
    if ([data objectForKey:@"statusDesc"]) {
        self.buyButtonTitle = [NSString stringWithFormat:@"%@", [data objectForKey:@"statusDesc"]];
    }
    
    return YES;
}


- (CGFloat)topCellHeight {
    //image
    CGFloat height = SCREEN_WIDTH * self.imageRatio;
    //service name
    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:17] topGap:10 bottomGap:10 maxLine:0 andText:self.serviceName];
    //service description
    //    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:0 maxLine:0 andText:self.serviceDescription];
    height += [GConfig heightForAttributeLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.serviceDescription];
    
    return height;
}

- (CGFloat)priceCellHeight {
    return 40;
}

- (CGFloat)contentCellHeight {
    CGFloat height = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:14] topGap:10 bottomGap:10 maxLine:0 andText:self.serviceContent];
    
    return height;
}

- (CGFloat)noticeTitleCellHeight {
    return 40;
}

- (CGFloat)noticeCellHeight {
    return self.noticeHeight;
}

- (CGFloat)recommendCellHeight {
    CGFloat height = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 90 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.recommendString];
    if (height < 80) {
        height = 80;
    }
    
    return height;
}

@end
