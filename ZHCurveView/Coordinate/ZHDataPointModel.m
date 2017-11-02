//
//  ZHDataPointModel.m
//  LineTest
//
//  Created by 李保征 on 2017/11/1.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZHDataPointModel.h"
#import "NSString+Extension.h"
#import "NSDate+Extension.h"

@implementation ZHDataPointModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if (dic) {
            self.timeStamp = [dic valueForKey:@"timeStamp"];
            self.countNumber = [dic valueForKey:@"count"];
        }
    }
    return self;
}



/** 当前时间  201704280930 */
- (void)setTimeStamp:(NSNumber *)timeStamp{
    _timeStamp = timeStamp;
    _timeStampDate = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue];
    //    @"yyyy-MM-dd HH:mm"  @"yyyyMMddHHmm"
    _timeStampStr = [_timeStampDate stringFromDateFormat:@"MM-dd"];
}

@end
