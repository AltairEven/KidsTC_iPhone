//
//  AddressValidator.h
//  iphone51buy
//
//  Created by icson apple on 12-4-26.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GValidator.h"

@interface AddressValidator : GValidator<GValidatorDelegate>
{
    NSError *error;
}

@property (strong, nonatomic) NSDictionary *address;
- (id)initWithAddress:(NSDictionary *)_address;
@end
