//
//  ContainerViewController.m
//  SlideMenuView
//
//  Created by yxhe on 16/9/27.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

// ---- 侧边栏中心栏滑动管理器 ---- //
#import "ContainerViewController.h"
#import "CenterViewController.h"
#import "SideViewController.h"

@interface ContainerViewController ()<UIGestureRecognizerDelegate>
{
    CenterViewController *centerViewController;
    SideViewController *leftSideViewController;
    SideViewController *rightSideViewController;
    
    UIPanGestureRecognizer *leftSwipeGR; // 往左滑手势
    UIScreenEdgePanGestureRecognizer *rightSwipeEdgeGR; // 边缘往右滑手势
}

@end

@implementation ContainerViewController

// 初始化一些数据
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"主页";
        // 数据初始化
        NSLog(@"出界面");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 创建ui
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建中心区和左右边栏
- (void)setupViewControllers
{
    // 中间
    centerViewController = [[CenterViewController alloc] init];
    centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:centerViewController.view];
    [self addChildViewController:centerViewController];
    
    // 自己画一个导航栏
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, centerViewController.view.frame.size.width, 64)];
    navigationView.backgroundColor = [UIColor lightGrayColor];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    leftButton.center = CGPointMake(20, 40);
    [navigationView addSubview:leftButton];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    rightButton.center = CGPointMake(navigationView.frame.size.width - 20, 40);
    [navigationView addSubview:rightButton];
    [centerViewController.view addSubview:navigationView];
    
    
    // 左侧
    leftSideViewController = [[SideViewController alloc] init];
    leftSideViewController.view.frame = CGRectMake(-self.view.frame.size.width / 3, 0, self.view.frame.size.width / 3, self.view.frame.size.height);
    leftSideViewController.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:leftSideViewController.view];
//    [self addChildViewController:leftSideViewController];
    
    // 右侧
    rightSideViewController = [[SideViewController alloc] init];
    rightSideViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width / 3, self.view.frame.size.height);
    rightSideViewController.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightSideViewController.view];
//    [self addChildViewController:rightSideViewController];
    
    // 保证中间界面中在最上方（其实层次自己定，可上可下）
    [self.view bringSubviewToFront:centerViewController.view];
    
    // 添加左侧屏幕手势
    rightSwipeEdgeGR = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleSwipeGesture:)];
    rightSwipeEdgeGR.edges = UIRectEdgeLeft; // 必须指定edge，否则不响应
    rightSwipeEdgeGR.delegate = self;
    [centerViewController.view addGestureRecognizer:rightSwipeEdgeGR];
    leftSwipeGR = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(handleSwipeGesture:)];
    leftSwipeGR.delegate = self;
    [centerViewController.view addGestureRecognizer:leftSwipeGR];
}

#pragma mark - 导航栏button事件
- (void)leftButtonClicked
{
    NSLog(@"left clicked");
    // 展开左边栏
}

- (void)rightButtonClicked
{
    NSLog(@"right clicked");
    // 展开右边栏
}

#pragma mark - 滑动手势
// gesture的代理，允许同一个view响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleSwipeGesture:(UIPanGestureRecognizer *)swipeGesture
{
    if (swipeGesture == rightSwipeEdgeGR)
    {
        NSLog(@"边缘右滑");
        

    }
    else if (swipeGesture == leftSwipeGR)
    {
        NSLog(@"往左滑");
        CGFloat offsetX = [swipeGesture translationInView:self.view].x;
        
        self.view.transform = CGAffineTransformTranslate(self.view.transform, offsetX, 0);
        
        self.navigationController.view.transform = CGAffineTransformTranslate(self.view.transform, offsetX, 0);
        [swipeGesture setTranslation:CGPointZero inView:self.view];
        
    }
}




@end
