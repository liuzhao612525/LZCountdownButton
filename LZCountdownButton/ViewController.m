//
//  ViewController.m
//  LZCountdownButton
//
//  Created by shanggu on 16/5/20.
//  Copyright © 2016年 shanggu. All rights reserved.
//

#import "ViewController.h"
#import "LZButtonCountdownManager.h"

#define key @"key"
@interface ViewController ()
{}
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) LZButtonCountdownManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 150, 40);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.btn = btn;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LZCountdownTask *task = nil;
    if ([self.manager coundownTaskExistWithKey:key task:&task]) {//当退出改页面后再次加载该页面时，如果key存在，直接接着上次记时点记时
        [self btnAction:self.btn];
    }
    
}
- (void)btnAction:(UIButton *)sender {
    LZButtonCountdownManager *manager = [LZButtonCountdownManager defaultManager];
    [manager scheduledCountDownWithKey:@"one" timeInterval:60 countingDown:^(NSTimeInterval leftTimeInterval) {
        NSInteger time = leftTimeInterval;
        [self.btn setTitle:[NSString stringWithFormat:@"%ld后可重新获取" ,(long)time] forState:UIControlStateNormal];
        self.btn.backgroundColor = [UIColor grayColor];
    } finished:^(NSTimeInterval finalTimeInterval) {
        self.btn.backgroundColor = [UIColor greenColor];
    }];
}


@end
