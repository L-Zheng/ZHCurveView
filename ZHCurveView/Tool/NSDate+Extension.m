//
//  NSDate+Extension.m
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)stringFromDateFormat:(NSString *)dateFormat{
    
    //设置区域  @"en_US" @"zh_CH"
    NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:local];
//    [fmt setTimeZone:timeZone];
    
    //    @"yyyyMMddHHmm"
    fmt.dateFormat = dateFormat;
    
    return [fmt stringFromDate:self];
}


- (NSInteger)era{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitEra fromDate:self];
    return [components era];
}

- (NSInteger)year{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitYear fromDate:self];
    return [components year];
}

- (NSInteger)month{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

- (NSInteger)day{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

- (NSInteger)hour{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

- (NSInteger)minute{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}

- (NSInteger)second{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitSecond fromDate:self];
    return [components second];
}

- (NSDate *)previousDay{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -1;
    NSDate *newDate = [[self calendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)nextDay{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +1;
    NSDate *newDate = [[self calendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)previousMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[self calendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)nextMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[self calendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)previousYear{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -1;
    NSDate *newDate = [[self calendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)nextYear{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = +1;
    NSDate *newDate = [[self calendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSInteger)weekday{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitWeekday fromDate:self];
    return [components weekday];
}

- (NSInteger)weekdayOrdinal{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self];
    return [components weekdayOrdinal];
}

- (NSInteger)weekOfMonth{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitWeekOfMonth fromDate:self];
    return [components weekOfMonth];
}

- (NSInteger)weekOfYear{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitWeekOfYear fromDate:self];
    return [components weekOfYear];
}

- (NSInteger)yearForWeekOfYear{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self];
    return [components yearForWeekOfYear];
}

- (NSInteger)allDaysCountInThisMonth{
    NSRange totaldaysInMonth = [[self calendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return totaldaysInMonth.length;
}

- (NSInteger)allDaysCountInThisYear{
    NSRange totaldaysInYear = [[self calendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
    return totaldaysInYear.length;
}

- (NSDate *)firstDateInThisMonth{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.calendar = [self calendar];
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    components.year = self.year;
    components.month = self.month;
    components.day = 1;
    
    NSDate *firstDate = [[self calendar] dateFromComponents:components];
    
    return firstDate;
}

- (NSInteger)distanceHoursFromDate:(NSDate *)startingDate{
    NSDateComponents *cmps = [[self calendar] components:NSCalendarUnitHour fromDate:startingDate toDate:self options:0];
    return cmps.hour;
}

- (NSInteger)distanceMinutesFromDate:(NSDate *)startingDate{
    NSDateComponents *cmps = [[self calendar] components:NSCalendarUnitMinute fromDate:startingDate toDate:self options:0];
    return cmps.minute;
}

- (NSInteger)distanceHoursToNow{
    NSDateComponents *cmps = [[self calendar] components:NSCalendarUnitHour fromDate:self toDate:[NSDate date] options:0];
    return cmps.hour;
}

- (NSInteger)distanceMinutesToNow{
    NSDateComponents *cmps = [[self calendar] components:NSCalendarUnitMinute fromDate:self toDate:[NSDate date] options:0];
    return cmps.minute;
}

- (NSDateComponents *)distanceDateComponentsToNow{
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [[self calendar] components:unit fromDate:self toDate:[NSDate date] options:0];
    
}

- (BOOL)isToday{
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [[self calendar] components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [[self calendar] components:unit fromDate:self];
    return
    ((selfCmps.year == nowCmps.year) &&
     (selfCmps.month == nowCmps.month) &&
     (selfCmps.day == nowCmps.day));
}

- (BOOL)isYesterday{
    
    NSDateComponents *cmps = [[self calendar] components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
    return cmps.day == 1;
}

- (BOOL)isThisMonth{
    
    int unit = NSCalendarUnitMonth;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [[self calendar] components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [[self calendar] components:unit fromDate:self];
    
    return nowCmps.month == selfCmps.month;
}

- (BOOL)isThisYear{
    
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [[self calendar] components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [[self calendar] components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (BOOL)isWeekendDay{
    NSInteger weekDay = [self weekday];
    if (weekDay == 1 || weekDay == 7) {
        return YES;
    } else{
        return NO;
    }
}

- (BOOL)isFirstDayInThisMonth{
    return (self.day == 1);
}

/** 小时前 分钟前*/
- (NSString *)referenceTimeText{
    if (self.isThisYear) {  //今年
        if (self.isToday) {  //今天
            NSDateComponents *cmps = [self distanceDateComponentsToNow];
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%ld小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            } else { // 1分钟内发的
                return @"刚刚";
            }
        }else if (self.isYesterday){ //昨天
            return [self stringFromDateFormat:@"昨天 HH:mm"];
        }else{ //至少是前天
            return [self stringFromDateFormat:@"MM-dd HH:mm"];
        }
    } else {
        return [self stringFromDateFormat:@"yyyy-MM-dd"];
    }
}

#pragma mark - Private func

- (NSCalendar *)calendar{
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        //NSCalendarIdentifierGregorian  阳历
        // NSCalendarIdentifierChinese   阴历
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

@end
