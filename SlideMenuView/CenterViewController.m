//
//  CenterViewController.m
//  SlideMenuView
//
//  Created by yxhe on 16/9/27.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "CenterViewController.h"
#import "SubViewController.h"

@interface CenterViewController ()
{
    UINavigationController *nav;
    UILabel *contentLabel;
}
@end

@implementation CenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
        
    // 添加label
    contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(100, 300, 100, 50);
    contentLabel.text = @"welcome";
    [self.view addSubview:contentLabel];
    
    // 添加button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 400, 100, 30);
    [button setTitle:@"test" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    // 此处刷新中间去，可以干其他事情，比如网络请求，刷界面等
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    [self.view setBackgroundColor:[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]];
    
    contentLabel.text = _content;
}

// 外部设置数据，懒加载
- (void)setContent:(NSString *)content
{
    _content = content;
    [self updateUI];
}

- (void)onButtonClicked
{
    SubViewController *subViewController = [[SubViewController alloc] init];
    [self.navigationController pushViewController:subViewController animated:YES];
}


@end
