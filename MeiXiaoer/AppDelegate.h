//
//  AppDelegate.h
//  MeiXiaoer
//
//  Created by lihaiwei on 2016/10/15.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
typedef void(^AlipayCompletionBlock)(NSDictionary *resultDic);
typedef void(^WechatCompletionBlock)(NSString *strMsg);
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)UINavigationController *navigationController;
@property(strong,nonatomic)BMKMapManager *mapManager;
@property (strong, nonatomic) AlipayCompletionBlock alipaycompletionBlock;
@property(strong,nonatomic)WechatCompletionBlock wechatcompletionBlock;

@end


