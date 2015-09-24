//
//  GInterface.h
//  iPhone51Buy
//
//  Created by xiaomanwang on 13-3-19.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Json.h"

@class HttpProcessHelper;

typedef enum
{
	GInterfaceInitialize = 0,
	GInterfaceLoading = 1,
	GInterfaceCompleted = 2,
}GInterfaceStatus;

@interface GInterface : NSObject
{
	HttpProcessHelper *_interfaceRequestProcessHelper;
	NSMutableArray *queue;
	GInterfaceStatus status;
    NSLock* connectionsLock;
	NSDictionary *_interfaceList;
}
@property(nonatomic, strong)NSDictionary *interfaceList;

+(GInterface *)sharedGInterface;
- (NSDictionary*)load;
- (void)start;
- (void)clearCache;
@end
