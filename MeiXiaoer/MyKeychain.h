//
//  MyKeychain.h
//  MeiXiaoer
//
//  Created by lihaiwei on 2016/10/15.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyKeychain : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end
