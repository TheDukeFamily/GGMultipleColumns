//
//  DragLeftViewController.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/5.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "DragLeftViewController.h"

@interface DragLeftViewController ()

@end

@implementation DragLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //抽屉内的按钮事件
//    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]]
    [self.sideMenuViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
    
}

@end
