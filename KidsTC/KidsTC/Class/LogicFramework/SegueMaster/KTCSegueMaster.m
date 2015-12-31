//
//  KTCSegueMaster.m
//  KidsTC
//
//  Created by Altair on 12/5/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCSegueMaster.h"
#import "KTCWebViewController.h"
#import "ActivityViewController.h"
#import "LoveHouseListViewController.h"
#import "HospitalListViewController.h"
#import "NewsRecommedListViewController.h"
#import "NewSearchResultViewController.h"
#import "ParentingStrategyViewController.h"
#import "ServiceListViewController.h"
#import "StoreListViewController.h"
#import "ServiceDetailViewController.h"
#import "StoreDetailViewController.h"
#import "ParentingStrategyDetailViewController.h"
#import "CouponListViewController.h"
#import "OrderDetailViewController.h"
#import "OrderListViewController.h"

@implementation KTCSegueMaster

+ (UIViewController *)makeSegueWithModel:(HomeSegueModel *)model fromController:(UIViewController *)fromVC {
    if (!model || ![model isKindOfClass:[HomeSegueModel class]]) {
        return nil;
    }
    if (!fromVC || ![fromVC isKindOfClass:[UIViewController class]] || !fromVC.navigationController) {
        return nil;
    }
    UIViewController *toController = nil;
    switch (model.destination) {
        case HomeSegueDestinationH5:
        {
            KTCWebViewController *controller = [[KTCWebViewController alloc] init];
            [controller setWebUrlString:[model.segueParam objectForKey:kHomeSegueParameterKeyLinkUrl]];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationNewsRecommend:
        {
            NewsRecommedListViewController *controller = [[NewsRecommedListViewController alloc] initWithNibName:@"NewsRecommedListViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationNewsList:
        {
            NewSearchResultViewController *controller = [[NewSearchResultViewController alloc] initWithNibName:@"NewSearchResultViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationActivity:
        {
            ActivityViewController *controller = [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationLoveHouse:
        {
            LoveHouseListViewController *controller = [[LoveHouseListViewController alloc] initWithNibName:@"LoveHouseListViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationHospital:
        {
            HospitalListViewController *controller = [[HospitalListViewController alloc] initWithNibName:@"HospitalListViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationStrategyList:
        {
            ParentingStrategyViewController *controller = [[ParentingStrategyViewController alloc] initWithNibName:@"ParentingStrategyViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationServiceList:
        {
            KTCSearchServiceCondition *condition = [KTCSearchServiceCondition conditionFromRawData:model.segueParam];
            ServiceListViewController *controller = [[ServiceListViewController alloc] initWithSearchCondition:condition];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationStoreList:
        {
            KTCSearchStoreCondition *condition = [KTCSearchStoreCondition conditionFromRawData:model.segueParam];
            StoreListViewController *controller = [[StoreListViewController alloc] initWithSearchCondition:condition];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationServiceDetail:
        {
            NSString *serviceId = @"";
            NSString *channelId = @"";
            if ([model.segueParam objectForKey:@"pid"]) {
                serviceId = [NSString stringWithFormat:@"%@", [model.segueParam objectForKey:@"pid"]];
            }
            if ([model.segueParam objectForKey:@"cid"]) {
                channelId = [NSString stringWithFormat:@"%@", [model.segueParam objectForKey:@"cid"]];
            }
            ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:serviceId channelId:channelId];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationStoreDetail:
        {
            NSString *storeId = @"";
            if ([model.segueParam objectForKey:@"sid"]) {
                storeId = [model.segueParam objectForKey:@"sid"];
            }
            StoreDetailViewController *controller = [[StoreDetailViewController alloc] initWithStoreId:storeId];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationStrategyDetail:
        {
            NSString *strategyId = @"";
            if ([model.segueParam objectForKey:@"sid"]) {
                strategyId = [model.segueParam objectForKey:@"sid"];
            }
            ParentingStrategyDetailViewController *controller = [[ParentingStrategyDetailViewController alloc] initWithStrategyIdentifier:strategyId];
            [controller setHidesBottomBarWhenPushed:YES];
            toController = controller;
        }
            break;
        case HomeSegueDestinationCouponList:
        {
            [GToolUtil checkLogin:^(NSString *uid) {
                CouponListViewTag viewTag = (CouponListViewTag)[[model.segueParam objectForKey:@"type"] integerValue];
                CouponListViewController *controller = [[CouponListViewController alloc] initWithCouponListViewTag:viewTag];
                [controller setHidesBottomBarWhenPushed:YES];
                [fromVC.navigationController pushViewController:controller animated:YES];
            } target:fromVC.navigationController];
            return nil;
        }
            break;
        case HomeSegueDestinationOrderDetail:
        {
            [GToolUtil checkLogin:^(NSString *uid) {
                NSString *orderId = @"";
                if ([model.segueParam objectForKey:@"sid"]) {
                    orderId = [model.segueParam objectForKey:@"sid"];
                }
                OrderDetailViewController *controller = [[OrderDetailViewController alloc] initWithOrderId:orderId pushSource:OrderDetailPushSourceSettlement];
                [controller setHidesBottomBarWhenPushed:YES];
                [fromVC.navigationController pushViewController:controller animated:YES];
            } target:fromVC.navigationController];
        }
            break;
        case HomeSegueDestinationOrderList:
        {
            [GToolUtil checkLogin:^(NSString *uid) {
                OrderListType type = (OrderListType)[[model.segueParam objectForKey:@"type"] integerValue];
                OrderListViewController *controller = [[OrderListViewController alloc] initWithOrderListType:type];
                [controller setHidesBottomBarWhenPushed:YES];
                [fromVC.navigationController pushViewController:controller animated:YES];
            } target:fromVC.navigationController];
        }
            break;
        default:
            break;
    }
    if (toController) {
        [fromVC.navigationController pushViewController:toController animated:YES];
    }
    return toController;
}

@end
