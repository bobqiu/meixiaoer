//
//  AuditNotificationCell.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "AuditNotificationCell.h"

@interface AuditNotificationCell ()

@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;/**< 通知时间*/
@property (weak, nonatomic) IBOutlet UILabel *resaonLabel;/**< 原因*/
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;/**< 内容*/
@property (weak, nonatomic) IBOutlet UIButton *recommitBtn;/**< 重新提交*/

@end

@implementation AuditNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (IBAction)clickRecommitAction:(UIButton *)sender {
    if (_recommitBlock) {
        _recommitBlock();
    }
}
- (void)setAuditModel:(AuditNotificationModel *)auditModel {
    _auditModel = auditModel;
    
    self.notificationLabel.text = auditModel.createdAt;
    self.resaonLabel.text = auditModel.title;
    self.contentLabel.text = auditModel.content;
    if (auditModel.status == 1) {
        self.recommitBtn.hidden = YES;
    }else{
        self.recommitBtn.hidden = NO;
    }
}
- (CGFloat)getCellHeight {
    
    // 根据字数设置行高
    [self layoutIfNeeded];
    if (_auditModel.status == 1) {
        return 25 + self.resaonLabel.bounds.size.height + 15 + self.contentLabel.bounds.size.height + 25;

    }else{
        return 25 + self.resaonLabel.bounds.size.height + 15 + self.contentLabel.bounds.size.height + 25 + 20;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
