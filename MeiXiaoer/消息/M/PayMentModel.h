//
//  PayMentModel.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/27.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BaseModel.h"

@interface PayMentModel : BaseModel

@property (nonatomic, strong) NSString *afterFee; /**< 余额 */

@property (nonatomic, strong) NSString *beforeFee; /**< 操作前金额 */

@property (nonatomic, assign) NSInteger category; /**< 资金类型:1支付定金  2钱包提现  3平台返利 4退还定金 */

@property (nonatomic, strong) NSString *createdAt; /**< 时间 */

@property (nonatomic, assign) NSInteger isRead; /**< <#注释#> */

@property (nonatomic, strong) NSString *fee; /**< 当前操作金额 */

@property (nonatomic, strong) NSString *ID; /**< <#注释#> */

@property (nonatomic, strong) NSString *orderId; /**< <#注释#> */

@property (nonatomic, assign) NSInteger payType; /**< 付款方式：1 微信 2 支付宝 3 银联 */

@property (nonatomic, strong) NSString *payee; /**< 收款方（对方账户） */

@property (nonatomic, strong) NSString *paytime; /**< 支付时间 */

@property (nonatomic, assign) NSInteger status; /**< <#注释#> */

@property (nonatomic, strong) NSString *remark; /**< 说明 */

/**
 afterFee = "50.00";
 beforeFee = "0.00";
 category = 3;
 "created_at" = "2017-01-05 11:43:46";
 fee = "50.00";
 id = 5274;
 isRead = 1;
 orderId = 2368;
 payNumber = "";
 payType = 0;
 payee = "<null>";
 paytime = "2017-01-05 11:43:46";
 remark = "";
 sendStatus = "<null>";
 sendTime = "<null>";
 status = 2;
 "updated_at" = "2017-01-10 15:06:41";
 userId = 217;

 */
@end
