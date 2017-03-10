//
//  UserInfo.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/3/4.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *ID; /**< 用户id */

@property (nonatomic, strong) NSString *tel; /**< 手机 */

@property (nonatomic, strong) NSString *token; /**< token */

@property (nonatomic, strong) NSString *name; /**< 登录名（手机号） */

@property (nonatomic, strong) NSString *category; /**< 卖家、买家 */

@property (nonatomic, strong) NSString *nickName; /**< 昵称 */

@property (nonatomic, strong) NSString *passWord; /**< 密码 */

@property (nonatomic, strong) NSString *imgUrl; /**< 头像 */
+ (instancetype)getUserInfo;
@end
