//
//  PaymentNotificationCell.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "PaymentNotificationCell.h"

@interface PaymentNotificationCell ()
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;/**< 通知时间*/
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;/**< 支付状态*/
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;/**< 支付时间*/
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;/**< 支付金额*/
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

@property (weak, nonatomic) IBOutlet UILabel *payStyleLabel;/**< 支付方式*/
@property (weak, nonatomic) IBOutlet UILabel *gatherNoteLabel;

@property (weak, nonatomic) IBOutlet UILabel *gatherLabel;/**< 付款方*/

@end

@implementation PaymentNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setPayModel:(PayMentModel *)payModel {
    _payModel = payModel;
    
    self.notificationLabel.text = payModel.createdAt;
    self.payLabel.hidden = NO;
    self.payStyleLabel.hidden = NO;
    
    
    /**< 资金类型:1支付定金  2钱包提现  3平台返利 4退还定金 */
    if (payModel.category == 1) {
        self.payStateLabel.text = @"支付定金";
        self.payLabel.text = @"支付方式:";
        /** 付款方式：1 微信 2 支付宝 3 银联 */
        if (payModel.payType == 1) {
            self.payStyleLabel.text = @"微信";
        }else if (payModel.payType == 2){
            self.payStyleLabel.text = @"支付宝";
        }else if (payModel.payType == 2){
            self.payStyleLabel.text = @"银联";
        }
        self.gatherNoteLabel.text = @"收款方:";
        self.gatherLabel.text = payModel.payee;
    }else if (payModel.category == 2){
        self.payStateLabel.text = @"钱包提现:";
        
        self.gatherNoteLabel.text = @"提现账户:";
        /** 付款方式：1 微信 2 支付宝 3 银联 */
        if (payModel.payType == 1) {
            self.gatherLabel.text = @"微信";
        }else if (payModel.payType == 2){
            self.gatherLabel.text = @"支付宝";
        }else if (payModel.payType == 2){
            self.gatherLabel.text = @"银联";
        }

        self.payLabel.hidden = YES;
        self.payStyleLabel.hidden = YES;
    }else if (payModel.category == 3){
        self.payStateLabel.text = @"平台返利";
        self.payLabel.text = @"返还方式:";
        self.payStyleLabel.text = @"平台返利";
        self.gatherNoteLabel.text = @"收款账户:";
        self.gatherLabel.text = @"钱包";
    }else if (payModel.category == 4){
        self.payStateLabel.text = @"退还定金";
        self.payLabel.text = @"退还方式:";
        self.payStyleLabel.text = @"退还定金";
        self.gatherNoteLabel.text = @"收款账户:";
        self.gatherLabel.text = @"钱包";
    }
    self.payTimeLabel.text = payModel.paytime;
    
    self.payMoneyLabel.text = [NSString stringWithFormat:@"%@元", payModel.fee];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
