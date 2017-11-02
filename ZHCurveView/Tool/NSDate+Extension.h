//
//  NSDate+Extension.h
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

- (NSString *)stringFromDateFormat:(NSString *)dateFormat;

/** 世纪 年代 */
- (NSInteger)era;

- (NSInteger)year;

- (NSInteger)month;

- (NSInteger)day;

- (NSInteger)hour;

- (NSInteger)minute;

- (NSInteger)second;

- (NSDate *)previousDay;

- (NSDate *)nextDay;

- (NSDate *)previousMonth;

- (NSDate *)nextMonth;

- (NSDate *)previousYear;

- (NSDate *)nextYear;

/** 本周的第几天（周日为第一天） */
- (NSInteger)weekday;

/** 本月的第几个星期几 */
- (NSInteger)weekdayOrdinal;

/** 本月的第几周 */
- (NSInteger)weekOfMonth;

/** 本年的第几周 */
- (NSInteger)weekOfYear;

- (NSInteger)yearForWeekOfYear;

- (NSInteger)allDaysCountInThisMonth;

- (NSInteger)allDaysCountInThisYear;

- (NSDate *)firstDateInThisMonth;

- (NSInteger)distanceHoursFromDate:(NSDate *)startingDate;

- (NSInteger)distanceMinutesFromDate:(NSDate *)startingDate;

- (NSInteger)distanceHoursToNow;

- (NSInteger)distanceMinutesToNow;

- (NSDateComponents *)distanceDateComponentsToNow;

- (BOOL)isToday;

- (BOOL)isYesterday;

- (BOOL)isThisMonth;

- (BOOL)isThisYear;

- (BOOL)isWeekendDay;

- (BOOL)isFirstDayInThisMonth;

/** 小时前 分钟前*/
- (NSString *)referenceTimeText;

@end
