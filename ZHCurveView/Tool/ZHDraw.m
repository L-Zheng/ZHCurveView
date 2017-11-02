//
//  ZHDraw.m
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZHDraw.h"

@implementation ZHDraw

+ (void)drawCoordinateValue:(CGPoint)point title:(NSString *)title titleColor:(UIColor *)titleColor coordinateTextAlignment:(CoordinateTextAlignment)coordinateTextAlignment{
    
    // 画文字
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 文字颜色
    attributes[NSForegroundColorAttributeName] = titleColor;
    // 文字背景颜色
    //    md[NSBackgroundColorAttributeName] = [UIColor greenColor];
    // 文字大小
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:8];
    
    //计算文字所占宽高
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize fitSize = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    switch (coordinateTextAlignment) {
        case CoordinateTextAlignmentLeftTop:
            
            break;
        case CoordinateTextAlignmentRightTop:
            point = CGPointMake(point.x - fitSize.width, point.y);
            break;
            
        case CoordinateTextAlignmentLeftBottom:
            point = CGPointMake(point.x, point.y - fitSize.height);
            break;
            
        case CoordinateTextAlignmentRightBottom:
            point = CGPointMake(point.x - fitSize.width, point.y - fitSize.height);
            break;
            
        case CoordinateTextAlignmentCenter:
            point = CGPointMake(point.x - fitSize.width * 0.5, point.y - fitSize.height * 0.5);
            break;
            
        case CoordinateTextAlignmentTopCenter:
            point = CGPointMake(point.x - fitSize.width * 0.5, point.y);
            break;
            
        case CoordinateTextAlignmentBottomCenter:
            point = CGPointMake(point.x - fitSize.width * 0.5, point.y - fitSize.height);
            break;
            
        case CoordinateTextAlignmentLeftCenter:
            point = CGPointMake(point.x, point.y - fitSize.height * 0.5);
            break;
            
        case CoordinateTextAlignmentRightCenter:
            point = CGPointMake(point.x - fitSize.width, point.y - fitSize.height * 0.5);
            break;
            
        default:
            break;
    }
    
    // 将文字绘制到指点的位置
    [title drawAtPoint:point withAttributes:attributes];
}

+ (void)drawLine:(CGContextRef)ctx startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color lineWidth:(CGFloat)lineWidth{
    //创建上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 起点
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
    // 终点
    CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
    // 线条颜色
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    // 线条宽度
    CGContextSetLineWidth(ctx, lineWidth);
    // 线条的起点和终点的样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    // 线条的转角的样式
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextStrokePath(ctx);
}

+ (void)drawLine:(CGContextRef)ctx points:(NSArray <NSValue *> *)points color:(UIColor *)color lineWidth:(CGFloat)lineWidth{
    if (points.count == 0) return;
    
    //创建上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 线条颜色
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    // 线条宽度
    CGContextSetLineWidth(ctx, lineWidth);
    // 线条的起点和终点的样式
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    // 线条的转角的样式
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    // 起点
    CGFloat startDrawX = points[0].CGPointValue.x;
    CGFloat startDrawY = points[0].CGPointValue.y;
    
    CGContextMoveToPoint(ctx, startDrawX, startDrawY);
    
    for (NSInteger i = 1; i < points.count; i++) {
        
        CGFloat drawX = points[i].CGPointValue.x;
        CGFloat drawY = points[i].CGPointValue.y;
        
//        if (i > 1) {
//            CGContextMoveToPoint(ctx, drawX, drawY);
//        }
        // 终点
        CGContextAddLineToPoint(ctx, drawX, drawY);
    }
    CGContextStrokePath(ctx);
}

+ (void)drawGradientArea:(CGContextRef)ctx points:(NSArray <NSValue *> *)points colors:(NSArray <UIColor *> *)colors fillAlpha:(CGFloat)fillAlpha{
    
    if (points.count == 0 || colors.count == 0) return;
    
    //创建闭合路径
    CGMutablePathRef fillPath = CGPathCreateMutable();
    
    //起点
    CGPoint firstPoint = points.firstObject.CGPointValue;
    CGPathMoveToPoint(fillPath, NULL, firstPoint.x,firstPoint.y);
    
    //路径
    for (NSInteger i = 0; i < points.count; i++) {
        CGFloat drawX = points[i].CGPointValue.x;
        CGFloat drawY = points[i].CGPointValue.y;
        CGPathAddLineToPoint(fillPath, NULL, drawX, drawY);
    }
    CGPathCloseSubpath(fillPath);
    
    //确定范围
    CGRect pathRect = CGPathGetBoundingBox(fillPath);
    
    //确定渐变方向
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    //渐变
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    
    NSMutableArray *refColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [refColors addObject:((__bridge id)color.CGColor)];
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) refColors, locations);
    
    //上下文
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, fillPath);
    CGContextClip(ctx);
    CGContextSetAlpha(ctx, fillAlpha);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    CGContextRestoreGState(ctx);
    
    //释放
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGPathRelease(fillPath);
}

@end
