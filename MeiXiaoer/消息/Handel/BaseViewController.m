//
//  BaseViewController.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BaseViewController.h"
#import "HTTPTool.h"
#import "UMessage.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FCC52E"];
}
- (void)setNavBarItem {
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateNormal)];
    [btn setContentMode:(UIViewContentModeCenter)];
    [btn addTarget:self action:@selector(leftBackBtnAction) forControlEvents:(UIControlEventTouchDown)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)leftBackBtnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark - 网络请求
/** get信息请求 */
- (void)getRequestWithPath:(NSString *)path
                    params:(NSDictionary *)params
                   success:(HttpRequestSuccessBlock)Success
                     error:(HttpRequestErrorBlock)Error {
    //    [self showHudInView:self.view hint:@"加载中.."];
    [HTTPTool getRequestWithPath:path
                          params:params
                         success:^(id successJson) {
                             Success(successJson);
                         } error:^(NSError *error) {
                             Error(error);
                         }];
}

/** post信息请求 */
- (void)postRequestWithPath:(NSString *)path
                     params:(NSDictionary *)params
                    success:(HttpRequestSuccessBlock)Success
                      error:(HttpRequestErrorBlock)Error {
    //    [self showHudInView:self.view hint:@"加载中.."];
    [HTTPTool postRequestWithPath:path
                           params:params
                          success:^(id successJson) {
                              Success(successJson);
                          }
                            error:^(NSError *error) {
                                Error(error);
                            }];
}

// 展示tabbar
- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}
// 隐藏tabbar
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)loginHuanxinWithId:(NSString *)userId {
    // 退出登录
    EMError *logoutErr = [[EMClient sharedClient] logout:YES];
    if (logoutErr) {
        NSLog(@"退出登录%@", logoutErr.errorDescription);
    }
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
            EMError *error = [[EMClient sharedClient] loginWithUsername:userId password:[NSString md5WithString:userId]];
            [[EMClient sharedClient] setApnsNickname:[UserInfo getUserInfo].nickName];
        
            if (!error) {
                NSLog(@"登录后环信登陆成功");
            } else {
                NSLog(@"登录后环信登陆失败%@", error.errorDescription);
            }
        }else{
            NSLog(@"未登录");
    }
    
    // 绑定推送设备
    [UMessage removeAlias:userId type:@"ios" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            NSLog(@"%@", responseObject);
        }
    }];
    [UMessage addAlias:userId type:@"ios" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            NSLog(@"%@", responseObject);
            // 设置当前账号的设备
            NSDictionary *dict = @{
                                   @"id":userId,
                                   @"type":@(2)
                                   };
            [self getRequestWithPath:Api_device params:dict success:^(id successJson) {
                NSLog(@"%@", successJson);
            } error:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        }
    }];

  
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
