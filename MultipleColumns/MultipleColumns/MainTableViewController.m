//
//  MainTableViewController.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/5.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "MainTableViewController.h"

#import <RESideMenu.h>
#import "DragViewController.h"
#import "DragLeftViewController.h"

@interface MainTableViewController ()<RESideMenuDelegate>
{
    NSArray *_titleArr;
}
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArr = @[@"抽屉"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[DragViewController alloc] init]];
            DragLeftViewController *dragLeftVC = [[DragLeftViewController alloc] init];
            RESideMenu *sideMenu = [[RESideMenu alloc] initWithContentViewController:nav leftMenuViewController:dragLeftVC rightMenuViewController:nil];
            sideMenu.backgroundImage = [UIImage imageNamed:@"Stars"];
            sideMenu.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
            sideMenu.delegate = self;
            sideMenu.contentViewShadowColor = [UIColor blackColor];
            sideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
            sideMenu.contentViewShadowOpacity = 0.6;
            sideMenu.contentViewShadowRadius = 20;
            sideMenu.contentViewShadowEnabled = YES;
            sideMenu.scaleMenuView= NO;
            sideMenu.contentViewScaleValue = 1;
            sideMenu.contentViewInPortraitOffsetCenterX = self.view.frame.size.width/2-50;
            //    _sideMenuViewController.scaleContentView = NO;
            [self presentViewController:sideMenu animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end
