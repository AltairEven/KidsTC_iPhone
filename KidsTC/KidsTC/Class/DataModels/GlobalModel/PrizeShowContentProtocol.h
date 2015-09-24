//
//  PrizeShowContentProtocol.h
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-10-29.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#ifndef iPhone51Buy_PrizeShowContentProtocol_h
#define iPhone51Buy_PrizeShowContentProtocol_h

@protocol PrizeShowContentProtocol <NSObject>
@required
- (void)closePrizeShowContentView;
- (void)prizeNeedShare;
- (void)prizeAddToCart;
@end

#endif
