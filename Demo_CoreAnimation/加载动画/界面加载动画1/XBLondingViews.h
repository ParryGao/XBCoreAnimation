//
//  XBLondingViews.h
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/2/29.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBLondingViews : UIView

/**
 * 球的颜色
 */
@property (nonatomic, strong)UIColor *ballColor;

/**
 * 展示加载动画
 */
- (void)showLongAnimationView;

/**
 * 关闭加载动画
 */
- (void)dismissLongAnimationView;

// 正在进行动画的时候进行的事情，和结束做的事情
- (void)showWhileExecultingBlock:(dispatch_block_t)block complateBlock:(dispatch_block_t)complate;


@end
