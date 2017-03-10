//
//  BaseViewController.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HttpRequestSuccessBlock)(id successJson);
typedef void(^HttpRequestErrorBlock)(NSError *error);

@interface BaseViewController : UIViewController

- (void)setNavBarItem;
/** get请求 */
- (void)getRequestWithPath:(NSString *)path
                    params:(NSDictionary *)params
                   success:(HttpRequestSuccessBlock)Success
                     error:(HttpRequestErrorBlock)Error;
/** post请求 */
- (void)postRequestWithPath:(NSString *)path
                     params:(NSDictionary *)params
                    success:(HttpRequestSuccessBlock)Success
                      error:(HttpRequestErrorBlock)Error;

/**
 展示tabbar
 */
- (void)showTabBar;

/**
 隐藏tabbar
 */
- (void)hideTabBar;

/**
 环信登录 绑定设备

 @param userId 用户id
 */
- (void)loginHuanxinWithId:(NSString *)userId;
@end
