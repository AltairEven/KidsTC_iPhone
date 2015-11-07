//
//  OrderCommentModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderCommentModel.h"

@implementation OrderCommentModel

+ (instancetype)modelFromServiceOrderModel:(OrderModel *)orderModel {
    OrderCommentModel *commentModel = [[OrderCommentModel alloc] init];
    commentModel.orderId = orderModel.orderId;
    commentModel.type = OrderTypeServiceOrder;
    commentModel.objectId = orderModel.serviceId;
    commentModel.objectName = orderModel.orderName;
    commentModel.imageUrl = orderModel.imageUrl;
    return commentModel;
}


+ (instancetype)modelFromStoreAppointmentModel:(AppointmentOrderModel *)orderModel {
    OrderCommentModel *commentModel = [[OrderCommentModel alloc] init];
    commentModel.relationSysNo = orderModel.storeId;
    commentModel.orderId = orderModel.orderId;
    commentModel.relationType = CommentRelationTypeStore;
    commentModel.type = OrderTypeStoreAppointmentOrder;
    commentModel.objectId = orderModel.storeId;
    commentModel.objectName = orderModel.storeName;
    commentModel.imageUrl = orderModel.imageUrl;
    return commentModel;
}

+ (instancetype)modelFromStore:(StoreDetailModel *)detailModel {
    OrderCommentModel *commentModel = [[OrderCommentModel alloc] init];
    commentModel.relationSysNo = detailModel.storeId;
    commentModel.relationType = CommentRelationTypeStore;
    commentModel.type = OrderTypeStoreAppointmentOrder;
    commentModel.objectId = detailModel.storeId;
    commentModel.objectName = detailModel.storeName;
    commentModel.imageUrl = [detailModel.imageUrls firstObject];
    return commentModel;
}

@end
