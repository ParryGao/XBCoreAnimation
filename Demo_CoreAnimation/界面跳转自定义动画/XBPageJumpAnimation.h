//
//  XBPageJumpAnimation.h
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/3/2.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XBPageJumpAnimation : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionDuration:(NSTimeInterval)transitionDuration startingAlpha:(CGFloat)startAlpha isBOOL:(BOOL)is;

@end
