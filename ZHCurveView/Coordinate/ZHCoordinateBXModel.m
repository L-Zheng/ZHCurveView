//
//  ZHCoordinateBXModel.m
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZHCoordinateBXModel.h"
#import "NSDate+Extension.h"

@implementation ZHCoordinateBXModel

- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    [self handleTitle];
}

- (void)setTimeSpaceNumber:(NSNumber *)timeSpaceNumber{
    _timeSpaceNumber = timeSpaceNumber;
    [self handleTitle];
}

- (void)handleTitle{
    if (self.currentDate && self.timeSpaceNumber) {
        
        NSTimeInterval timeSpace = self.timeSpaceNumber.doubleValue;
        if (timeSpace == 0) {
            _title = [self.currentDate stringFromDateFormat:@"MM-dd"];
            
        }else{
            NSDate *nextDate = [NSDate dateWithTimeInterval:timeSpace sinceDate:self.currentDate];
            _title = [NSString stringWithFormat:@"%@/%@",[self.currentDate stringFromDateFormat:@"MM-dd"],[nextDate stringFromDateFormat:@"MM-dd"]];
        }
    }
}

@end
