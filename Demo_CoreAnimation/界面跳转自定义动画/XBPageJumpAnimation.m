//
//  XBPageJumpAnimation.m
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/3/2.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import "XBPageJumpAnimation.h"

@interface XBPageJumpAnimation ()

@property (nonatomic, assign)NSTimeInterval transitionDuration;

@property (nonatomic, assign)CGFloat startingAlpha;

@property (nonatomic, assign)BOOL is;

@property (nonatomic, strong)id transitionContext;

@end


@implementation XBPageJumpAnimation

- (instancetype)initWithTransitionDuration:(NSTimeInterval)transitionDuration startingAlpha:(CGFloat)startAlpha isBOOL:(BOOL)is
{
    self = [super init];
    if (self) {
        _transitionDuration = transitionDuration;
        _startingAlpha = startAlpha;
        _is = is;
    }
    
    return self;
}

// 1.跳转时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _transitionDuration;
}

// 2.跳转动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    // 正向跳转
    if (_is) {
        toView.alpha = _startingAlpha;
        fromView.alpha = 1.0f;
        [containerView addSubview:toView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.alpha = 1.0f;
            fromView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            fromView.alpha = 1.0;
            // 这一句必须加，完成动画后会清理上下文
            [transitionContext completeTransition:YES];
        }];
    }else{
        // 逆向跳转
        fromView.alpha = 1.0f;
        toView.alpha = 0.0;
        fromView.transform = CGAffineTransformMakeScale(1, 1);
        [containerView addSubview:toView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromView.transform = CGAffineTransformMakeScale(3, 3);
            fromView.alpha = 0.0f;
            toView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            fromView.alpha = 1.0f;
            [transitionContext completeTransition:YES];
        }];
    
    }
}




@end
