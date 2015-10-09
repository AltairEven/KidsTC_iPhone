//
//  ParentingStrategyDetailModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ParentingStrategyDetailCellModel;

@interface ParentingStrategyDetailModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) NSURL *mainImageUrl;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<ParentingStrategyDetailCellModel *> *cellModels;

- (void)fillWithRawData:(NSDictionary *)data;

@end


@interface ParentingStrategyDetailCellModel : NSObject

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *cellContentString;

@property (nonatomic, copy) NSString *timeDescription;

@property (nonatomic, assign) KTCSearchType relatedInfoType;

@property (nonatomic, copy) NSString *relatedInfoTitle;

@property (nonatomic, copy) NSString *relatedInfoId;

@property (nonatomic, copy) NSString *relatedInfoChannelId;

@property (nonatomic, assign) CGFloat ratio;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat) cellHeight;

@end