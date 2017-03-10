//
//  SystemNotificationModel.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/27.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BaseModel.h"

@interface SystemNotificationModel : BaseModel
@property (nonatomic, assign) NSInteger category; /**< 类别 */

@property (nonatomic, strong) NSString *content; /**< 内容 */

@property (nonatomic, strong) NSString *createdAt; /**< 通知时间 */

@property (nonatomic, strong) NSString *ID; /**< id */
@property (nonatomic, assign) NSInteger isRead; /**< 是否读过 */

@property (nonatomic, strong) NSString *title; /**< 标题 */

/**
 category = 1;
 content = "\U5185\U8499\U53e4\U7231\U5730\U80fd\U6e90\U6709\U9650\U516c\U53f8\U5165\U9a7b\U7164\U5c0f\U4e8c\Uff0c\U8bf7\U5927\U5bb6\U5173\U6ce8\Uff01";
 "created_at" = "2017-01-10 23:23:48";
 id = 315;
 isRead = 1;
 readerId = "<null>";
 sendtime = "0000-00-00 00:00:00";
 status = 1;
 title = "\U70ed\U70c8\U5e86\U795d\U201c\U5185\U8499\U53e4\U7231\U5730\U80fd\U6e90\U6709\U9650\U516c\U53f8\U201d\U5165\U9a7b\U7164\U5c0f\U4e8c\Uff01";
 "updated_at" = "2017-01-11 18:52:25";
 userId = 0;

 */
@end
