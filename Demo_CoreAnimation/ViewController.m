//
//  ViewController.m
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/2/27.
//  Copyright © 2016年 xbgph. All rights reserved.
//

/****基本Animation知识****/
/* duration：动画的持续时间 .
 * repeatCount：动画的重复次数 .
 * repeatDuration：动画的重复时间 .
 * removedOnCompletion：默认为YES，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为kCAFillModeForwards .
 * fillMode：决定当前对象在非active时间段的行为.比如动画开始之前,动画结束之后 .
 * beginTime：可以用来设置动画延迟执行时间，若想延迟2s，就设置为CACurrentMediaTime()+2，                            CACurrentMediaTime()为图层的当前时间 .
 * timingFunction：速度控制函数，控制动画运行的节奏 .
 * delegate：动画代理
 */

#import "ViewController.h"

#import "POP.h"

#import "subViewController.h"

// 加载动画图
#import "XBLondingViews.h"

#import "XBLondingAnimationTwo.h"

// 按钮动画
#import "XBLoginAnimationButton.h"

// 跳转动画
#import "XBPageJumpAnimation.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong)XBLondingAnimationTwo *londingView;

@end

@implementation ViewController
{
    // 记录点击次数
    NSInteger _clickNumbers;
    
    // 判断是否登陆成功
    BOOL _isSiginSuccess;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor purpleColor];
    
    // 基本动画
//    [self initScaleLayer];
//    [self initGroupLayer];
//    [self initKeyframeAnimation];
    
    // Spring Animation
    //[self addSpringAnimationForButton];
    
    // 登录（动画）按钮
    [self siginButtonAniamtion];
    
    // 加载界面的动画1
    //[self londingViewAnimationOne];
    
    // 加载界面的动画2
    //[self londingViewAnimationTwo];
    
    
    
    
}

#pragma mark - 登录按钮
- (void)siginButtonAniamtion
{
    XBLoginAnimationButton *animButton = [[XBLoginAnimationButton alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.bounds) - 40 - 80, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    [animButton setBackgroundColor:[UIColor colorWithRed:1 green:0.f / 255.0 blue:128.0f / 255.0f alpha:1]];
    [self.view addSubview:animButton];
    [animButton setTitle:@"登陆" forState:UIControlStateNormal];
    [animButton addTarget:self action:@selector(presentVC:) forControlEvents:UIControlEventTouchUpInside];
    // 设置登陆成功
    _isSiginSuccess = YES;
}
- (void)presentVC:(XBLoginAnimationButton *)button
{
    typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_isSiginSuccess) {
            [button exitAnimationCompletion:^{
                NSLog(@"跳转");
                subViewController *subVC = [[subViewController alloc] init];
                subVC.transitioningDelegate = self;
                [weakSelf presentViewController:subVC animated:YES completion:nil];
            }];
        }else{
            [button errorReverAnimationCompletion:^{
                NSLog(@"不跳转");
                subViewController *subVC = [[subViewController alloc] init];
                subVC.transitioningDelegate = self;
                [weakSelf presentViewController:subVC animated:YES completion:nil];
            }];
        }
    });
}


#pragma mark - 加载动画1
- (void)londingViewAnimationOne
{
    XBLondingViews *londingView = [[XBLondingViews alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y - 50, 100, 100)];
    londingView.ballColor = [UIColor cyanColor];
    [self.view addSubview:londingView];
    
    typeof(self)weakSelf = self;
    [londingView showWhileExecultingBlock:^{
        [self doSomething];
    } complateBlock:^{
        subViewController *subVC = [[subViewController alloc] init];
        subVC.transitioningDelegate = self;
        [weakSelf presentViewController:subVC animated:YES completion:^{
        }];
    }];
}
#pragma mark - 加载动画2
- (void)londingViewAnimationTwo
{
    _londingView = [[XBLondingAnimationTwo alloc] initWithView:self.view andBlur:YES];
    [self.view addSubview:_londingView];
    
    typeof(self)weakSelf = self;
    
    [_londingView showWhileExecultingBlock:^{
        [self doSomething];
    } completion:^{
        subViewController *subVC = [[subViewController alloc] init];
        subVC.transitioningDelegate = self;
        [weakSelf presentViewController:subVC animated:YES completion:^{
        }];
    }];
}
- (void)doSomething
{
    sleep(5.0);
}


#pragma mark - 页面模态跳转自定义动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[XBPageJumpAnimation alloc] initWithTransitionDuration:0.6 startingAlpha:0.5 isBOOL:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[XBPageJumpAnimation alloc] initWithTransitionDuration:2 startingAlpha:0.0 isBOOL:NO];
}


// 基础动画1
- (void)initScaleLayer
{
    // 演员初始化
    CALayer *scaleLayer = [[CALayer alloc] init];
    scaleLayer.backgroundColor = [[UIColor cyanColor] CGColor];
    scaleLayer.cornerRadius = 10.0f;
    scaleLayer.frame = CGRectMake(20, 70, 50, 50);
    [self.view.layer addSublayer:scaleLayer];
    
    // 设定剧本
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:6.0 * M_PI];
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 5.0;
    
    // 开演
    [scaleLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    
}
// 基础动画2
- (void)initGroupLayer
{
    // 演员初始化
    CALayer *groupLayer = [[CALayer alloc] init];
    groupLayer.frame = CGRectMake(60, 340 + 100 + 50, 50, 50);
    groupLayer.cornerRadius = 10.0;
    groupLayer.backgroundColor = [[UIColor purpleColor] CGColor];
    [self.view.layer addSublayer:groupLayer];
    
    // 设定剧本
    // 剧本1
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 2.0;
    
    // 剧本2
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:groupLayer.position];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(300, groupLayer.position.y)];
    moveAnimation.autoreverses = YES;
    moveAnimation.repeatCount = MAXFLOAT;
    moveAnimation.duration = 2.0;
    
    // 剧本3
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:6.0 * M_PI];
    rotateAnimation.autoreverses = YES;
    rotateAnimation.repeatCount = MAXFLOAT;
    rotateAnimation.duration = 2.0;
    
    // 整合剧本
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.autoreverses = YES;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.duration = 2.0;
    animationGroup.animations = @[scaleAnimation, moveAnimation, rotateAnimation];
    
    // 开演
    [groupLayer addAnimation:animationGroup forKey:@"groupAnimation"];
    
}
// 基础动画3
- (void)initKeyframeAnimation
{
    // 演员初始化
    CALayer *keyFormLayer = [[CALayer alloc] init];
    keyFormLayer.backgroundColor = [[UIColor cyanColor] CGColor];
    keyFormLayer.frame = CGRectMake(20, 200, 50, 50);
    keyFormLayer.cornerRadius = 25.0;
    [self.view.layer addSublayer:keyFormLayer];
    
    // 设置剧本
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 设置关键帧位置，必须含起始与终止位置
    keyframeAnimation.values = @[[NSValue valueWithCGPoint:keyFormLayer.position], [NSValue valueWithCGPoint:CGPointMake(375 - 20, keyFormLayer.position.y)], [NSValue valueWithCGPoint:CGPointMake(375 - 20, keyFormLayer.position.y + 100)], [NSValue valueWithCGPoint:CGPointMake(keyFormLayer.position.x, keyFormLayer.position.y + 100)], [NSValue valueWithCGPoint:keyFormLayer.position]];
    // 设置每个关键帧的时长，如果不设置，则默认每个帧的时间=总时间duration/（values.count - 1）
    keyframeAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.8], [NSNumber numberWithFloat:1.0]];
    // 设置速度线性移动
    keyframeAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    keyframeAnimation.repeatCount = MAXFLOAT;
    keyframeAnimation.autoreverses = NO;
    keyframeAnimation.duration = 4;
    
    // 开演
    [keyFormLayer addAnimation:keyframeAnimation forKey:@"keyframeAnimation"];
}

// Spring Animation
- (void)addSpringAnimationForButton
{
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.frame = CGRectMake(20, self.view.bounds.size.height - 150, 150, 50);
    showBtn.backgroundColor = [UIColor cyanColor];
    [showBtn setTitle:@"点我啊" forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
}
- (void)showAnimation:(UIButton *)btn
{
    CGFloat fl = 1.3;
    _clickNumbers++;
    if (_clickNumbers % 2 != 0) {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.frame = CGRectMake(self.view.bounds.size.width - 200, self.view.bounds.size.height - 150, 150, 50);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseOut animations:^{
            btn.frame = CGRectMake(20, 100, 150, 50);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
