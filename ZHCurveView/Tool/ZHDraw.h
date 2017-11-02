//
//  ZHDraw.h
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZHDraw : NSObject

//坐标标记文字对齐类型
typedef NS_ENUM(NSInteger, CoordinateTextAlignment) {
    CoordinateTextAlignmentLeftTop      = 0,
    CoordinateTextAlignmentRightTop      = 1,
    CoordinateTextAlignmentLeftBottom      = 2,
    CoordinateTextAlignmentRightBottom      = 3,
    CoordinateTextAlignmentCenter     = 4,
    CoordinateTextAlignmentTopCenter      = 5,
    CoordinateTextAlignmentBottomCenter      = 6,
    CoordinateTextAlignmentLeftCenter      = 7,
    CoordinateTextAlignmentRightCenter      = 8,
};
/**
 布局横纵坐标值
 @param point 绘制开始点
 @param title 文字
 @param coordinateTextAlignment 绘制文字与开始点的对齐方式
 */
+ (void)drawCoordinateValue:(CGPoint)point title:(NSString *)title titleColor:(UIColor *)titleColor coordinateTextAlignment:(CoordinateTextAlignment)coordinateTextAlignment;

/** 绘制线 */
+ (void)drawLine:(CGContextRef)ctx startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color lineWidth:(CGFloat)lineWidth;

/** 点数据绘制线 */
+ (void)drawLine:(CGContextRef)ctx points:(NSArray <NSValue *> *)points color:(UIColor *)color lineWidth:(CGFloat)lineWidth;

/** 绘制渐变区域 */
+ (void)drawGradientArea:(CGContextRef)ctx points:(NSArray <NSValue *> *)points colors:(NSArray <UIColor *> *)colors fillAlpha:(CGFloat)fillAlpha;

@end
