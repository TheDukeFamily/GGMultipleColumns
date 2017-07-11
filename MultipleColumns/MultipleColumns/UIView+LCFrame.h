//
//  UIView+LCFrame.h
//  LCLuckyCoffee
//
//  Created by Mac on 2016/10/26.
//  Copyright © 2016年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LCFrame)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
//获取当前所属的tableview
- (UITableView *)viewTableView;
//获取当前所属的navgationcontroller
- (UINavigationController *)navigationController;
//获取当前所属的viewcontroller
- (UIViewController *)viewcontroller;
@end
