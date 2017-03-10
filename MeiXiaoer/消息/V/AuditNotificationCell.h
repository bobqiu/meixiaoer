//
//  AuditNotificationCell.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuditNotificationModel.h"


typedef void(^ClcikReCommitButtonBlock)();
@interface AuditNotificationCell : UITableViewCell

@property (nonatomic, strong) ClcikReCommitButtonBlock recommitBlock; /**< 重新提交回调 */

@property (nonatomic, strong) AuditNotificationModel *auditModel; /**< 模型 */

- (CGFloat)getCellHeight;
@end
