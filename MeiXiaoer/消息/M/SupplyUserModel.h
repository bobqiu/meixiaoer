//
//  SupplyUserModel.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/27.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BaseModel.h"

@interface SupplyUserModel : BaseModel

@property (nonatomic, strong) NSString *company; /**< 供货人公司 */
@property (nonatomic, assign) NSInteger ID; /**< 供货人id */
@property (nonatomic, strong) NSString *nickname; /**< 卖家名称 */
@property (nonatomic, strong) NSString *tel; /**< 卖家电话 */
@end
