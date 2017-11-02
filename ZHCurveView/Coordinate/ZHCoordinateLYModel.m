//
//  ZHCoordinateLYModel.m
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZHCoordinateLYModel.h"

@implementation ZHCoordinateLYModel

- (void)setCountNumber:(NSNumber *)countNumber{
    _countNumber = countNumber;
    
    if (countNumber) {
//        [NSString stringWithFormat:@"%.2f",countNumber.floatValue]
        _title = [NSString stringWithFormat:@"%@",countNumber];
    }
}

@end
