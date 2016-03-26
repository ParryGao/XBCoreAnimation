//
//  XBLondingViews.m
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/2/29.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import "XBLondingViews.h"

// 该视图的坐标和宽高
#define ORIGIN_X  self.frame.origin.x
#define ORIGIN_Y  self.frame.origin.y
#define WIDTH     self.frame.size.width
#define HEIGHT    self.frame.size.height
// 球的半径
#define BALL_RADIUS  20

@interface XBLondingViews ()
/**
 * 第一个球
 */
@property (nonatomic, strong) UIView *ball_1;

/**
 * 第二个球
 */
@property (nonatomic, strong) UIView *ball_2;

/**
 * 第三个球
 */
@property (nonatomic, strong) UIView *ball_3;

@end

@implementation XBLondingViews
{
    // 是否正在动画
    BOOL _isShowing;
}

// 重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isShowing = NO;
//        // 添加模糊背景
//        UIVisualEffectView *backgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
//        backgView.alpha = 0.8;
//        backgView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
//        backgView.layer.cornerRadius = BALL_RADIUS / 2;
//        backgView.clipsToBounds = YES;
//        [self addSubview:backgView];
    }
    
    return self;
}

- (UIColor *)ballColor
{
    if (_ballColor) {
        return _ballColor;
    }
    return [UIColor cyanColor];
}

// 显示动画
- (void)showLongAnimationView
{
    if (_isShowing) {
        return;
    }
    
    CGFloat ball_Y = HEIGHT / 2 - BALL_RADIUS * 0.5;
    
    // 初始化三个圆 (演员)
    UIView *ball_1 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 2 - BALL_RADIUS * 1.5, ball_Y, BALL_RADIUS, BALL_RADIUS)];
    ball_1.layer.cornerRadius = BALL_RADIUS / 2.0;
    ball_1.backgroundColor = self.ballColor;
    [self addSubview:ball_1];
    self.ball_1 = ball_1;
    
    UIView *ball_2 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 2 - BALL_RADIUS * 0.5, ball_Y, BALL_RADIUS, BALL_RADIUS)];
    ball_2.layer.cornerRadius = BALL_RADIUS / 2;
    ball_2.backgroundColor = self.ballColor;
    [self addSubview:ball_2];
    self.ball_2 = ball_2;
    
    UIView *ball_3 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 2 + BALL_RADIUS * 0.5, ball_Y, BALL_RADIUS, BALL_RADIUS)];
    ball_3.layer.cornerRadius = BALL_RADIUS / 2;
    ball_3.backgroundColor = self.ballColor;
    [self addSubview:ball_3];
    self.ball_3 = ball_3;
    
    // 设置动画
    [self rotationAnimation];
    
}

- (void)rotationAnimation
{
    // 1.1 所有圆围绕中心
    CGPoint centerPoint = CGPointMake(WIDTH / 2, HEIGHT / 2);
    // 1.2 第一个圆的中心
    CGPoint centerBall_1 = CGPointMake(WIDTH / 2 - BALL_RADIUS, HEIGHT / 2);
    // 1.3 第三个圆的中心
    CGPoint centerBall_3 = CGPointMake(WIDTH / 2 + BALL_RADIUS, HEIGHT / 2);
    /****************************** 设 置 剧 本  *******************************/
    /**
     * 2.1 第一个圆的曲线
     */
    UIBezierPath *path_ball_1 = [UIBezierPath bezierPath];
    [path_ball_1 moveToPoint:centerBall_1];
    /**
     * center：圆心的坐标
     * radius：半径
     * startAngle：起始的弧度
     * endAngle：圆弧结束的弧度
     * clockwise：YES为顺时针，No为逆时针
     */
    [path_ball_1 addArcWithCenter:centerPoint radius:BALL_RADIUS startAngle:M_PI endAngle:M_PI * 2 clockwise:NO];
    UIBezierPath *path_ball_1_1 = [UIBezierPath bezierPath];
    [path_ball_1_1 addArcWithCenter:centerPoint radius:BALL_RADIUS startAngle:M_PI * 2 endAngle:M_PI clockwise:NO];
    
    // 拼接两条路径
    [path_ball_1 appendPath:path_ball_1_1];
    
    /**
     * 2.2 第一个圆的动画
     */
    CAKeyframeAnimation *animation_ball_1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation_ball_1.path = path_ball_1.CGPath;
    animation_ball_1.removedOnCompletion = NO; // removedOnCompletion设置为NO,要不然fillMode不起作用.
    animation_ball_1.fillMode = kCAFillModeForwards;
    /**
     * 扩展
     * 1.fillMode的作用就是决定当前对象过了非active时间段的行为. 比如动画开始之前,动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.
     * 2.kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
     * 3.kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
     * 4.kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
     * 5.kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
     */
    animation_ball_1.repeatCount = 1;
    animation_ball_1.calculationMode = kCAAnimationCubic; // calculationMode属性定义了计算动画定时的算法。该属性值会影响其他与定时相关属性的使用方式。
    animation_ball_1.duration = 1.4;
    animation_ball_1.delegate = self;
    animation_ball_1.autoreverses = NO; // 动画结束时是否执行逆动画
    animation_ball_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 添加动画
    [self.ball_1.layer addAnimation:animation_ball_1 forKey:@"animation1"];
    
    /**
     *  3.1第3个圆的曲线
     */
    UIBezierPath *path_ball_3 = [UIBezierPath bezierPath];
    [path_ball_3 moveToPoint:centerBall_3]; // 起始状态
    // 设置曲线
    [path_ball_3 addArcWithCenter:centerPoint radius:BALL_RADIUS startAngle:0 endAngle:M_PI clockwise:NO];
    UIBezierPath *path_ball_3_1 = [UIBezierPath bezierPath];
    [path_ball_3 addArcWithCenter:centerPoint radius:BALL_RADIUS startAngle:M_PI endAngle:M_PI * 2 clockwise:NO];
    // 拼接
    [path_ball_3 appendPath:path_ball_3_1];
    
    /**
     * 3.2第三个圆的动画
     */
    CAKeyframeAnimation *animation_ball_3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation_ball_3.path = path_ball_3.CGPath;
    animation_ball_3.removedOnCompletion = NO;
    animation_ball_3.fillMode = kCAFillModeForwards;
    animation_ball_3.calculationMode = kCAAnimationCubic;
    animation_ball_3.repeatCount = 1;
    animation_ball_3.duration = 1.4;
    // animation_ball_3.delegate = self;
    animation_ball_3.autoreverses = NO;
    animation_ball_3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 添加动画
    [self.ball_3.layer addAnimation:animation_ball_3 forKey:@"animation2"];
    
}

// 动画已经结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self rotationAnimation];
}

// 已经开始
- (void)animationDidStart:(CAAnimation *)anim
{
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        // CGAffineTransform,首先我查到的这个类其实就是一个变换，一个3*3矩阵的变换
        self.ball_1.transform = CGAffineTransformMakeTranslation(-BALL_RADIUS, 0);
        self.ball_1.transform = CGAffineTransformScale(self.ball_1.transform, 0.7, 0.7);
        
        self.ball_3.transform = CGAffineTransformMakeTranslation(BALL_RADIUS, 0);
        self.ball_3.transform = CGAffineTransformScale(self.ball_3.transform, 0.7, 0.7);
        
        
        self.ball_2.transform = CGAffineTransformScale(self.ball_2.transform, 0.7, 0.7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.ball_1.transform = CGAffineTransformIdentity; // 重新回到动画前状态，相当于初始化
            self.ball_2.transform = CGAffineTransformIdentity;
            self.ball_3.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }];
}

// 移除动画
- (void)dismissLongAnimationView
{
    if (!_isShowing) {
        return;
    }
    
    [self.layer removeAllAnimations];
}


- (void)showWhileExecultingBlock:(dispatch_block_t)block complateBlock:(dispatch_block_t)complate
{
    if (block != nil) {
        [self showLongAnimationView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0.0), ^{
            block();
            
            // 返回主队列执行刷新UI，结束动画
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissLongAnimationView];
                complate();
            });
        });
    }
   
}



@end
