//
//  MessageCell.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView; /**< 头像 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;/**< 名字 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;/**< 内容 */
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;/**< 时间 */

@end
