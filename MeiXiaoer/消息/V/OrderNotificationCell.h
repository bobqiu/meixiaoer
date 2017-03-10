//
//  OrderNotificationCell.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderNotificationModel.h"

typedef void(^clickOrderViewDetailBlock)();

@interface OrderNotificationCell : UITableViewCell

@property (nonatomic, strong) clickOrderViewDetailBlock detailBlock; /**< 查看详情回调 */

@property (nonatomic, strong) OrderNotificationModel *orderModel; /**< 模型 */

@end
