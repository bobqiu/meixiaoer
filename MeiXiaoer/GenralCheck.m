//
//  GenralCheck.m
//  MeiXiaoer
//
//  Created by lihaiwei on 2016/12/22.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "GenralCheck.h"
#import "MyKeychain.h"
@interface GenralCheck ()
{
    NSUserDefaults *userInfo;
}

@end
@implementation GenralCheck

- (instancetype)init {
    self = [super init];
    if (self !=nil ) {
        userInfo = [NSUserDefaults standardUserDefaults];
        
    }
    return self;
}
- (void)check {
    [self checkUUID];
    
}

- (void)checkUUID {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[MyKeychain load:@"yibu.uuid"];
    NSString *uuid = [usernamepasswordKVPairs objectForKey:@"yibu.uuid"];
    if (uuid == nil) {
        BOOL getFlag = [[NSUserDefaults standardUserDefaults] boolForKey:@"UUIDFlag"];
        if (getFlag == YES) {
            //多开用户
            [userInfo setObject:nil forKey:@"accessToken"];
            [userInfo synchronize];
            //UIAlertView *mAlert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"应用异常，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //mAlert.tag = 32002;
            // mAlert.delegate = [GlobalAction instance];
            // [mAlert show];
            return;
        }
        uuid = [NSString stringWithFormat:@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UUIDFlag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:uuid forKey:@"yibu.uuid"];
        [MyKeychain save:@"yibu.uuid" data:usernamepasswordKVPairs];
    }
}

- (NSString *)getUUID {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[MyKeychain load:@"yibu.uuid"];
    NSString *uuid = [usernamepasswordKVPairs objectForKey:@"yibu.uuid"];
    if (uuid == nil) {
        [self checkUUID];
        uuid = [usernamepasswordKVPairs objectForKey:@"yibu.uuid"];
    }
    
    return uuid;
}

@end
