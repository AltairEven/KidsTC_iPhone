//
//  HomeActivityService.h
//  KidsTC
//
//  Created by Altair on 1/4/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeActivity;

@interface HomeActivityService : NSObject

@property (nonatomic, strong, readonly) HomeActivity *currentActivity;

- (void)synchronizeActivitySuccess:(void(^)(HomeActivity *activity))success failure:(void(^)(NSError *error))failure;;

- (void)removeLocalData;

- (void)setHasDisplayedWebPage;

@end

@interface HomeActivity : NSObject <NSCoding>

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *pageUrlString;

@property (nonatomic, copy) NSString *linkUrlString;

@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, copy) NSString *thumbImageUrlString;

@property (nonatomic, assign) NSTimeInterval startTime;

@property (nonatomic, assign) NSTimeInterval expireTime;

@property (nonatomic, assign) BOOL hasDisplayedWebPage;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
