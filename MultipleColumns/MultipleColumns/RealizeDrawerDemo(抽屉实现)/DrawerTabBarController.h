//
//  DrawerTabBarController.h
//  MultipleColumns
//
//  Created by Mac on 2017/7/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawerHomeViewController;
@interface DrawerTabBarController : UITabBarController
/** 获取到首页控制器 **/
- (DrawerHomeViewController *)HomeVC;
@end
