//
//  SingChatToolBarView.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/3/4.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBackButtonBlock)();

@interface SingChatToolBarView : UIView

@property (nonatomic, strong) ClickBackButtonBlock backBlock; /**< 返回 */

@property (nonatomic, strong) NSString *title; /**< 标题 */

@end
