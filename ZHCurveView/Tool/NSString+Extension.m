//
//  NSString+Extension.m
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSDate *)dateFromStringFormat:(NSString *)dateFormat;{
    
    //设置区域  @"en_US" @"zh_CH"
    NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:local];
//    [fmt setTimeZone:timeZone];
    
    //    @"yyyyMMddHHmm"
    fmt.dateFormat = dateFormat;
    
    return [fmt dateFromString:self];
}

@end
