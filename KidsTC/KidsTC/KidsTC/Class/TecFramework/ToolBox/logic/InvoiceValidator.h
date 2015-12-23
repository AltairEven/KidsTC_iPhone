//
//  InvoiceValidator.h
//  iphone51buy
//
//  Created by icson apple on 12-7-2.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GValidator.h"

@interface InvoiceValidator : GValidator<GValidatorDelegate>
{
    NSError *error;
}

@property (strong, nonatomic) NSDictionary *invoice;
- (id)initWithInvoice:(NSDictionary *)_invoice;
@end
