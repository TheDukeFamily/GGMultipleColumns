//
//  UIView+LCFrame.m
//  LCLuckyCoffee
//
//  Created by Mac on 2016/10/26.
//  Copyright © 2016年 Mr.Gao. All rights reserved.
//

#import "UIView+LCFrame.h"

@implementation UIView (LCFrame)

- (UIViewController *)viewcontroller{
    UIResponder *next = [self nextResponder];
    
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    }
    return nil;
}

- (UINavigationController *)navigationController{
    UIResponder *next = [self nextResponder];
    while (next) {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
        }
        next = [next nextResponder];
    }
    return nil;
}

-(UITableView *)viewTableView{
    UIResponder *next = [self nextResponder];
    while (next) {
        if ([next isKindOfClass:[UITableView class]]) {
            return (UITableView *)next;
        }
        next = [next nextResponder];
    }
    return nil;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}
@end
