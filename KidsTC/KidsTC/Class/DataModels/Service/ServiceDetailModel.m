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
    NSArray *coupons = [data objectForKey:@"coupon_provide"];
    if ([coupons isKindOfClass:[NSArray class]] && [coupons count] > 0) {
        self.couponName = [[coupons firstObject] objectForKey:@"name"];
        self.couponProvideCount = [[[coupons firstObject] objectForKey:@"provideNum"] integerValue];
    }
    self.couponUrlString = [data objectForKey:@"couponLink"];
    //store relation-----------------------------------------------------------
    NSDictionary *relationDic = [data objectForKey:@"product_relation"];
    if ([relationDic isKindOfClass:[NSDictionary class]]) {
        //strategy
        NSArray *products = [relationDic objectForKey:@"relatedDiscountProductLs"];
        if ([products isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *strategyDic in products) {
                ServiceMoreDetailHotSalesItemModel *model = [[ServiceMoreDetailHotSalesItemModel alloc] initWithRawData:strategyDic];
                if (model) {
                    [tempArray addObject:model];
                }
            }
            self.moreServiceItems = [NSArray arrayWithArray:tempArray];
        }
    }
    //--------------------------------------------------------------------------
    
    //activity
    NSArray *fullCut = [data objectForKey:@"fullCut"];
    if ([fullCut isKindOfClass:[NSArray class]] && [fullCut count] > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSString *fullCutTitle in fullCut) {
            if ([fullCutTitle isKindOfClass:[NSString class]]) {
                ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypeDiscount description:fullCutTitle];
                if (item) {
                    [tempArray addObject:item];
                }
            }
        }
        self.activeModelsArray = [NSArray arrayWithArray:tempArray];
    }
    
    self.countdownTime = [[data objectForKey:@"countDownTime"] integerValue];
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

- (CGFloat)insuranceCellHeight {
    return 30;
}

- (CGFloat)couponCellHeight {
    return 40;
}

- (CGFloat)activityCellHeightAtIndex:(NSUInteger)index {
    if ([self.activeModelsArray count] > index) {
        CGFloat maxWidth = SCREEN_WIDTH - 50;
        ActivityLogoItem *item = [self.activeModelsArray objectAtIndex:index];
        CGFloat height = [GConfig heightForLabelWithWidth:maxWidth LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:15] topGap:13 bottomGap:13 andText:item.itemDescription];
        if (height < 40) {
            height = 40;
        }
        return height;
    }
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

- (CGFloat)moreServiceTitleCellHeight {
    return 40;
}

- (CGFloat)moreServiceCellHeightAtIndex:(NSUInteger)index {
    return 100;
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
    CGFloat labelWidth = SCREEN_WIDTH - margin * 2 - [self.title length] * wordWidth;
    if (labelWidth < 100) {
        height += wordWidth + margin;
    }
    
    height += [GConfig heightForLabelWithWidth:labelWidth LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:wordWidth] topGap:margin bottomGap:margin andText:self.content];
    
    return height;
}

@end

@implementation ServiceDetailPhoneItem

- (instancetype)initWithTitle:(NSString *)title andPhoneNumbers:(NSArray *)numbers {
    if (!title || ![title isKindOfClass:[NSString class]]) {
        title = @"门店";
    }
    if (!numbers || ![numbers isKindOfClass:[NSArray class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.title = title;
        self.phoneNumbers = numbers;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title andPhoneNumberString:(NSString *)string {
    if (!title || ![title isKindOfClass:[NSString class]]) {
        title = @"门店";
    }
    if (!string || ![string isKindOfClass:[NSString class]] || [string length] == 0) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.title = title;
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        self.phoneNumbers = [string componentsSeparatedByString:@";"];
    }
    return self;
}

@end

