//
//  XBLondingAnimationTwo.h
//  Demo_CoreAnimation
//
//  Created by xbgph on 16/3/17.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBLondingAnimationTwo : UIView

@property (nonatomic, assign)BOOL isShowing;

- (instancetype)initWithView:(UIView *)view andBlur:(BOOL)isBlur;

// 显示动画
- (void)show;

// 去除动画
- (void)dismiss;

// 正在执行时（Execulte:执行）
- (void)showWhileExecultingBlock:(dispatch_block_t)block;

- (void)showWhileExecultingBlock:(dispatch_block_t)block completion:(dispatch_block_t)completion;

- (void)showWhileExecultingSelector:(SEL)selector onTarget:(id)target withObject:(id)object;

- (void)showWhileExecultingSelector:(SEL)selector onTarget:(id)target withObject:(id)object completion:(dispatch_block_t)completion;



@end
