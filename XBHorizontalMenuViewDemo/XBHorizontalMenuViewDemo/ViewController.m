//
//  ViewController.m
//  XBHorizontalMenuViewDemo
//
//  Created by Loxe on 17/11/21.
//  Copyright © 2017年 XB. All rights reserved.
//

#import "ViewController.h"
#import "XBHorizontalMenuView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
@property (nonatomic, strong) XBHorizontalMenuView *menuView;
@property (nonatomic, strong) UIScrollView *bodyScroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.bodyScroll];
}

- (XBHorizontalMenuView *)menuView
{
    if (!_menuView) {
        
        
        _menuView = [[XBHorizontalMenuView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 30) titles:@[@"第一",@"第二",@"第三三三个个个",@"第四个"] space:6 font:[UIFont systemFontOfSize:12.f] normalColor:[UIColor grayColor] selectedColor:[UIColor blackColor] lineColor:[UIColor redColor] lineShowRealWidth:NO showMaxCount:4 avgWidth:NO];
        
    }
    return _menuView;
}

- (UIScrollView *)bodyScroll
{
    if (!_bodyScroll) {
        _bodyScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight - 50)];
        for (int i = 0;  i < 4; i ++) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 5, kScreenWidth, CGRectGetHeight(_bodyScroll.frame))];
            v.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1];
            [_bodyScroll addSubview:v];
        }
        _bodyScroll.pagingEnabled = YES;
        [_bodyScroll setContentSize:CGSizeMake(kScreenWidth * 4, CGRectGetHeight(_bodyScroll.frame))];
        [_bodyScroll addObserver:_menuView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _bodyScroll;
}
@end
