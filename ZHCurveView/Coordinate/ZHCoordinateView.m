//
//  ZHCoordinateView.m
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZHCoordinateView.h"

@interface ZHCoordinateView ()
@end

@implementation ZHCoordinateView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configCoordinateProperty];
    }
    return self;
}

- (void)configCoordinateProperty{
    
    //上下左右边缘空闲宽度
    self.leftEdge = 30;
    self.rightEdge = 20;
    self.topEdge = 10;
    self.bottomEdge = 10;
    
    //坐标轴单位
    self.zhCoordinateBXUnitType = ZHCoordinateBXUnitTypeDate;
    self.zhCoordinateLYUnitType = ZHCoordinateLYUnitTypeNumber;
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.selfWidth = self.frame.size.width;
    self.selfHeight = self.frame.size.height;
}

#pragma mark - getter
//限制区域
- (CGFloat)minX{
    return self.leftEdge;
}

- (CGFloat)maxX{
//   不使用 self.frame.size.width  否则不能在子线程调用
    return self.selfWidth - self.rightEdge;
}

- (CGFloat)minY{
    return self.topEdge;
}

- (CGFloat)maxY{
    return self.selfHeight - self.bottomEdge;
}

- (CGFloat)limitH{
    return self.selfHeight - self.bottomEdge - self.topEdge;
}

- (CGFloat)limitW{
    return self.selfWidth - self.leftEdge - self.rightEdge;
}

#pragma mark - public
//特殊点位置
- (CGPoint)pointLeftYMidPoint{
    return CGPointMake(self.minX, self.limitH * 0.5 + self.minY);
}

- (CGPoint)pointRightYMidPoint{
    return CGPointMake(self.maxX, self.limitH * 0.5 + self.minY);
}

- (CGPoint)pointBottomXMidPoint{
    return CGPointMake(self.limitW * 0.5 + self.minX, self.maxY);
}

- (CGPoint)pointLeftOrigin{
    return CGPointMake(self.minX, self.maxY);
}

- (CGPoint)pointRightOrigin{
    return CGPointMake(self.maxX, self.maxY);
}

//重新绘制
- (void)reDrawRect{
    if (self.dataPointModels.count == 0) return;

    //数据处理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //1、计算横纵坐标数据
        __weak __typeof__(self) weakSelf = self;
        [self handleCoordinateXYModels:^(NSMutableArray<ZHCoordinateBXModel *> *bxModels, NSMutableArray<ZHCoordinateTXModel *> *txModels, NSMutableArray<ZHCoordinateLYModel *> *lyModels, NSMutableArray<ZHCoordinateRYModel *> *ryModels) {
            weakSelf.bottomXModels = bxModels;
            weakSelf.topXModels = txModels;
            weakSelf.leftYModels = lyModels;
            weakSelf.rightYModels = ryModels;
        }];
        
        //2、计算点数据
        self.drawPointModels = [self getDrawCoordinatePoints];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    });
}

#pragma mark - layout

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.dataPointModels.count && self.bottomXModels.count && self.leftYModels.count) {
        //1、绘制坐标轴
        [self drawTopCoordinateLine];
        [self drawBootomCoordinateLine];
        [self drawLeftCoordinateLine];
        [self drawRightCoordinateLine];
        
        //2、绘制分割线
        [self drawSegmentLine];
        
        //3、绘制分割区域阴影
        [self drawSegmentAreaShadow];
        
        //4、绘制点数据
        if (self.drawPointModels.count) {
            //绘制渐变曲线
            NSArray *colors = @[[UIColor colorWithRed:94.0/255.0 green:166.0/255.0 blue:255.0/255.0 alpha:1.0],
                                [UIColor colorWithRed:74.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0],
                                [UIColor colorWithRed:85.0/255.0 green:81.0/255.0 blue:255.0/255.0 alpha:1.0]];
            [ZHDraw drawGradientLine:self limitRect:CGRectMake(self.minX, self.minY, self.limitW, self.limitH) points:self.drawPointModels colors:colors lineWidth:2.0 animated:YES];
            //绘制曲线
//            [ZHDraw drawLine:UIGraphicsGetCurrentContext() points:self.drawPointModels color:[UIColor colorWithRed:69.0/255.0 green:167.0/255.0 blue:252.0/255.0 alpha:1.0] lineWidth:3];
        }
    }
}

#pragma mark - private
//画坐标轴
- (void)drawTopCoordinateLine{
    //划线
    CGPoint startPoint = CGPointMake(self.minX, self.minY);
    CGPoint endPoint = CGPointMake(self.maxX, self.minY);
    [ZHDraw drawLine:UIGraphicsGetCurrentContext() startPoint:startPoint endPoint:endPoint color:[UIColor purpleColor] lineWidth:0.5];
    
    //标题
    if (self.topXModels.count > 0) {
        NSUInteger topXModelCount = self.topXModels.count;
        for (NSUInteger i = 0; i < topXModelCount; i ++) {
            ZHCoordinateTXModel *topXModel = self.topXModels[i];
            
            CoordinateTextAlignment topCoorAlignment;
            if (i == 0) {
                topCoorAlignment = CoordinateTextAlignmentLeftBottom;
            }else if (i == topXModelCount - 1){
                topCoorAlignment = CoordinateTextAlignmentRightBottom;
            }else{
                topCoorAlignment = CoordinateTextAlignmentBottomCenter;
            }
            
            CGFloat lineX = i * (self.limitW / (topXModelCount - 1)) + self.leftEdge;
            [ZHDraw drawCoordinateValue:CGPointMake(lineX, self.minY) title:topXModel.title titleColor:[UIColor blueColor] coordinateTextAlignment:topCoorAlignment];
        }
    }
}

- (void)drawBootomCoordinateLine{
    //划线
    CGPoint startPoint = CGPointMake(self.minX, self.maxY);
    CGPoint endPoint = CGPointMake(self.maxX, self.maxY);
    [ZHDraw drawLine:UIGraphicsGetCurrentContext() startPoint:startPoint endPoint:endPoint color:[UIColor redColor] lineWidth:0.5];
    
    //标题
    if (self.bottomXModels.count > 0) {
        NSUInteger bottomXModelCount = self.bottomXModels.count;
        for (NSUInteger i = 0; i < bottomXModelCount; i ++) {
            ZHCoordinateBXModel *bottomXModel = self.bottomXModels[i];
            
            CoordinateTextAlignment bottomCoorAlignment;
            if (i == 0) {
                bottomCoorAlignment = CoordinateTextAlignmentLeftTop;
            }else if (i == bottomXModelCount - 1){
                bottomCoorAlignment = CoordinateTextAlignmentRightTop;
            }else{
                bottomCoorAlignment = CoordinateTextAlignmentTopCenter;
            }
            CGFloat lineX = i * (self.limitW / (bottomXModelCount - 1)) + self.leftEdge;
            [ZHDraw drawCoordinateValue:CGPointMake(lineX, self.maxY) title:bottomXModel.title titleColor:[UIColor blueColor] coordinateTextAlignment:bottomCoorAlignment];
        }
    }
}

- (void)drawLeftCoordinateLine{
    //划线
    CGPoint startPoint = CGPointMake(self.minX, self.minY);
    CGPoint endPoint = CGPointMake(self.minX, self.maxY);
    [ZHDraw drawLine:UIGraphicsGetCurrentContext() startPoint:startPoint endPoint:endPoint color:[UIColor yellowColor] lineWidth:0.5];
    
    //标题
    if (self.leftYModels.count > 0) {
        NSUInteger leftYModelCount = self.leftYModels.count;
        for (NSUInteger i = 0; i < leftYModelCount; i ++) {
            ZHCoordinateLYModel *leftYModel = self.leftYModels[leftYModelCount - 1 - i];
            
            CoordinateTextAlignment leftCoorAlignment;
            if (i == 0) {
                leftCoorAlignment = CoordinateTextAlignmentRightTop;
            }else if (i == leftYModelCount - 1){
                leftCoorAlignment = CoordinateTextAlignmentRightBottom;
            }else{
                leftCoorAlignment = CoordinateTextAlignmentRightCenter;
            }
            CGFloat lineY = i * (self.limitH / (leftYModelCount - 1)) + self.topEdge;
            [ZHDraw drawCoordinateValue:CGPointMake(self.minX, lineY) title:leftYModel.title titleColor:[UIColor blueColor] coordinateTextAlignment:leftCoorAlignment];
        }
    }
}

- (void)drawRightCoordinateLine{
    //划线
    CGPoint startPoint = CGPointMake(self.maxX, self.minY);
    CGPoint endPoint = CGPointMake(self.maxX, self.maxY);
    [ZHDraw drawLine:UIGraphicsGetCurrentContext() startPoint:startPoint endPoint:endPoint color:[UIColor greenColor] lineWidth:0.5];
    
    //标题
    if (self.rightYModels.count > 0) {
        NSUInteger rightYModelCount = self.rightYModels.count;
        for (NSUInteger i = 0; i < rightYModelCount; i ++) {
            ZHCoordinateRYModel *rightYModel = self.rightYModels[rightYModelCount - 1 - i];
            
            CoordinateTextAlignment rightCoorAlignment;
            if (i == 0) {
                rightCoorAlignment = CoordinateTextAlignmentLeftTop;
            }else if (i == rightYModelCount - 1){
                rightCoorAlignment = CoordinateTextAlignmentLeftBottom;
            }else{
                rightCoorAlignment = CoordinateTextAlignmentLeftCenter;
            }
            CGFloat lineY = i * (self.limitH / (rightYModelCount - 1)) + self.topEdge;
            [ZHDraw drawCoordinateValue:CGPointMake(self.maxX, lineY) title:rightYModel.title titleColor:[UIColor blueColor] coordinateTextAlignment:rightCoorAlignment];
        }
    }
}

//分割线
- (void)drawSegmentLine{
    //横向分割线
    NSUInteger horizontalSegmentCount = self.leftYModels.count;
    for (NSInteger i = 1; i < horizontalSegmentCount - 1; i++) {
        CGFloat lineY = i * (self.limitH / (horizontalSegmentCount - 1)) + self.topEdge;
        CGPoint startPoint = CGPointMake(self.minX, lineY);
        CGPoint endPoint = CGPointMake(self.maxX, lineY);
        [ZHDraw drawLine:UIGraphicsGetCurrentContext() startPoint:startPoint endPoint:endPoint color:[UIColor orangeColor] lineWidth:0.5];
    }
    
    //纵向分割线
    NSUInteger verticalSegmentCount = self.bottomXModels.count;
    for (NSInteger i = 1; i < verticalSegmentCount - 1; i++) {
        CGFloat lineX = i * (self.limitW / (verticalSegmentCount - 1)) + self.leftEdge;
        CGPoint startPoint = CGPointMake(lineX, self.minY);
        CGPoint endPoint = CGPointMake(lineX, self.maxY);
        [ZHDraw drawLine:UIGraphicsGetCurrentContext() startPoint:startPoint endPoint:endPoint color:[UIColor cyanColor] lineWidth:0.5];
    }
}

//绘制分割区域阴影
- (void)drawSegmentAreaShadow{
    NSUInteger verticalSegmentCount = self.bottomXModels.count;
    //纵向分隔区域阴影
    NSArray *colorsArray = @[[UIColor colorWithRed:102.0/255.0 green:179.0/255.0 blue:255.0/255.0 alpha:0.1],[UIColor colorWithRed:102.0/255.0 green:179.0/255.0 blue:255.0/255.0 alpha:0.5]];
    
    for (NSInteger i = 0; i < verticalSegmentCount; i++) {
        
        if (i % 2 == 0) {
            //分隔区域距离跨度
            CGFloat distanceEachGap = (self.limitW / (verticalSegmentCount - 1));
            //距离坐标原点的距离跨度
            CGFloat distanceOrigin = distanceEachGap * i;
            
            NSMutableArray <NSValue *> *drawPoints = [NSMutableArray array];
            [drawPoints addObject:[NSValue valueWithCGPoint:CGPointMake(self.minX + distanceOrigin, self.maxY)]];
            [drawPoints addObject:[NSValue valueWithCGPoint:CGPointMake(self.minX + distanceOrigin, self.minY)]];
            [drawPoints addObject:[NSValue valueWithCGPoint:CGPointMake(self.minX + distanceOrigin + distanceEachGap, self.minY)]];
            [drawPoints addObject:[NSValue valueWithCGPoint:CGPointMake(self.minX + distanceOrigin + distanceEachGap, self.maxY)]];
            [drawPoints addObject:[NSValue valueWithCGPoint:CGPointMake(self.minX + distanceOrigin, self.maxY)]];
            
            //绘制
            CGFloat locations[] = {0.0, 1.0};
            [ZHDraw drawGradientArea:UIGraphicsGetCurrentContext() points:drawPoints colors:colorsArray locations:locations fillAlpha:0.5];
        }
    }
}

//横纵坐标轴标记数据
- (void)handleCoordinateXYModels:(void (^) (NSMutableArray <ZHCoordinateBXModel *> *bxModels, NSMutableArray <ZHCoordinateTXModel *> *txModels, NSMutableArray <ZHCoordinateLYModel *> *lyModels, NSMutableArray <ZHCoordinateRYModel *> *ryModels))completion{
    NSMutableArray <ZHDataPointModel *> *modelsArray = self.dataPointModels;
    if (modelsArray.count == 0) {
        if (completion) {
            completion(nil,nil,nil,nil);
        }
        return;
    }
    //遍历处理
    __block NSUInteger modelsArrayCount = modelsArray.count;
    
    //1.0：初始化 底X轴
    NSMutableArray <NSDate *> *bxNeedDateArray = [NSMutableArray array];
    //2.0：初始化 左Y轴
    __block float minValue = modelsArray[0].countNumber.floatValue;
    __block float maxValue = modelsArray[0].countNumber.floatValue;
    
    [modelsArray enumerateObjectsUsingBlock:^(ZHDataPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //2.0：筛选数据  X轴时间
        NSDate *objDate = obj.timeStampDate;
        if (idx == 0) {
            [bxNeedDateArray addObject:objDate];
        }
        if (idx < modelsArrayCount - 1) {
            NSDate *nextObjDate = modelsArray[idx + 1].timeStampDate;
            if (nextObjDate.day > objDate.day ||
                nextObjDate.month > objDate.month ||
                nextObjDate.year > objDate.year) {
                [bxNeedDateArray addObject:nextObjDate]; //下一个数据是第二天的数据
            }
        }else{
            [bxNeedDateArray addObject:[NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:bxNeedDateArray.lastObject]];  //延后一天
        }
        //2.1：筛选数据  Y轴最值
        float modelValue = obj.countNumber.floatValue;
        if (minValue > modelValue) {
            minValue = modelValue;
        }
        if (maxValue < modelValue) {
            maxValue = modelValue;
        }
    }];
    
    //3.0：底X轴数据模型
    NSMutableArray <ZHCoordinateBXModel *> *bxModels = [NSMutableArray array];
    for (NSDate *date in bxNeedDateArray) {
        ZHCoordinateBXModel *bxModel = [[ZHCoordinateBXModel alloc] init];
        bxModel.currentDate = [[NSString stringWithFormat:@"%@ 00:00:00",[date stringFromDateFormat:@"yyyy-MM-dd"]] dateFromStringFormat:@"yyyy-MM-dd HH:mm:ss"];
        bxModel.timeSpaceNumber = @(0);
        [bxModels addObject:bxModel];
    }
    //3.2：顶X轴数据模型
    NSMutableArray <ZHCoordinateTXModel *> *txModels = [NSMutableArray array];
    //3.3：左Y轴数据模型
    NSMutableArray <ZHCoordinateLYModel *> *lyModels = [NSMutableArray array];
    NSUInteger segmentCountLY = 5;//纵坐标标记点个数
    float eachGap = (maxValue - minValue) / (segmentCountLY - 1);//均等分割
    for (NSUInteger i = 0; i < segmentCountLY; i ++) {
        ZHCoordinateLYModel *model = [[ZHCoordinateLYModel alloc] init];
        model.countNumber = [NSNumber numberWithFloat:(minValue + i * eachGap)];
        [lyModels addObject:model];
    }
    //3.4：右Y轴数据模型
    NSMutableArray <ZHCoordinateRYModel *> *ryModels = [NSMutableArray array];
    
    if (completion) {
        completion(bxModels,txModels,lyModels,ryModels);
    }
}

//坐标实际点的位置
- (CGFloat)getDateAbscissaBXDistance:(NSDate *)bottomXDate originDate:(NSDate *)originDate xTimeSpaceEachPoint:(CGFloat)xTimeSpaceEachPoint{
    //X轴某一点距离原点的时间跨度
    NSTimeInterval pointTimeSpace = [bottomXDate timeIntervalSinceDate:originDate];
    //X轴某一点距离原点的距离跨度
    CGFloat pointDistanceSpace = pointTimeSpace / xTimeSpaceEachPoint;
    return self.minX + pointDistanceSpace;
}

- (CGFloat)getNumberOrdinateLYDistance:(NSNumber *)leftYNumber maxYValue:(CGFloat)maxYValue  yValueSpaceEachPoint:(CGFloat)yValueSpaceEachPoint{
    //Y轴某一点距离顶部X轴的数值跨度
    CGFloat pointValueSpace = maxYValue - leftYNumber.floatValue;
    //Y轴某一点距离顶部X轴的距离跨度
    CGFloat pointDistanceSpace = pointValueSpace / yValueSpaceEachPoint;
    return self.minY + pointDistanceSpace;
}

//计算点绘制坐标数据
- (NSMutableArray <NSValue *> *)getDrawCoordinatePoints{
    NSMutableArray <ZHDataPointModel *> *modelsArray = self.dataPointModels;
    if (modelsArray.count > 1){
        NSMutableArray <NSValue *> *points = [NSMutableArray array];
        
        if (self.bottomXModels.count == 0 || self.leftYModels.count == 0) {
            return nil;
        }
        //X轴
        CGFloat spaceWidthX = self.limitW; //距离跨度
        NSDate *firstDate = self.bottomXModels.firstObject.currentDate; //时间跨度
        NSDate *lastDate = self.bottomXModels.lastObject.currentDate;
        NSTimeInterval allTimeSpace = [lastDate timeIntervalSinceDate:firstDate];
        CGFloat xTimeSpaceEachPoint = allTimeSpace / spaceWidthX;  //一个像素点的时间跨度
        
        //Y轴
        CGFloat spaceWidthY = self.limitH;  //距离跨度
        CGFloat minYValue = self.leftYModels.firstObject.countNumber.floatValue; //数值跨度
        CGFloat maxYValue = self.leftYModels.lastObject.countNumber.floatValue;
        CGFloat allValueSpace = maxYValue - minYValue;
        CGFloat yValueSpaceEachPoint = allValueSpace / spaceWidthY; //一个像素点的数值跨度
        
        //计算绘制点
        for (ZHDataPointModel *model in modelsArray) {
            CGFloat drawX = [self getDateAbscissaBXDistance:model.timeStampDate originDate:firstDate xTimeSpaceEachPoint:xTimeSpaceEachPoint];
            CGFloat drawY = [self getNumberOrdinateLYDistance:model.countNumber maxYValue:maxYValue yValueSpaceEachPoint:yValueSpaceEachPoint];
            //            NSLog(@"--%f--%f-",drawX,drawY);
            [points addObject:[NSValue valueWithCGPoint:CGPointMake(drawX, drawY)]];
        }
        return points;
    }
    return nil;
}


@end
