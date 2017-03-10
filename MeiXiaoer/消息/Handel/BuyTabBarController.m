//
//  BuyTabBarController.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/28.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BuyTabBarController.h"

#import "MessageViewController.h"
#import "WebViewViewController.h"

@interface BuyTabBarController ()

@end

@implementation BuyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTabBar];
    self.tabBar.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbBG"]];
    [self setSelectedIndex:2];
}

- (void)changeTabbar{
    NSArray *arr = self.tabBar.items;
    UITabBarItem *item = arr[0];
    NSLog(@"%@", item);
    
    if ([[KDefcults objectForKey:MeixiaoerType] isEqualToString:Buy]) {
        [item setTitle:@"买煤"];
        [item setImage:[UIImage imageNamed:@"icon-buy"]];
//        [item setSelectedImage:[UIImage imageNamed:@"icon-buy-select"]];
    }else{
        [item setTitle:@"卖煤"];
        [item setImage:[UIImage imageNamed:@"icon-sell"]];
//        [item setSelectedImage:[UIImage imageNamed:@"icon-sell-select"]];
    }
}
- (void)creatTabBar {
    if ([[KDefcults objectForKey:MeixiaoerType] isEqualToString:Buy]) {
        MessageViewController *buyVc = [[MessageViewController alloc] init];
        [self createVc:buyVc title:@"买煤" selectImg:@"icon-buy-select" normalImg:@"icon-buy" isNav:NO];
    }else{
        MessageViewController *buyVc = [[MessageViewController alloc] init];
        [self createVc:buyVc title:@"卖煤" selectImg:@"icon-sell-select" normalImg:@"icon-sell" isNav:NO];
    }

    MessageViewController *orderVc = [[MessageViewController alloc] init];
    [self createVc:orderVc title:@"订单" selectImg:@"icon-order-select" normalImg:@"icon-order" isNav:NO];
    
    MessageViewController *messageVc = [[MessageViewController alloc] init];
    [self createVc:messageVc title:@"消息" selectImg:@"icon-message-select" normalImg:@"icon-message" isNav:YES];
    
    MessageViewController *myVc = [[MessageViewController alloc] init];
    [self createVc:myVc title:@"我的" selectImg:@"icon-my-select" normalImg:@"icon-my" isNav:NO];
}
- (void)showMessage {
    NSArray *arr = self.tabBar.items;
    UITabBarItem *item = arr[2];
    NSLog(@"%@", item);
    [item setImage:[UIImage imageNamed:@"icon-buy"]];
    [item setImage:[UIImage imageNamed:@"icon-buy"]];

}
- (void)hidMessage {
    NSArray *arr = self.tabBar.items;
    UITabBarItem *item = arr[2];
    NSLog(@"%@", item);
    [item setImage:[UIImage imageNamed:@"icon-buy"]];
    [item setImage:[UIImage imageNamed:@"icon-buy"]];
}
- (void)createVc:(UIViewController *)Vc title:(NSString *)title selectImg:(NSString *)selectImg normalImg:(NSString *)normalImg isNav:(BOOL)isNav{
    
    // 文字偏移
    Vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(3, 0);
    self.tabBarItem.title = title;
    Vc.title = title;
    // 文字富文本
    NSDictionary *normalDict = @{
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                 NSFontAttributeName:[UIFont systemFontOfSize:12]
                                 };
    
//    [Vc.tabBarItem setTitleTextAttributes:normalDict forState:(UIControlStateNormal)];
    NSDictionary *selectDict = @{
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:206/255.0 green:177/255.0 blue:53/255.0 alpha:1],
                                 NSFontAttributeName:[UIFont systemFontOfSize:12]
                                 };
    
    if (isNav == YES) {
        [Vc.tabBarItem setTitleTextAttributes:selectDict forState:(UIControlStateNormal)];
        [Vc.tabBarItem setTitleTextAttributes:selectDict forState:(UIControlStateSelected)];

        UIImage *select = [UIImage imageNamed:selectImg];
        [Vc.tabBarItem setImage:select];
        [Vc.tabBarItem setSelectedImage:select];
        
    }else{
        [Vc.tabBarItem setTitleTextAttributes:normalDict forState:(UIControlStateNormal)];
        [Vc.tabBarItem setTitleTextAttributes:normalDict forState:(UIControlStateSelected)];
        
        UIImage *normal = [UIImage imageNamed:normalImg];
        [Vc.tabBarItem setImage:normal];
        [Vc.tabBarItem setSelectedImage:normal];
    }

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Vc];
        [self addChildViewController:nav];

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSArray *arr = tabBar.items;
    NSUInteger index =  [arr indexOfObject:item];
    if (index != 2) {
        // 切换根视图控制器
        
        NSString *urlString = @"";
        if (index == 0) {
            if ([[KDefcults objectForKey:MeixiaoerType] isEqualToString:Buy]) {
                urlString = @"http://mxe-pc.fh25.com/app/buy.html";
            }else{
                urlString = @"http://mxe-pc.fh25.com/app/sell.html";
            }
        }else if (index == 1) {
            if ([[KDefcults objectForKey:MeixiaoerType] isEqualToString:Buy]) {
                urlString = @"http://mxe-pc.fh25.com/app/order.html";
            }else{
                urlString = @"http://mxe-pc.fh25.com/app/add.html";
            }
        }else if (index == 3){
            if ([[KDefcults objectForKey:MeixiaoerType] isEqualToString:Buy]) {
                urlString = @"http://mxe-pc.fh25.com/app/personal.html";
            }else{
                urlString = @"http://mxe-pc.fh25.com/app/my.html";
            }
        }
        
        self.view.window.rootViewController = [[WebViewViewController alloc] init];

        NSDictionary *dict = @{@"url":urlString};
        NSNotification* notification = [NSNotification notificationWithName:@"URLSTRING" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
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
