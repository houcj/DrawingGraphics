//
//  UULineChart.m
//  UUChartDemo
//
//  Created by 2014-763 on 15/3/12.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "SCLineChart.h"
#import "SCColor.h"
#import "SCChartLabel.h"
#import "SCTool.h"

@implementation SCLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    CGFloat max = 0;
    CGFloat min = 1000000000;
    NSInteger rowCount = 0; // 自动计算每个图表适合的行数
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            CGFloat value = [valueString floatValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = max;
    
    if (_chooseRange.max!=_chooseRange.min) { // 自定义数值范围
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    } else { // 自动计算数值范围和合适的行数
        rowCount = [SCTool rowCountWithValueMax:_yValueMax] == 0 ? 5 : [SCTool rowCountWithValueMax:_yValueMax];
        _yValueMax = [SCTool rangeMaxWithValueMax:_yValueMax] == 0 ? 100 : [SCTool rangeMaxWithValueMax:_yValueMax];
        _yValueMin = 0;
    }
    
    float level = (_yValueMax-_yValueMin) /rowCount; // 每个区间的差值
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /rowCount; // 每个区间的高度
    for (int i=0; i<rowCount+1; i++) {
        SCChartLabel * label = [[SCChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
        label.text = [NSString stringWithFormat:@"%g",level * i+_yValueMin]; // 每个区间的值
        [self addSubview:label];
    }
    if ([super respondsToSelector:@selector(setMarkRange:)]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        
        [self addSubview:view];
    }
    //画横线
    for (int i=0; i<rowCount+1; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth,UULabelHeight+i*levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }
}


-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    CGFloat num = 0;
//    if (xLabels.count>=20) {
//        num=20.0;
//    }else if (xLabels.count<=1){
//        num=1.0;
//    }else{
//    }
    num = xLabels.count;
    _xLabelWidth = (self.frame.size.width - UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        SCChartLabel * label = [[SCChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = labelText;
        [self addSubview:label];
    }
    
    //画竖线
    for (int i=0; i<xLabels.count+1; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,UULabelHeight)];
        [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-2*UULabelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [self.layer addSublayer:shapeLayer];
    }
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}
- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}
- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}
- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 1.0;
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry firstObject] floatValue];
        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
        
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]> 0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];
        
        //  折线图增加远点以及（最大值，0）
//        [progressline moveToPoint:CGPointMake(UUYLabelwidth, self.frame.size.height - UULabelHeight*2)];
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        //  遮罩贝塞尔曲线
        UIBezierPath *progressline2 = [UIBezierPath bezierPath];
        [progressline2 moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline2 setLineWidth:0.0];
        [progressline2 setLineCapStyle:kCGLineCapRound];
        [progressline2 setLineJoinStyle:kCGLineJoinRound];
        
        /*cj_10_10*/
        NSMutableArray *muarr = [NSMutableArray arrayWithArray:childAry];
        [muarr insertObject:[childAry objectAtIndex:(int)(childAry.count - 1)] atIndex:childAry.count];
        childAry = [NSArray arrayWithArray:muarr];
        /*cj*/
        
        NSInteger index = 0;
        /*cj_10_10*/
        CGPoint point1 = CGPointMake(xPosition - _xLabelWidth/2, chartCavanHeight + UULabelHeight);
        [progressline moveToPoint:point1];
        [progressline2 moveToPoint:point1];
        /*cj*/
        
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);

            /*cj_10_10*/
            if (index == 0) {
                
                point1 = CGPointMake(xPosition, chartCavanHeight - grade*chartCavanHeight + UULabelHeight);
                [progressline addLineToPoint:point1];
                [progressline2 addLineToPoint:point1];
            };
            /*cj_10_10*/
            
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                
                
                
                [progressline addLineToPoint:point];
                [progressline2 addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
                //                [progressline stroke];
            }
            index += 1;
        }
        //  //  //  //  //
        
        [progressline2 addLineToPoint:CGPointMake((childAry.count * _xLabelWidth) - (_xLabelWidth / 2) + UUYLabelwidth, self.frame.size.height-2*UULabelHeight)];
        [progressline2 addLineToPoint:CGPointMake(_xLabelWidth / 2 + UUYLabelwidth, self.frame.size.height-2*UULabelHeight)];
    
        //  拼接最后一个点 即起始点
//        [progressline2 addLineToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        
        
        CAShapeLayer *shadeLayer = [CAShapeLayer layer];
        shadeLayer.path = progressline2.CGPath;
        shadeLayer.fillColor = [UIColor clearColor].CGColor;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(UUYLabelwidth + _xLabelWidth / 2, UULabelHeight, 0, self.frame.size.height-2*UULabelHeight);
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.cornerRadius = 5;
        gradientLayer.masksToBounds = YES;
//        gradientLayer.backgroundColor = [UIColor blackColor].CGColor;
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:72.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:237/255.0 green:246/255.0 blue:253/255.0 alpha:0.5].CGColor];
        
        gradientLayer.locations = @[@(0.0f)];
        
        CALayer *baseLayer = [CALayer layer];
        [baseLayer addSublayer:gradientLayer];
        [baseLayer setMask:shadeLayer];
        
        [self.layer addSublayer:baseLayer];   //  **添加遮罩层
        
        CABasicAnimation *anmi1 = [CABasicAnimation animation];
        anmi1.keyPath = @"bounds";
        anmi1.duration = 5.2;
        anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anmi1.fillMode = kCAFillModeForwards;
        anmi1.autoreverses = NO;
        anmi1.removedOnCompletion = NO;
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [SCGreen CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count * 0.2;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        
        CABasicAnimation *pathAnimation2 = [CABasicAnimation animationWithKeyPath:@"bounds"];
        pathAnimation2.duration = childAry.count * 0.2;
        pathAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation2.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, (self.frame.size.width - UUYLabelwidth - _xLabelWidth) * 2, self.frame.size.height-2*UULabelHeight)];
        
        pathAnimation2.autoreverses = NO;
        pathAnimation2.fillMode = kCAFillModeForwards;
        pathAnimation2.removedOnCompletion = NO;
        
        [gradientLayer addAnimation:pathAnimation2 forKey:@"boundsAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 8;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:SCGreen.CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:SCGreen;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = view.backgroundColor;
        label.text = [NSString stringWithFormat:@"%d",(int)value];
        [self addSubview:label];
    }
    
    //    [self addSubview:view];
}

+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font
{
    NSInteger ch;
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    ch = size.height;
    
    return size;
}


@end
