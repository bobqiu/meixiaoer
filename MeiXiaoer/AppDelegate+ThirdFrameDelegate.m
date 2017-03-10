//
//  AppDelegate+ThirdFrameDelegate.m
//  GouGou-Live
//
//  Created by ma c on 16/11/22.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "AppDelegate+ThirdFrameDelegate.h"
#import <HyphenateLite/HyphenateLite.h>
#import "EaseUI.h"

@implementation AppDelegate (ThirdFrameDelegate)

// 环信
+ (void)setEaseMobSDK:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    EMOptions *options = [EMOptions optionsWithAppkey:@"wangmeikeji#meixiaoer"];
#if DEBUG
    options.apnsCertName = @"meixiaoerDev";
#else
    options.apnsCertName = @"meixiaoerDis";
#endif
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    // 环信登录
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        if ([UserInfo getUserInfo].ID.length != 0) {
            EMError *error = [[EMClient sharedClient] loginWithUsername:[UserInfo getUserInfo].ID password:[NSString md5WithString:[UserInfo getUserInfo].ID]];
            if (!error) {
                NSLog(@"登陆成功");
            } else {
                NSLog(@"登陆失败--%@", error.errorDescription);
            }
        }else{
                NSLog(@"未登录");
        }
    }
    // 环信UI调用
    NSString *apnsCertName;
#if DEBUG
    apnsCertName = @"meixiaoerDev";
#else
    apnsCertName = @"meixiaoerDis";
#endif
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:@"wangmeikeji#meixiaoer"
                                         apnsCertName:apnsCertName
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
}
/** 进入后台 */
+ (void)setEaseMobEnterBackground:(UIApplication *)application{

    [[EMClient sharedClient] applicationDidEnterBackground:application];
}
/** 从后台返回 */
+ (void)setEaseMobEnterForeground:(UIApplication *)application{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


@end
