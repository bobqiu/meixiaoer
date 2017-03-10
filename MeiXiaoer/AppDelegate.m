//
//  AppDelegate.m
//  MeiXiaoer
//
//  Created by lihaiwei on 2016/10/15.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import <AFNetworking/AFNetworking.h>
#import "MyKeychain.h"
#import "GuideViewController.h"

#import "BuyTabBarController.h"

#import "AppDelegate+ThirdFrameDelegate.h"

#import "WebViewViewController.h"


#import "UMessage.h"
//#import <UserNotifications.h>

@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) UITabBarController *tabBC; /**< 导航控制器 */

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:2.0];

    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);

    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57f89da0e0f55a59ec0022cf"];
    //设置微信的appKey和appSecret
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx7712fa9cb5fb816e" appSecret:@"09ad319740185193558a999722f33926" redirectURL:@"http://mobile.umeng.com/social"];
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105741136"  appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    GuideViewController *platformVc = [[GuideViewController  alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = platformVc;
    //向微信注册
    [WXApi registerApp:@"wx7712fa9cb5fb816e"];
    [self downloadAPPNum];
    
    
    //请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"5AVEk2aR3VkivkAlHENazGew195jjG8s"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    // 利用NSUserDefaults实现
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"首次启动");
        GuideViewController *vc = [[GuideViewController alloc] init];
        self.window.rootViewController = vc;
    }else {
        NSLog(@"非首次启动");
//        BuyTabBarController *tabBC = [[BuyTabBarController alloc] init];
//        self.tabBC = tabBC;
//        self.window.rootViewController = tabBC;
        WebViewViewController *webVc = [[WebViewViewController alloc] init];
        self.window.rootViewController = webVc;
    }
        
    [AppDelegate setEaseMobSDK:application launchOptions:launchOptions];
    
#pragma mark
#pragma mark - 友盟推送

    [UMessage startWithAppkey:@"57f89da0e0f55a59ec0022cf" launchOptions:launchOptions httpsenable:YES ];
    // 开启调试
    [UMessage setLogEnabled:YES];

    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
   
    // 设置推送的alias
      [UMessage removeAlias:[UserInfo getUserInfo].ID type:@"ios" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            NSLog(@"%@", responseObject);
        }
    }];
    
    [UMessage addAlias:[UserInfo getUserInfo].ID type:@"ios" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            NSLog(@"%@", responseObject);
        }
    }];

    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];

    return YES;
}
// 注册token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
//    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    // 消息类型

    NSString *pushType = [userInfo objectForKey:@"pushType"];
    if ([pushType isEqualToString:@"order"]) {// 订单信息
        
    }else if ([pushType isEqualToString:@"notice"]){// 系统通知
        
    }else if ([pushType isEqualToString:@"auth"]){// 审核通知
        
    }

//        self.userInfo = userInfo;
        //定制自定的的弹出框
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            NSLog(@"前端");
            self.window.rootViewController = [[BuyTabBarController alloc] init];
        }else{
            NSLog(@"后台");
            self.window.rootViewController = [[BuyTabBarController alloc] init];
        }
}
//iOS10以后接收的方法
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;

    // 消息类型
    NSString *pushType = [userInfo objectForKey:@"pushType"];
    // 用作跳转
    if ([pushType isEqualToString:@"order"]) {// 订单信息
        
    }else if ([pushType isEqualToString:@"notice"]){// 系统通知
    
    }else if ([pushType isEqualToString:@"auth"]){// 审核通知
        
    }
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
//        [UMessage setAutoAlert:NO];
        //必须加这句代码
        
        [UMessage didReceiveRemoteNotification:userInfo];
        // 跳转到消息界面
        self.window.rootViewController = [[BuyTabBarController alloc] init];
        
        NSLog(@"前台1");
    }else{
        //应用处于前台时的本地推送接受
        NSLog(@"前台2");
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"后台通知消息%@", userInfo);

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"后台1");
        self.window.rootViewController = [[BuyTabBarController alloc] init];
    }else{
        NSLog(@"后台2");
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }
}
//iOS10以前接收的方法
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //这个方法用来做action点击的统计
    [UMessage sendClickReportForRemoteNotification:userInfo];
    //下面写identifier对各个交互式的按钮进行业务处理
}


#pragma mark
#pragma mark - 其他处理

- (void)checkUUID {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[MyKeychain load:@"meixiaoer.uuid"];
    NSString *uuid = [usernamepasswordKVPairs objectForKey:@"meixiaoer.uuid"];
    if (uuid == nil) {
        BOOL getFlag = [[NSUserDefaults standardUserDefaults] boolForKey:@"UUIDFlag"];
        if (getFlag == YES) {
            return;
        }
        uuid = [NSString stringWithFormat:@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UUIDFlag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:uuid forKey:@"meixiaoer.uuid"];
        [MyKeychain save:@"meixiaoer.uuid" data:usernamepasswordKVPairs];
    }
}
//获取下载APP的下载数量
-(void)downloadAPPNum
{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[MyKeychain load:@"meixiaoer.uuid"];
    NSString *uuid = [usernamepasswordKVPairs objectForKey:@"meixiaoer.uuid"];
    if (uuid == nil) { // 说明是第一次调用.
        [self checkUUID];
        uuid = [usernamepasswordKVPairs objectForKey:@"meixiaoer.uuid"];
        
        /* 仅在第一次时,上报安装. */
        if ( ! uuid) {
            return;
        }
        
        NSString *URLString = @"http://mxe.fh25.com/api/register/appinstall";
        
        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:@{@"phoneId": uuid,@"app":@1} error:nil];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"%@ %@", response, responseObject);
            }
        }];
        [dataTask resume];
    }
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSString *string =[url absoluteString];
    ////
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (self.alipaycompletionBlock) {
                self.alipaycompletionBlock(resultDic);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    if ([string hasPrefix:@"QQ41E84550://response_from_qq"]||[string hasPrefix:@"wx7712fa9cb5fb816e://platformId=wechat"]||[string hasPrefix:@"wx7712fa9cb5fb816e://oauth"]||[string hasPrefix:@"tencent1105741136://"]) {
        return  [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    if ([string hasPrefix:@"wx7712fa9cb5fb816e://pay/?returnKey"]) {
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[resp class]]) {
        //支付结果返回,实际支付结果需要去微信服务器去查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果:成功";
                NSLog(@"支付成功-paySuccess,retcode = %d", resp.errCode);
                if (self.wechatcompletionBlock) {
                    self.wechatcompletionBlock(strMsg);
                }
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果:失败! retcode = %d retstr = %@",resp.errCode,resp.errStr];
                NSLog(@"错误码 retcode = %d  错误原因retstr = %@",resp.errCode,resp.errStr);
                break;
        }
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [AppDelegate setEaseMobEnterBackground:application];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [AppDelegate setEaseMobEnterForeground:application];

}


//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
