//
//  InvoiceValidator.m
//  iphone51buy
//
//  Created by icson apple on 12-7-2.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "InvoiceValidator.h"
#import "RegexKitLite.h"

@implementation InvoiceValidator
@synthesize invoice;

- (id)initWithInvoice:(NSDictionary *)_invoice
{
    if (self = [super init]) {
        invoice = _invoice;
		
        error = nil;
    }
    return self;
}

- (void)setError:(NSError *)_error
{
	
    error = _error;
}

- (BOOL)validate
{
#define GINVOICE_CHECK_EMPTY(var, field, msg) if([GToolUtil isEmpty:[var objectForKey: (field)]]) {\
[self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_INVOICE, ERRCODE_FIELD_EMPTY, (msg))];\
return NO;\
}
    
#define GINVOICE_CHECK_LENGTHTOOLONG(var, field, maxlength, msg) if([[var objectForKey: (field)] length] > (maxlength)) {\
[self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_INVOICE, ERRCODE_FIELD_TOOLONG, (msg))];\
return NO;\
}

#define GINVOICE_CHECK_LENGTHTOOSHORT(var, field, minlength, msg) if([[var objectForKey: (field)] length] < (minlength)) {\
[self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_INVOICE, ERRCODE_FIELD_TOOLONG, (msg))];\
return NO;\
}
    
	if ([GToolUtil isEmpty:[invoice objectForKey: @"type"]]) {
		[self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_INVOICE, ERRCODE_DATA_INVALID, @"发票类型错误")];
		return NO;
	}

	NSInteger invoiceType = [[invoice objectForKey: @"type"] integerValue];
	if (invoiceType == INVOICE_TYPE_RETAIL_PERSONAL || invoiceType == INVOICE_TYPE_RETAIL_COMPANY || invoiceType == INVOICE_TYPE_GUANGDONG_NORMAL) {
		NSString *invoiceTypeTitleName = @"发票抬头";
		GINVOICE_CHECK_EMPTY(invoice, @"title", ([NSString stringWithFormat: @"%@不能为空", invoiceTypeTitleName]));
		GINVOICE_CHECK_LENGTHTOOLONG(invoice, @"title", 50,([NSString stringWithFormat: @"%@不能超过50个字符", invoiceTypeTitleName]));
		return YES;
	} else if(invoiceType == INVOICE_TYPE_VAT){
		GINVOICE_CHECK_EMPTY(invoice, @"name", @"公司名称不能为空");
		GINVOICE_CHECK_LENGTHTOOLONG(invoice, @"name", 50, @"公司名称不能超过50个字符");
		GINVOICE_CHECK_EMPTY(invoice, @"addr", @"公司地址不能为空");
		GINVOICE_CHECK_LENGTHTOOLONG(invoice, @"address", 50, @"公司地址不能超过50个字符");
		GINVOICE_CHECK_EMPTY(invoice, @"phone", @"电话号码不能为空");

		if (![GValidator checkTel: [invoice objectForKey: @"phone"]]) {
			[self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_INVOICE, ERRCODE_DATA_INVALID, @"电话号码填写有误，格式：021-83161107")];
			return NO;
		}

//		GINVOICE_CHECK_EMPTY(invoice, @"taxno", @"税号不能为空");
//		GINVOICE_CHECK_LENGTHTOOLONG(invoice, @"taxno", 25, @"税号不能超过25位");
//		if (![self checkChars: [invoice objectForKey: @"taxno"] charType: GCHAR_TYPE_EN | GCHAR_TYPE_NUM]) {
//			[self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_INVOICE, ERRCODE_DATA_INVALID, @"税号只能包含英文或数字")];
//			return NO;
//		}
        // 税号必须在15-20位之间, 只能包含数字和大写字母X;
        GINVOICE_CHECK_EMPTY(invoice, @"taxno", @"税号不能为空");
        GINVOICE_CHECK_LENGTHTOOSHORT(invoice, @"taxno", 15, @"税号长度必须在15到20位之间");
        GINVOICE_CHECK_LENGTHTOOLONG(invoice, @"taxno", 20, @"税号长度必须在15到20位之间");
        NSString *taxNo = [invoice objectForKey: @"taxno"];
        if(![taxNo stringByMatching: @"^[X0-9]+$"]){
			[self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_INVOICE, ERRCODE_DATA_INVALID, @"税号只能包含数字或大写字母X")];
			return NO;
		}
        
        // 银行账号长度小于等于20, 只能包含数字, 字母, 符号-;
		GINVOICE_CHECK_EMPTY(invoice, @"bankno", @"银行账号不能为空");
		GINVOICE_CHECK_LENGTHTOOLONG(invoice, @"bankno", 25, @"银行账号不能超过25位");
		NSString *bankNo = [invoice objectForKey: @"bankno"];
		if(![bankNo stringByMatching: @"^[a-zA-Z0-9\\-]+$"]){
			[self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_INVOICE, ERRCODE_DATA_INVALID, @"银行帐号只能包含英文或数字或-")];
			return NO;
		}

		GINVOICE_CHECK_EMPTY(invoice, @"bankname", @"开户行不能为空");
		GINVOICE_CHECK_LENGTHTOOLONG(invoice, @"bankname", 50, @"开户行不能超过50个字符");
	}

    return YES;
#undef GINVOICE_CHECK_EMPTY
#undef GINVOICE_CHECK_LENGTHTOOLONG
}

- (NSError *)lastError
{
    return error;
}


@end
