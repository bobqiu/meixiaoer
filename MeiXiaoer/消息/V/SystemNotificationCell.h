//
//  SystemNotificationCell.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemNotificationModel.h"
    
@interface SystemNotificationCell : UITableViewCell

@property (nonatomic, strong) SystemNotificationModel *systemModel; /**< 模型 */

- (CGFloat)getCellHeight;
@end
