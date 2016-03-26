//
//  subViewController.m
//  Demo_CoreAnimation
//
//  Created by yeetai on 16/3/1.
//  Copyright © 2016年 xbgph. All rights reserved.
//

#import "subViewController.h"


@interface subViewController ()

@property (nonatomic, strong)CADisplayLink *displayLink;


@end

@implementation subViewController
{
    // 获取当期时间
    NSDate *_currentDate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIButton *ceshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ceshiBtn.frame = CGRectMake(self.view.bounds.size.width / 2.0 - 50, 150, 100, 50);
    [ceshiBtn setTitle:@"返回" forState:UIControlStateNormal];
    ceshiBtn.backgroundColor = [UIColor greenColor];
    
    [ceshiBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ceshiBtn];
    
    
    
    UIButton *ceshiBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    ceshiBtn1.frame = CGRectMake(self.view.bounds.size.width / 2.0 - 50, 250, 100, 50);
    [ceshiBtn1 setTitle:@"开始检测画面" forState:UIControlStateNormal];
    ceshiBtn1.backgroundColor = [UIColor purpleColor];
    [ceshiBtn1 addTarget:self action:@selector(startDisplayLink) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ceshiBtn1];
    
    
    UIButton *ceshiBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    ceshiBtn2.frame = CGRectMake(self.view.bounds.size.width / 2.0 - 50, 350, 100, 50);
    [ceshiBtn2 setTitle:@"结束检测画面" forState:UIControlStateNormal];
    ceshiBtn2.backgroundColor = [UIColor greenColor];
    
    [ceshiBtn2 addTarget:self action:@selector(stopDisplayLink) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ceshiBtn2];
    
    
}

- (void)click
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)startDisplayLink
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    
    // 注册到runloop
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    NSLog(@"做事情");
    NSDate *date = [NSDate date];
    // 获取时间差
    NSTimeInterval time=[date timeIntervalSinceDate:_currentDate];
    NSLog(@"---%lf", time);
    
    _currentDate = date;
}

- (void)stopDisplayLink
{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
