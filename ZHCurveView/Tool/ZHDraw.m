//
//  ZHDraw.m
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZHDraw.h"

@implementation ZHDraw

#pragma mark - public

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

+ (void)drawGradientArea:(CGContextRef)ctx points:(NSArray <NSValue *> *)points colors:(NSArray <UIColor *> *)colors locations:(CGFloat *)locations fillAlpha:(CGFloat)fillAlpha{
    
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
//    CGFloat locations[] = {0.0, 1.0};
    
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

/** 绘制渐变曲线 Layer */
+ (void)drawGradientLine:(UIView *)bgView limitRect:(CGRect)limitRect points:(NSArray <NSValue *> *)points colors:(NSArray <UIColor *> *)colors lineWidth:(CGFloat)lineWidth animated:(BOOL)animated{
    
    if (points.count == 0) return;
    
    CGFloat limitX = limitRect.origin.x;
    CGFloat limitMaxX = CGRectGetMaxX(limitRect);
    CGFloat limitY = limitRect.origin.y;
    CGFloat limitMaxY = CGRectGetMaxY(limitRect);
    CGFloat limitW = limitRect.size.width;
    CGFloat limitH = limitRect.size.height;
    CGFloat lineWidthHalf = lineWidth / 2.0;
    
    //创建背景View
    UIView *gradientBGView = [[UIView alloc] initWithFrame:bgView.bounds];
    [bgView addSubview:gradientBGView];
    
    //创建渐变layer
    CAGradientLayer *gradientBGLayer = [CAGradientLayer layer];
    gradientBGLayer.frame = gradientBGView.bounds;
    CGFloat startXScale = (limitX - lineWidthHalf) / bgView.bounds.size.width;
    CGFloat endXScale = (limitX + limitW + lineWidthHalf) / bgView.bounds.size.width;
    gradientBGLayer.startPoint = CGPointMake(startXScale,0.0);
    gradientBGLayer.endPoint = CGPointMake(endXScale,0.0);
    NSMutableArray *newColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [newColors addObject:(__bridge id)color.CGColor];
    }
    gradientBGLayer.colors = newColors;
    [gradientBGView.layer addSublayer:gradientBGLayer];
    
    //根据点数据绘制渐变线条
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSUInteger drawPointsCount = points.count;
//    [path moveToPoint:CGPointMake(limitX, limitMaxY)];
    [points enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint point = CGPointMake(obj.CGPointValue.x, obj.CGPointValue.y);
        
        if (idx == 0) {
            [path moveToPoint:point];
            //                    [path addArcWithCenter:point radius:4.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        }else if (idx == drawPointsCount - 1){
            //                    [path addArcWithCenter:point radius:4.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
            [path addLineToPoint:point];
        }else{
            //                    [path addArcWithCenter:point radius:4.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
            [path addLineToPoint:point];
        }
    }];
//    [path addLineToPoint:CGPointMake(points.lastObject.CGPointValue.x, limitMaxY)];
    
    CAShapeLayer *lineChartLayer = [CAShapeLayer layer];
    lineChartLayer.path = path.CGPath;
    lineChartLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineChartLayer.fillColor= [UIColor clearColor].CGColor;
    lineChartLayer.lineWidth = lineWidth;
    lineChartLayer.lineCap = kCALineCapRound;
    lineChartLayer.lineJoin = kCALineJoinRound;
    gradientBGView.layer.mask = lineChartLayer;
    
    //执行动画
    if (animated) {
        [self drawGradientLineAnimation:lineChartLayer];
    }
}

#pragma mark - private

+ (void)drawGradientLineAnimation:(CAShapeLayer *)shapeLayer{
//    反向  @"strokeStart"
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 5.0;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pathAnimation.fromValue = [NSNumber numberWithInt:0.0];
    pathAnimation.toValue = [NSNumber numberWithInt:1.0];
//    pathAnimation.delegate = self;

    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

@end
