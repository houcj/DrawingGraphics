//
//  ViewController.m
//  绘制图形
//
//  Created by Heejun on 16/10/10.
//  Copyright © 2016年 Heejun. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"

@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *layer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    MyView *myView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    [self.view addSubview:myView];
    
    
    self.layer = [CAShapeLayer layer];
    self.layer.fillColor = [UIColor clearColor].CGColor;
    self.layer.lineWidth = 20.0f;
    self.layer.lineCap = kCALineCapRound;
    self.layer.lineJoin = kCALineJoinRound;
    self.layer.strokeColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:80 startAngle:0 endAngle:2*M_PI clockwise:NO];
    
    self.layer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
//    animation.toValue = @(1.0);
    self.layer.autoreverses = NO;
    animation.duration = 3.0;
    
    [self.layer addAnimation:animation forKey:nil];
    animation.delegate = self;
    
    int count = 16;
    for (int i = 0; i < count; i++) {
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.strokeColor = [UIColor yellowColor].CGColor;
        lineLayer.lineJoin = kCALineJoinRound;
        lineLayer.lineCap = kCALineCapRound;
        lineLayer.lineWidth = 15.0f;
        [self.view.layer addSublayer:lineLayer];
        
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        int x = 200 + 110*cos(2*M_PI/count*i);
        int y = 200 - 110*sin(2*M_PI/count*i);
        int len = 50;
        [path1 moveToPoint:CGPointMake(x, y)];
        [path1 addLineToPoint:CGPointMake(x + len*cos(2*M_PI/count*i), y - len*sin(2*M_PI/count*i))];
        lineLayer.path = path1.CGPath;
        [lineLayer addAnimation:animation forKey:nil];
    }
    
//    UIBezierPath *path = [[UIBezierPath alloc] init];
    //从哪个点开始画图
//    [path moveToPoint:CGPointMake(100, 50)];
//    [path addArcWithCenter:CGPointMake(80, 50) radius:20.0 startAngle:0 endAngle:2*M_PI clockwise:YES];//圆形
    
//    [path addLineToPoint:CGPointMake(300, 70)];
//
//    [path addLineToPoint:CGPointMake(300, 170)];
//    [path moveToPoint:CGPointMake(300, 170)];
//    
//    [path addQuadCurveToPoint:CGPointMake(400, 400) controlPoint:CGPointMake(200, 200)];
    
    
//    /*三个圆角一个直角的矩形*/
//    CGRect rect = CGRectMake(50, 50, 100, 100);
//    CGSize radii = CGSizeMake(20, 20);
//    UIRectCorner corners = UIRectCornerTopRight|UIRectCornerTopLeft|UIRectCornerBottomLeft;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
//    
//    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
//    shapeLayer.strokeColor = [UIColor redColor].CGColor;
//    shapeLayer.fillColor = [UIColor greenColor].CGColor;//图形内部的填充颜色
//    shapeLayer.lineWidth = 2;
//    shapeLayer.lineJoin = kCALineJoinMiter;//连接点的风格
//    shapeLayer.lineCap = kCALineCapRound;
//    shapeLayer.path = path.CGPath;
//    [self.view.layer addSublayer:shapeLayer];
    
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.layer.fillColor = [UIColor redColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
