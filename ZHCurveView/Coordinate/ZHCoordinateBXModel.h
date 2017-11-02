//
//  ZHCoordinateBXModel.h
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHCoordinateBXModel : NSObject

/** 坐标的时间 */
@property (nonatomic,strong) NSDate *currentDate;
/** 坐标的时间及跨度(用于显示 11:30/13:00 这种类型的坐标) */
@property (nonatomic,strong) NSNumber *timeSpaceNumber;
/** 坐标标题 */
@property (nonatomic,copy,readonly) NSString *title;

@end
