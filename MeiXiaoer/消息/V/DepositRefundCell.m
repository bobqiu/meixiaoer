//
//  DepositRefundCell.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/3/3.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "DepositRefundCell.h"

@interface DepositRefundCell ()
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;/**< 通知时间*/
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;/**< 支付状态*/
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;/**< 支付时间*/
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;/**< 支付金额*/
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

@property (weak, nonatomic) IBOutlet UILabel *payStyleLabel;/**< 支付方式*/
@property (weak, nonatomic) IBOutlet UILabel *gatherNoteLabel;

@property (weak, nonatomic) IBOutlet UILabel *gatherLabel;/**< 付款方*/
@property (weak, nonatomic) IBOutlet UILabel *accountMarkLabel;/**< 转账说明*/

@end

@implementation DepositRefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickViewBtnAction:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
