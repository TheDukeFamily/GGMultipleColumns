//
//  DrawerTabBarController.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "DrawerTabBarController.h"
#import "DrawerNavigationController.h"

#import "DrawerHomeViewController.h"
#import "DrawerNullViewController.h"

@interface DrawerTabBarController ()
{
    NSMutableArray *_vcArray;
}
@end

@implementation DrawerTabBarController

- (DrawerHomeViewController *)HomeVC{
    if (_vcArray.count <= 0) {
        return nil;
    }else{
        DrawerHomeViewController *vc = (DrawerHomeViewController *)_vcArray[0];
        return vc;
    }
}


+ (void)initialize
{
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _vcArray = [NSMutableArray array];
    
    [self setUpAllChildVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpAllChildVC{
    DrawerHomeViewController *HomeVC = [[DrawerHomeViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"home_unSel" selectedImage:@"home_selected" title:@"主页"];
    
    DrawerNullViewController *chatVC = [[DrawerNullViewController alloc] init];
    [self setUpOneChildVcWithVc:chatVC Image:@"home_unSel" selectedImage:@"home_selected" title:@"推荐"];
    
    DrawerNullViewController *shopVC = [[DrawerNullViewController alloc] init];
    [self setUpOneChildVcWithVc:shopVC Image:@"home_unSel" selectedImage:@"home_selected" title:@"高校"];
    
    DrawerNullViewController *discoverVC = [[DrawerNullViewController alloc] init];
    [self setUpOneChildVcWithVc:discoverVC Image:@"home_unSel" selectedImage:@"home_selected" title:@"发现"];
}

- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    DrawerNavigationController *nav = [[DrawerNavigationController alloc] initWithRootViewController:Vc];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
    Vc.tabBarItem.title = title;
    
    Vc.navigationItem.title = title;
    
    [self addChildViewController:nav];
    [_vcArray addObject:Vc];
}

@end
