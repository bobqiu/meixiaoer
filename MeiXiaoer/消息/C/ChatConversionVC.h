//
//  ChatConversionVC.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//  单人聊天

#import <UIKit/UIKit.h>

@interface ChatConversionVC : EaseMessageViewController

@property (nonatomic, strong) NSString *userName; /**< 用户昵称 */

@property (nonatomic, strong) NSString *userIcon; /**< 用户头像 */

@property (nonatomic, strong) NSString *userId; /**< 用户id */

@end
