//
//  NSString+ShiftEncode.h
//  iphone51buy
//
//  Created by alex tao on 11/28/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ShiftEncode)

- (NSString*) shift:(int)offset;        // eg: str="abcdef", offset=4; return="efghij" (a+4, b+4, c+4, d+4, e+4, f+4)

- (NSString*) shiftEachDigit:(NSArray*)offsetArr;        // eg: str="abcdef", offsetArr=array('1','2','3'), return="bdfdef" (a+1, b+2, c+3, d+0, e+0, f+0)

- (NSString*) reverseString;

@end
