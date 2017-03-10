//
//  PaymentNotificationCell.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayMentModel.h"

typedef void(^clickPayViewDetailBlock)();

@interface PaymentNotificationCell : UITableViewCell

@property (nonatomic, strong) clickPayViewDetailBlock payDetailBlock; /**< 支付详情 */

@property (nonatomic, strong) PayMentModel *payModel; /**< 支付模型 */

@end
