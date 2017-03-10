//
//  NSString+StringCategory.h
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringCategory)
/** 时间戳转时间 不含时、分 */
+ (NSString *)GetDateFromString:(NSString *)dateStr;
/** 时间戳转时间 含时、分 */
+ (NSString *)GetHourDateFromString:(NSString *)dateStr;

@end
