//
//  OrderNotificationModel.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/27.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BaseModel.h"
#import "SupplyModel.h"
#import "SupplyUserModel.h"

@interface OrderNotificationModel : BaseModel

@property (nonatomic, strong) NSString *createdTime; /**< 下单时间 */

@property (nonatomic, strong) NSString *createdAt; /**< 通知时间 */

@property (nonatomic, strong) NSString *buyNum; /**< 购买量 */

@property (nonatomic, strong) NSString *deposit; /**< 定金 */

@property (nonatomic, strong) NSString *retainage; /**< 尾款 */

@property (nonatomic, strong) NSString *evaluatesCount; /**< <#注释#> */

@property (nonatomic, strong) NSString *ID; /**< 订单id */

@property (nonatomic, assign) NSInteger isRead; /**< 是否已经读了 */

@property (nonatomic, assign) NSInteger isSupplerRead; /**< <#注释#> */

@property (nonatomic, strong) NSString *moneybillsCount; /**< <#注释#> */

@property (nonatomic, strong) NSString *orderNo; /**< 订单编号 */

@property (nonatomic, strong) NSString *pickUptime; /**< 最晚提货时间 */

@property (nonatomic, strong) NSString *pickupWay; /**< 提货方式 */

@property (nonatomic, strong) NSString *realPrice; /**< 成交价 */
@property (nonatomic, assign) NSInteger status; /**< 订单状态:1待确认、2待装煤、3已取消、4已完成*/
@property (nonatomic, assign) NSInteger supplerId; /**< <#注释#> */

@property (nonatomic, strong) SupplyModel *supply; /**< 卖货方信息 */

@property (nonatomic, strong) SupplyUserModel *supplyUser; /**< 卖家联系人信息 */

@property (nonatomic, strong) NSString *totalPayment; /**< <#注释#> */

@property (nonatomic, strong) NSString *userRemark; /**< <#注释#> */

/**
 buyNum = "10.00";
 cancelStatus = "<null>";
 cancelTime = "<null>";
 cancelerId = "<null>";
 closeTime = "2016-12-28 15:16:00";
 createdTime = "2016-12-28";
 "created_at" = "2016-12-28 14:54:42";
 "deleted_at" = "<null>";
 deposit = "1.00";
 "evaluates_count" = 1;
 id = 2368;
 isRead = 2;
 isSupplerRead = 2;
 "moneybills_count" = 1;
 orderNo = 16122801104024;
 pickUptime = "2017-01-04";
 pickupWay = "\U81ea\U53d6";
 realPrice = "0.00";
 retainage = "-1.00";
 status = 4;
 supplerId = 207;
 supplerRemark = "<null>";
 supply =             {
 address = "\U5e7f\U897f\U58ee\U65cf\U81ea\U6cbb\U533a\U6842\U6797\U5e02\U4e03\U661f\U533a\U4e03\U91cc\U5e97\U8def\U8f85\U8def";
 calorificValue = 7000;
 coalmine = "\U5c0f\U7164\U77ff";
 contactsName = "\U9ea6\U6ce2\U6797";
 contactsTel = 18577322203;
 goodsType = "80\U5757";
 id = 175;
 price = "0.10";
 };
 supplyId = 175;
 "supply_user" =             {
 company = "\U6842\U6797\U5e02";
 id = 207;
 nickname = "\U9ea6\U6ce2\U6797";
 tel = 18577322203;
 };
 sureCoaling = "2017-01-05 11:39:11";
 sureRetainage = "2017-01-05 11:43:01";
 totalPayment = "1.00";
 updateTime = "2017-01-05";
 "updated_at" = "2017-01-05 11:49:17";
 userId = 217;
 userRemark = "";
 
 */

@end
