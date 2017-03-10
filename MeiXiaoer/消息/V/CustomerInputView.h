//
//  CustomerInputView.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/26.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInputView : UIView

@property (weak, nonatomic) id<EMChatToolbarDelegate> delegate;

+ (instancetype)customView;
@end
