//
//  ZHCoordinateView.h
//  LineTest
//
//  Created by 李保征 on 2017/10/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHDataPointModel.h"

#import "ZHCoordinateBXModel.h"
#import "ZHCoordinateTXModel.h"
#import "ZHCoordinateLYModel.h"
#import "ZHCoordinateRYModel.h"

#import "NSString+Extension.h"
#import "NSDate+Extension.h"

#import "ZHDraw.h"

@interface ZHCoordinateView : UIView

@property (nonatomic,assign) CGFloat selfWidth;
@property (nonatomic,assign) CGFloat selfHeight;
//上下左右边缘空闲宽度
@property (nonatomic,assign) CGFloat leftEdge;
@property (nonatomic,assign) CGFloat rightEdge;
@property (nonatomic,assign) CGFloat topEdge;
@property (nonatomic,assign) CGFloat bottomEdge;

@property (nonatomic,assign,readonly) CGFloat minX;
@property (nonatomic,assign,readonly) CGFloat maxX;
@property (nonatomic,assign,readonly) CGFloat minY;
@property (nonatomic,assign,readonly) CGFloat maxY;
@property (nonatomic,assign,readonly) CGFloat limitH;
@property (nonatomic,assign,readonly) CGFloat limitW;

//特殊点位置
- (CGPoint)pointLeftYMidPoint;  //左Y轴的中点
- (CGPoint)pointRightYMidPoint;  //右Y轴的中点
- (CGPoint)pointBottomXMidPoint;  //底X轴的中点
- (CGPoint)pointLeftOrigin;  //左坐标原点
- (CGPoint)pointRightOrigin;  //右坐标原点

//坐标单位类型
typedef NS_ENUM(NSInteger, ZHCoordinateBXUnitType) {  //底X轴
    ZHCoordinateBXUnitTypeDate      = 0,
    ZHCoordinateBXUnitTypeNumber     = 1
};
typedef NS_ENUM(NSInteger, ZHCoordinateLYUnitType) {  //左Y轴
    ZHCoordinateLYUnitTypeDate      = 0,
    ZHCoordinateLYUnitTypeNumber     = 1
};
@property (nonatomic,assign) ZHCoordinateBXUnitType zhCoordinateBXUnitType;
@property (nonatomic,assign) ZHCoordinateLYUnitType zhCoordinateLYUnitType;

//原始数据点
@property (nonatomic,retain) NSMutableArray <ZHDataPointModel *> *dataPointModels;

//坐标轴标记数据
@property (nonatomic,retain) NSMutableArray <ZHCoordinateBXModel *> *bottomXModels;
@property (nonatomic,retain) NSMutableArray <ZHCoordinateTXModel *> *topXModels;
@property (nonatomic,retain) NSMutableArray <ZHCoordinateLYModel *> *leftYModels;
@property (nonatomic,retain) NSMutableArray <ZHCoordinateRYModel *> *rightYModels;

//绘制数据点
@property (nonatomic,retain) NSMutableArray <NSValue *> *drawPointModels;

//重新绘制
- (void)reDrawRect;

@end
