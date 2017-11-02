//
//  ViewController.m
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ViewController.h"
#import "ZHDataPointModel.h"
#import "NSDate+Extension.h"
#import "NSString+Extension.h"
#import "ZHCoordinateBXModel.h"
#import "ZHCoordinateLYModel.h"
#import "ZHChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    ZHChartView *chartView = [[ZHChartView alloc] initWithFrame:CGRectMake(0, 200, 375, 220)];
    chartView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chartView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray <ZHDataPointModel *> *modelsArray = [self loadData];
        chartView.dataPointModels = modelsArray;
        [chartView reDrawRect];
        });
    
}


- (NSMutableArray *)loadData{
    NSDate *currentDate = [NSDate date];
    
    currentDate = [[NSString stringWithFormat:@"%@ 00:00:00",[currentDate stringFromDateFormat:@"yyyy-MM-dd"]] dateFromStringFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSTimeInterval totalCount = 7.0 * 24.0;
    //每隔45秒有一次的数据
//    NSTimeInterval limit = 7.0 * 24.0 * 2 * 2 * 3 * 5 / 0.75;
    //每隔5分钟有一次的数据
    NSTimeInterval limit = 7.0 * 24.0 * 2 * 2 * 3;
    for (NSUInteger i = 0; i < limit; i ++) {
        NSTimeInterval timeStamp = [currentDate timeIntervalSince1970];
        NSNumber *timeStampNumber = [NSNumber numberWithDouble:timeStamp];
        
//        NSUInteger random = arc4random_uniform(200);
        NSUInteger random = pow(i - limit / 2, 2);
        NSNumber *countNumber = [NSNumber numberWithUnsignedInteger:random];
        [array addObject:@{@"timeStamp" : timeStampNumber,@"count" : countNumber}];
        
        currentDate = [NSDate dateWithTimeInterval:(totalCount / limit) * 60 * 60 sinceDate:currentDate];
    }
    
    
    NSMutableArray <ZHDataPointModel *> *modelsArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        ZHDataPointModel *model = [[ZHDataPointModel alloc] initWithDic:dic];
        [modelsArray addObject:model];
//        NSLog(@"--------------------");
//        NSLog(@"%@",model.timeStampDate);
//        NSLog(@"%@",model.timeStampStr);
//        NSLog(@"%ld",model.timeStampDate.hour);
//        NSLog(@"--------------------");
        
//        NSDate *temp = [model.timeStampStr dateFromStringFormat:@"yyyyMMddHHmm"];
//        NSLog(@"%@",temp);
//        NSLog(@"--------------------");
    }
//    NSLog(@"--------------------");
    
    return modelsArray;
}

@end
