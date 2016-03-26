//
//  XBLoginAnimationButton.h
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/3/1.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XBSpinerLayer.h" // 自旋边框

typedef void(^Completion)();

@interface XBLoginAnimationButton : UIButton

@property (nonatomic, strong)XBSpinerLayer *spinerLayer;

- (void)setCompletion:(Completion)completion;

- (void)startAnimation;

- (void)errorReverAnimationCompletion:(Completion)completion;

- (void)exitAnimationCompletion:(Completion)completion;

@end
