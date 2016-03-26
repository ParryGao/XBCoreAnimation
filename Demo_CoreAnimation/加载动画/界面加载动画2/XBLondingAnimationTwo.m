//
//  XBLondingAnimationTwo.m
//  Demo_CoreAnimation
//
//  Created by xbgph on 16/3/17.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import "XBLondingAnimationTwo.h"

#import "UIColor+flat.h"

@interface XBLondingAnimationTwo ()
{
    // target, methed, object and block
    id targetForExectiong;
    SEL methodForExecting;
    id objectForExecting;
    dispatch_block_t completionBlock;
}

@property (nonatomic, strong)UIView *container;
@property (nonatomic, strong)CALayer *containerDotLayer;
@property (nonatomic, strong)NSMutableArray *arrThreeDots;
// 基本动画
@property (nonatomic, strong)CABasicAnimation *rotateAnimation;
// 关键帧动画
@property (nonatomic, strong)CAKeyframeAnimation *glowAnimation;
@property (nonatomic, strong)CAKeyframeAnimation *colorGlowAnimation;
@property (nonatomic, strong)CAKeyframeAnimation *colorDotAnimation;
// 组合动画
@property (nonatomic, strong)CAAnimationGroup *groupAnimation;

- (void)commonInit;
- (void)initBackGroundBlur:(BOOL)blur;
- (void)initThreeDot;
- (void)initAnimation;

@end



@implementation XBLondingAnimationTwo


// 初始化方法
- (instancetype)initWithView:(UIView *)view andBlur:(BOOL)isBlur
{
    self = [super initWithFrame:view.bounds];
    if (self) {
        _container = view;
        
        [self commonInit]; //初始化一些属性
        [self initBackGroundBlur:isBlur];  // 加载背景
        [self initThreeDot]; //加载三个小球
        [self initAnimation]; // 加载动画
    }
    return self;
}

- (void)commonInit
{
    _isShowing = NO;
    _arrThreeDots = [NSMutableArray array];
}

- (void)initBackGroundBlur:(BOOL)blur
{
    self.backgroundColor = [UIColor flatWetAsphaltColor];
}

- (void)initThreeDot
{
    // 创建三个球的整体
    _containerDotLayer = [CALayer layer];
    _containerDotLayer.frame = CGRectMake(0, 0, 50, 50);
    _containerDotLayer.backgroundColor = [UIColor clearColor].CGColor;
    _containerDotLayer.position = self.center;
    
    for (NSInteger i = 0; i < 3; i++) {
        // 创建每一个球
        CALayer *dot = [CALayer layer];
        CGRect frame;
        
        switch (i) {
            case 0:
                frame = CGRectMake(15, 0, 20, 20);
                break;
            case 1:
                frame = CGRectMake(0, 29.5, 20, 20);
                break;
            case 2:
                frame = CGRectMake(30.5, 29.5, 20, 20);
                break;
            default:
                break;
        }
        
        dot.frame = frame;
        dot.backgroundColor = [UIColor flatCarrotColor].CGColor;
        dot.cornerRadius = 10.0;
        // 设置阴影
        dot.shadowColor = [UIColor flatCloudColor].CGColor;
        dot.shadowOpacity = 1.0;
        dot.shadowOffset = CGSizeMake(0, 0);
        dot.shadowRadius = 10.0;
        
        // 添加到父视图
        [_containerDotLayer addSublayer:dot];
        [_arrThreeDots addObject:dot];
    }
    
    [self.layer addSublayer:_containerDotLayer];
    
}

- (void)initAnimation
{
    // 三个小球整体的旋转动画
    _rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    _rotateAnimation.repeatCount = HUGE_VAL;
    _rotateAnimation.duration = 1.5;
    _rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    _rotateAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];

    
    // 调整shadowRadius的值而产生的动画
    _glowAnimation = [CAKeyframeAnimation animationWithKeyPath:@"shadowRadius"];
    // 时间点
    _glowAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.0f]];
    // 时间点的值
    _glowAnimation.values = @[[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:20.0f], [NSNumber numberWithFloat:5.0f]];
    _glowAnimation.duration = 1.5f;
    _glowAnimation.repeatCount = HUGE_VAL;
    
    // 调整shadowColor的值而产生的动画
    _colorGlowAnimation = [CAKeyframeAnimation animationWithKeyPath:@"shadowColor"];
    _colorGlowAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.0f]];
    _colorGlowAnimation.values = @[(id)[UIColor colorWithHexCode:@"#ff0000"].CGColor, (id)[UIColor colorWithHexCode:@"#00ff00"].CGColor, (id)[UIColor colorWithHexCode:@"#ff0000"].CGColor];
    _colorGlowAnimation.repeatCount  =HUGE_VAL;
    _colorGlowAnimation.duration = 1.5f;
    
    // 小球的背景颜色变化
    _colorDotAnimation = [CAKeyframeAnimation animationWithKeyPath:@"background"];
    _colorDotAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.0f]];
    _colorDotAnimation.values = @[(id)[UIColor colorWithHexCode:@"#ff0000"].CGColor, (id)[UIColor colorWithHexCode:@"#00ff00"].CGColor, (id)[UIColor colorWithHexCode:@"#ff0000"].CGColor];
    _colorDotAnimation.repeatCount = HUGE_VAL;
    _colorDotAnimation.duration = 1.5f;
    
    // 小球自身的组合动画
    _groupAnimation = [CAAnimationGroup animation];
    _groupAnimation.duration = 1.5f;
    _groupAnimation.repeatCount = HUGE_VAL;
    _groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    _groupAnimation.animations = @[_glowAnimation, _colorGlowAnimation, _colorDotAnimation];

}

- (void)show
{
    if (_isShowing) {
        return;
    }
    _isShowing = YES;
    
    [_containerDotLayer addAnimation:_rotateAnimation forKey:@"transform.rotation"];
    
    for (CALayer *dot in _arrThreeDots) {
        [dot addAnimation:_glowAnimation forKey:@"shadowRadius"];
    }
}

- (void)dismiss
{
    if (!_isShowing) {
        return;
    }
    _isShowing = NO;
    
    // 移除所有动画
    for (CALayer *dot in _arrThreeDots) {
        [dot removeAllAnimations];
    }
    
    [_containerDotLayer removeAllAnimations];
}

- (void)showWhileExecultingBlock:(dispatch_block_t)block
{
    [self showWhileExecultingBlock:block completion:nil];
}

- (void)showWhileExecultingBlock:(dispatch_block_t)block completion:(dispatch_block_t)completion
{
    if (block != nil) {
        [self show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // 动画期间执行任务
            block();
            
            // 任务执行完成后,结束动画
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
                // 结束加载动画，去除动画
                [self dismiss];
            });
        });
    }
}

- (void)showWhileExecultingSelector:(SEL)selector onTarget:(id)target withObject:(id)object
{
    [self showWhileExecultingSelector:selector onTarget:target withObject:object completion:nil];
}

- (void)showWhileExecultingSelector:(SEL)selector onTarget:(id)target withObject:(id)object completion:(dispatch_block_t)completion
{
    // 动画中的点击事件
    if ([target respondsToSelector:selector]) {
        methodForExecting = selector;
        targetForExectiong = target;
        objectForExecting = object;
        completionBlock = completion;
    }
}



@end
