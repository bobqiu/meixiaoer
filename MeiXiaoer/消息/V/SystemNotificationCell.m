//
//  SystemNotificationCell.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "SystemNotificationCell.h"

@interface SystemNotificationCell  ()
@property (weak, nonatomic) IBOutlet UILabel *notificationTimeLabel;/**< 通知时间 */

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;/**< 内容 */

@end


@implementation SystemNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSystemModel:(SystemNotificationModel *)systemModel {
    _systemModel = systemModel;
    
    self.notificationTimeLabel.text = systemModel.createdAt;
    self.titleLabel.text = systemModel.title;
    self.contentLabel.text = systemModel.content;
}
- (CGFloat)getCellHeight {
    //1.重新布局子控件
    [self layoutIfNeeded];
    
    return 25 + self.titleLabel.bounds.size.height + 15 + self.contentLabel.bounds.size.height + 25;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
