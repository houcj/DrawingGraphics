//
//  MyView.m
//  绘制图形
//
//  Created by Heejun on 16/10/12.
//  Copyright © 2016年 Heejun. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self drawRect:frame];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self simpleDraw];
}

- (void)simpleDraw {
    //cornerRadius  角的角度
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, 200, 200) cornerRadius:2];
    path.lineWidth = 5;
    
    UIColor *fillColor = [UIColor greenColor];
    [fillColor set];
    [path fill];
    
    UIColor *lineColor = [UIColor redColor];
    [lineColor set];
    [path stroke];
}

@end
