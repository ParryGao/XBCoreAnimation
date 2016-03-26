//
//  XBSpinerLayer.m
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/3/1.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import "XBSpinerLayer.h"

@implementation XBSpinerLayer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        CGFloat radius = (CGRectGetHeight(frame) / 2 ) * 0.5;
        self.frame = CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame));
        CGPoint center = CGPointMake(CGRectGetHeight(frame) / 2, CGRectGetMidY(self.bounds));
        CGFloat startAngle = 0; // M_PI_2 = M_PI / 2
        CGFloat endAngle = M_PI * 2;
        BOOL clockwise = YES; // clockwise 顺时针
        self.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise].CGPath;
        self.fillColor = nil;
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.lineWidth = 1.0;
        
        self.strokeEnd = 0.5;
        // 隐藏
        self.hidden = YES;
    }
    
    return  self;
}

- (void)showAnimation
{
    // 显示
    self.hidden = NO;
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.fromValue = 0;
    rotation.toValue = @(M_PI * 2);
    rotation.duration = 0.5;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    /**
     * kCAMediaTimingFunctionLinear 线性（匀速）|
     * kCAMediaTimingFunctionEaseIn 先慢|
     * kCAMediaTimingFunctionEaseOut 后慢|
     * kCAMediaTimingFunctionEaseInEaseOut 先慢 后慢 中间快|
     * kCAMediaTimingFunctionDefault 默认|
     */
    rotation.repeatCount = HUGE; // HUGE = MAXFLOAT 无限大
    rotation.fillMode = kCAFillModeForwards;
    rotation.removedOnCompletion = NO;
    [self addAnimation:rotation forKey:rotation.keyPath];
}

- (void)stopAnimation
{
    self.hidden = YES;
    // 移除动画
    [self removeAllAnimations];
}

@end
