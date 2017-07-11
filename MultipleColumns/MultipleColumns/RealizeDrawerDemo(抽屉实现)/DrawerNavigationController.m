//
//  DrawerNavigationController.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "DrawerNavigationController.h"

@interface DrawerNavigationController ()

@end

@implementation DrawerNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    return [super pushViewController:viewController animated:animated];
}

@end
