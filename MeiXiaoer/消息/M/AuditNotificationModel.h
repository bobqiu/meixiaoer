//
//  AuditNotificationModel.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/27.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BaseModel.h"

@interface AuditNotificationModel : BaseModel

@property (nonatomic, assign) NSInteger category; /**< 类别 */

@property (nonatomic, strong) NSString *content; /**< 内容 */

@property (nonatomic, strong) NSString *createdAt; /**< 通知时间 */

@property (nonatomic, strong) NSString *ID; /**< id */
@property (nonatomic, assign) NSInteger isRead; /**< 是否读过 */

@property (nonatomic, strong) NSString *title; /**< 标题 */
@property (nonatomic, assign) NSInteger status; /**< 状态 1.不重新提交 2重新提交 */
@end
