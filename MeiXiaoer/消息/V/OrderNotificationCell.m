//
//  OrderNotificationCell.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "OrderNotificationCell.h"

@interface OrderNotificationCell ()

@property (weak, nonatomic) IBOutlet UILabel *notificationTimeLabel;/**< 通知时间 */
@property (weak, nonatomic) IBOutlet UILabel *coalTypeLabel;/**< 煤种 */
@property (weak, nonatomic) IBOutlet UILabel *coalPowerLabel;/**< 发热量*/
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;/**< 下单时间*/
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;/**< 价格*/
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;/**< 购买量*/
@property (weak, nonatomic) IBOutlet UILabel *despotLabel;/**< 定金状况*/
@property (weak, nonatomic) IBOutlet UILabel *despotNumberLabel;/**< 定金数*/
@property (weak, nonatomic) IBOutlet UILabel *finalLabel;/**< 尾款状况*/
@property (weak, nonatomic) IBOutlet UILabel *finalNumberLabel;/**< 尾款数*/
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;/**< 订单号*/
@property (weak, nonatomic) IBOutlet UILabel *lastDeliveLabel;/**< 最晚提货时间*/
@property (weak, nonatomic) IBOutlet UILabel *SellerLabel;/**< 卖方名字*/
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;/**< 负责人 */
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;/**< 状态图片 */
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;/**< 订单状态 */

@end

@implementation OrderNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setOrderModel:(OrderNotificationModel *)orderModel {
    _orderModel = orderModel;
    self.notificationTimeLabel.text = orderModel.createdAt;
    self.coalTypeLabel.text = orderModel.supply.goodsType;
    self.coalPowerLabel.text = [NSString stringWithFormat:@"%ld大卡", orderModel.supply.calorificValue];
    self.orderTimeLabel.text = orderModel.createdTime;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/吨", orderModel.supply.price];
    self.weightLabel.text = [NSString stringWithFormat:@"%@吨", orderModel.buyNum];
    self.despotNumberLabel.text = [NSString stringWithFormat:@"%@元", orderModel.deposit];
    self.finalNumberLabel.text = [NSString stringWithFormat:@"%@元", orderModel.retainage];
    self.orderNumberLabel.text = orderModel.orderNo;
    self.lastDeliveLabel.text = orderModel.pickUptime;
    self.SellerLabel.text = orderModel.supply.address;
    self.managerLabel.text = orderModel.supplyUser.nickname;
    NSString *status;
    if (orderModel.status == 1) {
        status = @"待确认";
        _stateImgView.image = [UIImage imageNamed:@"订单待确定"];
    }else if (orderModel.status == 2){
        status = @"待装煤";
        _stateImgView.image = [UIImage imageNamed:@"订单待确定"];
    }else if (orderModel.status == 3){
        status = @"已取消";
        _stateImgView.image = [UIImage imageNamed:@"订单取消"];
    }else if (orderModel.status == 4){
        status = @"已完成";
        _stateImgView.image = [UIImage imageNamed:@"订单完成"];
    }
    self.stateLabel.text = status;
}
- (IBAction)clickBtnAction:(UIButton *)sender {
    if (_detailBlock) {
        _detailBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
