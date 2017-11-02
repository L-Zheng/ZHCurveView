//
//  ZHDataPointModel.h
//  LineTest
//
//  Created by 李保征 on 2017/11/1.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHDataPointModel : NSObject

/** 当前时间  201704280930 */
@property (nonatomic,strong) NSNumber *timeStamp;
@property (nonatomic,strong) NSDate *timeStampDate;
@property (nonatomic,copy) NSString *timeStampStr;
@property (nonatomic,strong) NSNumber *countNumber;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
