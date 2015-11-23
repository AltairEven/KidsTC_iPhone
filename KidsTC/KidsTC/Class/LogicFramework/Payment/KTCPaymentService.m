//
//  KTCPaymentService.m
//  KidsTC
//
//  Created by Altair on 11/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCPaymentService.h"
#import "AlipayManager.h"
#import "WeChatManager.h"

@implementation KTCPaymentService

+ (void)startPaymentWithInfo:(KTCPaymentInfo *)info succeed:(void (^)())succeed failure:(void (^)(NSError *))failure {
    switch (info.paymentType) {
        case KTCPaymentTypeNone:
        {
            succeed();
        }
            break;
        case KTCPaymentTypeAlipay:
        {
            KTCAlipayPaymentInfo *paymentInfo = (KTCAlipayPaymentInfo *)info;
            [[AlipayManager sharedManager] startPaymentWithUrlString:paymentInfo.paymentUrl succeed:succeed failure:failure];
        }
            break;
        case KTCPaymentTypeWechat:
        {
            [[WeChatManager sharedManager] sendPayRequestWithInfo:(KTCWeChatPaymentInfo *)info succeed:succeed failure:failure];
        }
            break;
        default:
            break;
    }
}

@end