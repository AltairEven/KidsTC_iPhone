//
//  CommentFoundingModel.m
//  KidsTC
//
//  Created by Altair on 11/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentFoundingModel.h"

@implementation CommentFoundingModel

+ (instancetype)modelFromServiceOrderModel:(OrderModel *)orderModel {
    CommentFoundingModel *commentModel = [[CommentFoundingModel alloc] init];
    commentModel.orderId = orderModel.orderId;
    commentModel.sourceType = (CommentFoundingSourceType)orderModel.productType;
    commentModel.objectId = orderModel.serviceId;
    commentModel.objectName = orderModel.orderName;
    commentModel.imageUrl = orderModel.imageUrl;
    return commentModel;
}


+ (instancetype)modelFromStoreAppointmentModel:(AppointmentOrderModel *)orderModel {
    CommentFoundingModel *commentModel = [[CommentFoundingModel alloc] init];
    commentModel.relationSysNo = orderModel.storeId;
    commentModel.orderId = orderModel.orderId;
    commentModel.sourceType = CommentFoundingSourceTypeStore;
    commentModel.relationType = CommentRelationTypeStore;
    commentModel.objectId = orderModel.storeId;
    commentModel.objectName = orderModel.storeName;
    commentModel.imageUrl = orderModel.imageUrl;
    return commentModel;
}

+ (instancetype)modelFromStore:(StoreDetailModel *)detailModel {
    CommentFoundingModel *commentModel = [[CommentFoundingModel alloc] init];
    commentModel.relationSysNo = detailModel.storeId;
    commentModel.sourceType = CommentFoundingSourceTypeStore;
    commentModel.relationType = CommentRelationTypeStore;
    commentModel.objectId = detailModel.storeId;
    commentModel.objectName = detailModel.storeName;
    commentModel.imageUrl = [detailModel.imageUrls firstObject];
    return commentModel;
}

@end
