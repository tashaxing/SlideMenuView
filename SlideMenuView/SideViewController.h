//
//  SideViewController.h
//  SlideMenuView
//
//  Created by yxhe on 16/9/27.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

// ---- 侧边栏 ---- //
// 可以用view或者viewcontroller

#import <UIKit/UIKit.h>
typedef void (^Block)(NSString *);
@interface SideViewController : UIViewController

// 外部给侧边栏设置数据
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) Block tableSelectBlock;

@end
