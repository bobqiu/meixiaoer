//
//  UserInfo.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/3/4.
//  Copyright © 2017年 wei. All rights reserved.
//

#define kUserDefault [NSUserDefaults standardUserDefaults]

#import "UserInfo.h"

@implementation UserInfo

+ (instancetype)getUserInfo {
    static UserInfo *_user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[UserInfo alloc] init];
    });
    return _user;
}

- (void)setName:(NSString *)name {
    [kUserDefault setObject:name forKey:@"name"];
    [kUserDefault synchronize];
}
- (NSString *)name {
    NSString *userName = [kUserDefault objectForKey:@"name"];
    return userName;
}

- (void)setID:(NSString *)ID {
    [kUserDefault setObject:ID forKey:@"ID"];
    [kUserDefault synchronize];
}
- (NSString *)ID {
    NSString *userID = [kUserDefault objectForKey:@"ID"];
    return userID;
}

- (void)setTel:(NSString *)tel {
    [kUserDefault setObject:tel forKey:@"tel"];
    [kUserDefault synchronize];
}
- (NSString *)tel {
    NSString *userTel = [kUserDefault objectForKey:@"tel"];
    return userTel;
}

- (void)setToken:(NSString *)token {
    [kUserDefault setObject:token forKey:@"token"];
    [kUserDefault synchronize];
}
- (NSString *)token {
    NSString *usertoken = [kUserDefault objectForKey:@"token"];
    return usertoken;
}

- (void)setNickName:(NSString *)nickName {
    [kUserDefault setObject:nickName forKey:@"nickName"];
    [kUserDefault synchronize];
}
- (NSString *)nickName {
    NSString *userNickName = [kUserDefault objectForKey:@"nickName"];
    return userNickName;
}
- (NSString *)imgUrl {
    NSString *userNickName = [kUserDefault objectForKey:@"imgUrl"];
    return userNickName;
}
- (void)setImgUrl:(NSString *)imgUrl {
    [kUserDefault setObject:imgUrl forKey:@"imgUrl"];
    [kUserDefault synchronize];
}
- (void)setPassWord:(NSString *)passWord {
    [kUserDefault setObject:passWord forKey:@"passWord"];
    [kUserDefault synchronize];
}
- (NSString *)passWord {
    NSString *userPassWord = [kUserDefault objectForKey:@"passWord"];
    return userPassWord;
}

- (void)setCategory:(NSString *)category {
    [kUserDefault setObject:category forKey:@"category"];
    [kUserDefault synchronize];
}
- (NSString *)category {
    NSString *usercategory = [kUserDefault objectForKey:@"category"];
    return usercategory;
}

@end
