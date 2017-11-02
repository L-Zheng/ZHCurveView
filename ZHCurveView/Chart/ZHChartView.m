//
//  ZHChartView.m
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZHChartView.h"

@implementation ZHChartView

#pragma mark - layout

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.bottomXModels.count && self.leftYModels.count && self.drawPointModels.count && self.drawPointModels.count) {
        //5、绘制覆盖阴影
        [self drawGradient:self.drawPointModels];
    }
}

- (void)drawGradient:(NSArray <NSValue *> *)curvePoints{
    
    NSMutableArray <NSValue *> *drawPoints = [NSMutableArray array];
    //添加原点
    [drawPoints addObject:[NSValue valueWithCGPoint:[self pointLeftOrigin]]];
    //添加曲线点
    [drawPoints addObjectsFromArray:curvePoints];
    //添加结束点 构成闭合路径
    [drawPoints addObject:[NSValue valueWithCGPoint:CGPointMake(curvePoints.lastObject.CGPointValue.x, self.maxY)]];
    [drawPoints addObject:[NSValue valueWithCGPoint:[self pointLeftOrigin]]];
    
    //颜色组
    NSArray *colorsArray = @[[UIColor colorWithRed:102.0/255.0 green:179.0/255.0 blue:255.0/255.0 alpha:0.5], [UIColor colorWithRed:102.0/255.0 green:179.0/255.0 blue:255.0/255.0 alpha:0.1]];
    
    
    //绘制
    [ZHDraw drawGradientArea:UIGraphicsGetCurrentContext() points:drawPoints colors:colorsArray fillAlpha:0.5];
}


@end