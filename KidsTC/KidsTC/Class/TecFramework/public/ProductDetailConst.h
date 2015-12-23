//
//  ProductDetailConst.h
//  iPhone51Buy
//
//  Created by alex tao on 4/9/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#ifndef iPhone51Buy_ProductDetailConst_h
#define iPhone51Buy_ProductDetailConst_h

typedef enum{
    GProductToCartNew = 1001,
    GProductToBigImage = 2001,
    GProductToGift = 3001,
    GProductChangeAddress = 4001,
    //GProductChangeColor = 5001,
    //GProductChangeSize = 6001,
    GProductChangeOther = 7001,
    GProductNumSub = 8001,
    GProductNumInput = 8002,
    GProductNumAdd = 8003,
    GProductBuyNow = 9001,
    GProductAddToCart = 10001,
    GProductFav = 10002,
    GProductShare = 10003,
    GProductToComment = 11001,
    GProductToParam = 12001,
    GProductToDetail = 13001,
    GProductSeeMore = 24002,
    GProductBuyMore = 24001,
    GProductPrice = 16001,      //价格保护
    GProductGUI = 16002,         //贵就赔
    GProductGift = 17001,        //查看赠品
    GProductRecommend = 24003,    //无货推荐
    GProductChangeSelector = 19000      // 第一项000~099，第二项100~199，以此类推
    
} GProductInfo;

typedef enum{
    GProductCommentSatisfy = 1001,
    GProductCommentNormal = 1002,
    GProductCommentUnsatisfy = 1003
    
} GProductComment;


#endif
