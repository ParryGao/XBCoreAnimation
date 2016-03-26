//
//  XBSpinerLayer.h
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/3/1.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBSpinerLayer : CAShapeLayer

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame;

// 开始动画
- (void)showAnimation;

// 结束动画
- (void)stopAnimation;


@end
