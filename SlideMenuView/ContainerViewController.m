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

static const CGFloat kSideScaleFactor = 0.4;

@interface ContainerViewController ()<UIGestureRecognizerDelegate>
{
    CenterViewController *centerViewController;
    SideViewController *leftSideViewController;
    SideViewController *rightSideViewController;
    
    UIPanGestureRecognizer *leftSwipeGR; // 往左滑手势
    UIScreenEdgePanGestureRecognizer *rightSwipeEdgeGR; // 边缘往右滑手势
    UITapGestureRecognizer *tapGR; // 轻点闭合
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
    
    // 注意，这个控制器的可触摸范围刚好就在这个屏幕范围内
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
    
    // 防止循环引用
    __weak typeof(centerViewController) wCenterViewController = centerViewController;
    
    // 左侧
    leftSideViewController = [[SideViewController alloc] init];
    leftSideViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width * kSideScaleFactor, self.view.frame.size.height);
    leftSideViewController.view.backgroundColor = [UIColor redColor];
    NSArray *leftTableArray = @[@"home", @"feature", @"about", @"exit"];
    leftSideViewController.tableArray = leftTableArray;
    leftSideViewController.tableSelectBlock = ^(NSString *str){
        wCenterViewController.content = str;
    };
    [self.view addSubview:leftSideViewController.view];
    [self addChildViewController:leftSideViewController];
    
    // 右侧
    rightSideViewController = [[SideViewController alloc] init];
    rightSideViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width * kSideScaleFactor, self.view.frame.size.height);
    rightSideViewController.view.backgroundColor = [UIColor greenColor];
    NSArray *rightTableArray = @[@"C++", @"java", @"python", @"ruby", @"swift"];
    rightSideViewController.tableArray = rightTableArray;
    rightSideViewController.tableSelectBlock = ^(NSString *str){
        wCenterViewController.content = str;
    };
    [self.view addSubview:rightSideViewController.view];
    [self addChildViewController:rightSideViewController];
    
    // 保证中间界面中在最上方（其实层次自己定，可上可下）
    [self.view bringSubviewToFront:centerViewController.view];
    
    // 添加屏幕手势
    // 右滑
    rightSwipeEdgeGR = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleSwipeOrTapGesture:)];
    rightSwipeEdgeGR.edges = UIRectEdgeLeft; // 必须指定edge，否则不响应
    rightSwipeEdgeGR.delegate = self;
    [centerViewController.view addGestureRecognizer:rightSwipeEdgeGR];
    // 左滑
    leftSwipeGR = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(handleSwipeOrTapGesture:)];
    leftSwipeGR.delegate = self;
    [centerViewController.view addGestureRecognizer:leftSwipeGR];
    // 轻点闭合
    tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOrTapGesture:)];
    [centerViewController.view addGestureRecognizer:tapGR];
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

- (void)handleSwipeOrTapGesture:(UIGestureRecognizer *)gesture
{
    if (gesture == rightSwipeEdgeGR)
    {
        // 右滑是层次错位滑动
        // 防止手势干扰
        if (gesture.state == UIGestureRecognizerStateBegan)
        {
            leftSwipeGR.enabled = NO;
            [self showShadow];
        }
        else if (gesture.state == UIGestureRecognizerStateChanged)
        {
            CGPoint translation = [rightSwipeEdgeGR translationInView:self.view];
            centerViewController.view.center = CGPointMake(centerViewController.view.center.x + translation.x, centerViewController.view.center.y);
            NSLog(@"%f", translation.x);
            [rightSwipeEdgeGR setTranslation:CGPointZero inView:self.view];
            // 限制滑动范围
            if (centerViewController.view.center.x > centerViewController.view.frame.size.width / 2 + centerViewController.view.frame.size.width * kSideScaleFactor)
            {
                centerViewController.view.center = CGPointMake(centerViewController.view.frame.size.width / 2 + centerViewController.view.frame.size.width * kSideScaleFactor, centerViewController.view.center.y);
            }
            
        }
        else if (gesture.state == UIGestureRecognizerStateEnded)
        {
            [UIView animateWithDuration:0.2 animations:^{
                if (centerViewController.view.center.x > centerViewController.view.frame.size.width / 2 + centerViewController.view.frame.size.width * kSideScaleFactor / 2)
                {
                    centerViewController.view.center = CGPointMake(centerViewController.view.frame.size.width / 2 + centerViewController.view.frame.size.width * kSideScaleFactor, centerViewController.view.center.y);
                }
                else
                {
                    centerViewController.view.center = CGPointMake(self.view.frame.size.width / 2, centerViewController.view.center.y);
                }
            } completion:^(BOOL finished) {
                if (centerViewController.view.center.x == centerViewController.view.frame.size.width / 2)
                {
                    [self hideShadow];
                    leftSwipeGR.enabled = YES;
                }
            }];
            
            
        }
        

    }
//    else if (gesture == leftSwipeGR)
//    {
//        // 左滑是整体联动滑动
//        // 添加阴影效果
//        [self showLayer];
//        
//        // 相对偏移量
//        CGFloat offsetX = [leftSwipeGR translationInView:self.view].x;
//        
//        // 设置view相对偏移,生成transform绝对偏移
//        self.view.transform = CGAffineTransformTranslate(self.view.transform, offsetX, 0);
//        
//        // 根据偏移量来算渐变透明度
//        CGFloat factor = self.view.transform.tx / (-self.view.frame.size.width * kSideScaleFactor);
//        [self.view viewWithTag:100].backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5 * factor];
//        
//        // 防止累积偏移
//        [leftSwipeGR setTranslation:CGPointZero inView:self.view];
//        
//        // 限制左右滑最大范围
//        CGAffineTransform leftMaxTransform = CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform, -self.view.frame.size.width * kSideScaleFactor, 0);
//        CGAffineTransform rightMaxTransform = CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform, 0, 0);
//        if (self.view.transform.tx < -self.view.frame.size.width * kSideScaleFactor)
//        {
//            // 以屏幕边线作为基准线
//            self.view.transform = leftMaxTransform;
//        }
//        else if (self.view.transform.tx > 0)
//        {
//            self.view.transform = rightMaxTransform;
//        }
//        
//        // 松开后如果过了中线就直接滑出，否则闭合
//        if (gesture.state == UIGestureRecognizerStateEnded)
//        {
//            [UIView animateWithDuration:0.2 animations:^{
//                if (self.view.transform.tx < -self.view.frame.size.width * kSideScaleFactor / 2)
//                {
//                    self.view.transform = leftMaxTransform;
//                }
//                else
//                {
//                    self.view.transform = rightMaxTransform;
//                    
//                }
//            }
//            completion:^(BOOL finished) {
//                if (self.view.transform.tx == leftMaxTransform.tx)
//                {
//                    [self.view viewWithTag:100].backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//                }
//                else if (self.view.transform.tx == rightMaxTransform.tx)
//                {
//                    [self hideLayer];
//                }
//            }];
//            
//        }
//        
//    }
    else if (gesture == tapGR)
    {
        leftSwipeGR.enabled = NO;
        [UIView animateWithDuration:0.2 animations:^{
            centerViewController.view.center = CGPointMake(centerViewController.view.frame.size.width / 2, centerViewController.view.center.y);
        }completion:^(BOOL finished) {
            leftSwipeGR.enabled = YES;
        }];
    }
}

#pragma mark - 滑动后的动画效果
- (void)showShadow
{
    // 添加阴影
    centerViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    centerViewController.view.layer.shadowOffset = CGSizeMake(3, 3);
    centerViewController.view.layer.shadowOpacity = 0.7;
    centerViewController.view.layer.shadowRadius = 6.0f;

}

- (void)hideShadow
{
    // 隐藏阴影
    centerViewController.view.layer.shadowColor = [UIColor whiteColor].CGColor;
    centerViewController.view.layer.shadowOffset = CGSizeMake(0, 0);
    centerViewController.view.layer.shadowOpacity = 0;
    centerViewController.view.layer.shadowRadius = 0;
}

- (void)showLayer
{
    // 保证只添加一次
    if (![self.view viewWithTag:100])
    {
        UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        layerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        layerView.tag = 100;
        // 避免遮挡触摸事件
        layerView.userInteractionEnabled = YES;
        [self.view addSubview:layerView];
    }
    [[self.view viewWithTag:100] addGestureRecognizer:leftSwipeGR];
    [self.view viewWithTag:100].hidden = NO;
}

- (void)hideLayer
{
    // 移除后使得原来的view可以接受触摸事件
    [[self.view viewWithTag:100] setHidden:YES];
    // 原来的必须要重新设置一下手势
    [self.view addGestureRecognizer:leftSwipeGR];
}


@end
