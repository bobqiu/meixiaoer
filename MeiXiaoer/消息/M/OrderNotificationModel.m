//
//  OrderNotificationModel.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/27.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "OrderNotificationModel.h"

@implementation OrderNotificationModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"evaluatesCount" : @"evaluates_count",
             @"moneybillsCount" : @"moneybills_count",
             @"supplyUser":@"supply_user",
             @"ID" : @"id",
             @"createdAt":@"created_at"
             };
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"supply":@"SupplyModel",
             @"supplyUser":@"SupplyUserModel"
             };
}
@end
