//
//  SupplyModel.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/27.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BaseModel.h"

@interface SupplyModel : BaseModel

@property (nonatomic, strong) NSString *address; /**< 卖家地址 */
@property (nonatomic, assign) NSInteger calorificValue; /**< 发热量 */

@property (nonatomic, strong) NSString *coalmine; /**< 煤矿名称 */

@property (nonatomic, strong) NSString *contactsName; /**< 卖家联系人 */
@property (nonatomic, assign) NSInteger contactsTel; /**< 卖家电话 */

@property (nonatomic, strong) NSString *goodsType; /**< 煤种 */

@property (nonatomic, strong) NSString *price; /**< 标价 */

@end
