//
//  KTCAdvertisementManager.h
//  KidsTC
//
//  Created by Altair on 12/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTCAdvertisementManager : NSObject

+ (instancetype)sharedManager;

- (void)synchronizeAdvertisement;

- (void)removeLocalData;

- (void)removeOverTimeImages;

- (NSArray *)advertisementImages;

- (void)setAlreadyShowed;

@end
