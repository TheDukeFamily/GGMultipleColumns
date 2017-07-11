//
//  MainTableViewController.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "MainTableViewController.h"

#import "AddressBookTableVC.h"

#import "DrawerTabBarController.h"
#import "DrawerLeftViewController.h"
#import "RESideMenu.h"

@interface MainTableViewController ()<RESideMenuDelegate>
{
    NSArray *_titleArr;
}
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"一些小的示例";
    
    _titleArr = @[@"联系人列表",@"抽屉效果"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[[AddressBookTableVC alloc] init] animated:YES];
        }
            break;
        case 1:
        {
            DrawerTabBarController *tabbar = [[DrawerTabBarController alloc] init];
            DrawerLeftViewController *leftVC = [[DrawerLeftViewController alloc] init];
            RESideMenu *sideMenu = [[RESideMenu alloc] initWithContentViewController:tabbar
                                                                 leftMenuViewController:leftVC
                                                                rightMenuViewController:nil];
//            sideMenu.backgroundImage = [UIImage imageNamed:@"Stars@2x.png"];
            sideMenu.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
            sideMenu.delegate = self;
            sideMenu.contentViewShadowColor = [UIColor blackColor];
            sideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
            sideMenu.contentViewShadowOpacity = 0.6;
            sideMenu.contentViewShadowRadius = 20;
            sideMenu.contentViewShadowEnabled = YES;
            sideMenu.scaleMenuView= NO;
            sideMenu.contentViewScaleValue = 1;
            sideMenu.contentViewInPortraitOffsetCenterX = ([UIScreen mainScreen].bounds.size.width/2)-80;
            //    _sideMenuViewController.scaleContentView = NO;
            [self presentViewController:sideMenu animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
