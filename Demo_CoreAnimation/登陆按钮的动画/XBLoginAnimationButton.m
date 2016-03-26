//
//  XBLoginAnimationButton.m
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/3/1.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import "XBLoginAnimationButton.h"

@interface XBLoginAnimationButton ()

@property (nonatomic, assign)CFTimeInterval shrinkDuration;

@property (nonatomic, strong)CAMediaTimingFunction *shrinkCurve;

@property (nonatomic, strong)CAMediaTimingFunction *expandCurve;

@property (nonatomic, copy)Completion block;

@property (nonatomic, strong)UIColor *color;


@end


@implementation XBLoginAnimationButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _spinerLayer = [[XBSpinerLayer alloc] initWithFrame:self.frame];
        _shrinkCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _expandCurve = [CAMediaTimingFunction functionWithControlPoints:0.95 :0.02 :1 :0.05];
        self.shrinkDuration = 0.1;
        [self.layer addSublayer:_spinerLayer];
        [self setup];
    }
    
    return self;
}

- (void)setCompletion:(Completion)completion
{
    _block = completion;
}

- (void)setup
{
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    self.clipsToBounds = YES;
    [self addTarget:self action:@selector(scaleToSmall) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault) forControlEvents:UIControlEventTouchDragExit];
    /*
     1.UIControlEventTouchDown
     单点触摸按下事件：用户点触屏幕，或者又有新手指落下的时候。
     2.UIControlEventTouchDownRepeat
     多点触摸按下事件，点触计数大于1：用户按下第二、三、或第四根手指的时候。
     3.UIControlEventTouchDragInside
     当一次触摸在控件窗口内拖动时。
     4.UIControlEventTouchDragOutside
     当一次触摸在控件窗口之外拖动时。
     5.UIControlEventTouchDragEnter
     当一次触摸从控件窗口之外拖动到内部时。
     6.UIControlEventTouchDragExit
     当一次触摸从控件窗口内部拖动到外部时。
     
     7.UIControlEventTouchUpInside
     所有在控件之内触摸抬起事件。
     8.UIControlEventTouchUpOutside
     所有在控件之外触摸抬起事件(点触必须开始与控件内部才会发送通知)。
     9.UIControlEventTouchCancel
     所有触摸取消事件，即一次触摸因为放上了太多手指而被取消，或者被上锁或者电话呼叫打断。
     10.UIControlEventTouchChanged
     当控件的值发生改变时，发送通知。用于滑块、分段控件、以及其他取值的控件。你可以配置滑块控件何时发送通知，在滑块被放下时发送，或者在被拖动时发送。
     11.UIControlEventEditingDidBegin
     当文本控件中开始编辑时发送通知。
     12.UIControlEventEditingChanged
     当文本控件中的文本被改变时发送通知。
     13.UIControlEventEditingDidEnd
     当文本控件中编辑结束时发送通知。
     14.UIControlEventEditingDidOnExit
     当文本控件内通过按下回车键（或等价行为）结束编辑时，发送通知。
     15.UIControlEventAlltouchEvents
     通知所有触摸事件。
     16.UIControlEventAllEditingEvents
     通知所有关于文本编辑的事件。
     17.UIControlEventAllEvents
     通知所有事件。
     ***/
}

#pragma mark - button Click
- (void)scaleToSmall
{
    typeof(self) __weak weakSelf = self;
    
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
    }];
    [self startAnimation];
}

- (void)scaleAnimation
{
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
}

- (void)scaleToDefault
{
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.4f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
}

- (void)startAnimation
{
    [self performSelector:@selector(revert) withObject:nil afterDelay:0.0f];
    [self.layer addSublayer:_spinerLayer];
    
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    shrinkAnimation.fromValue = @(CGRectGetWidth(self.bounds));
    shrinkAnimation.toValue = @(CGRectGetHeight(self.bounds));
    shrinkAnimation.duration = _shrinkDuration;
    shrinkAnimation.timingFunction = _shrinkCurve;
    shrinkAnimation.fillMode = kCAFillModeForwards;
    shrinkAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:shrinkAnimation forKey:shrinkAnimation.keyPath];
    [_spinerLayer showAnimation];
    [self setUserInteractionEnabled:NO];
}

- (void)errorReverAnimationCompletion:(Completion)completion
{
    _block = completion;
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    shrinkAnimation.fromValue = @(CGRectGetHeight(self.bounds));
    shrinkAnimation.toValue = @(CGRectGetWidth(self.bounds));
    shrinkAnimation.duration = _shrinkDuration;
    shrinkAnimation.timingFunction = _shrinkCurve;
    shrinkAnimation.fillMode = kCAFillModeForwards;
    shrinkAnimation.removedOnCompletion = NO;
    _color = self.backgroundColor;
    
    CABasicAnimation *backgroundColorAnim = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColorAnim.toValue = (__bridge id _Nullable)([UIColor redColor].CGColor);
    backgroundColorAnim.duration = 0.1f;
    backgroundColorAnim.timingFunction = _shrinkCurve;
    backgroundColorAnim.fillMode = kCAFillModeForwards;
    backgroundColorAnim.removedOnCompletion = NO;
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)], [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)], [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)], [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)], [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)], [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)], [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)], [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    keyFrame.delegate = self;
    self.layer.position = point;
    
    [self.layer addAnimation:backgroundColorAnim forKey:backgroundColorAnim.keyPath];
    [self.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
    [self.layer addAnimation:shrinkAnimation forKey:shrinkAnimation.keyPath];
    [_spinerLayer stopAnimation];
    [self setUserInteractionEnabled:YES];
}

- (void)exitAnimationCompletion:(Completion)completion
{
    _block = completion;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.fromValue = @(1.0);
    expandAnimation.toValue = @(33.0);
    expandAnimation.timingFunction = _expandCurve;
    expandAnimation.duration = 0.3;
    expandAnimation.delegate = self;
    expandAnimation.fillMode = kCAFillModeForwards;
    expandAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:expandAnimation forKey:expandAnimation.keyPath];
    [_spinerLayer stopAnimation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CABasicAnimation *cabAnim = (CABasicAnimation *)anim;
    if ([cabAnim.keyPath isEqualToString:@"transform.scale"]) {
        [self setUserInteractionEnabled:YES];
        if (_block) {
            _block();
        }
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(didStopAnimation) userInfo:nil repeats:nil];
    }
}

- (void)didStopAnimation
{
    [self.layer removeAllAnimations];
}

- (void)revert
{
    CABasicAnimation *banckgroundColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    banckgroundColor.toValue = (__bridge id _Nullable)(self.backgroundColor.CGColor);
    banckgroundColor.duration = 0.1f;
    banckgroundColor.timingFunction = _shrinkCurve;
    banckgroundColor.fillMode = kCAFillModeForwards;
    banckgroundColor.removedOnCompletion = NO;
    [self.layer addAnimation:banckgroundColor forKey:banckgroundColor.keyPath];
}


@end
