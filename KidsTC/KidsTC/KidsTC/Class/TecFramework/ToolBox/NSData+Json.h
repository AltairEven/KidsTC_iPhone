//
//  NSData+Json.h
//  iPhone51Buy
//
//  Created by alex tao on 12/6/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Json)

- (NSString *)stringFromJson;

@end


@interface NSData (Json)

- (id)toJSONObject;
- (id)toJSONObject:(NSJSONReadingOptions)option;

// since server using kCFStringEncodingDOSChineseSimplif data encoding, we have to use this fucking hack.
// BTW, FO means FUCK OFF !!!
- (id)toJSONObjectFO;
- (id)toJSONObjectFO:(NSJSONReadingOptions)option;

@end
