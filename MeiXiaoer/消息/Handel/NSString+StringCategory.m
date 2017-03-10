//
//  NSString+StringCategory.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "NSString+StringCategory.h"
//#import <CommonCrypto/CommonDigest.h>

@implementation NSString (StringCategory)
+ (NSString *)GetDateFromString:(NSString *)dateStr{
    // 时间戳转时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dateStr intValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YY-MM-dd";
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
+ (NSString *)GetHourDateFromString:(NSString *)dateStr{
    // 时间戳转时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dateStr intValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YY-MM-dd HH:mm";
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


@end
