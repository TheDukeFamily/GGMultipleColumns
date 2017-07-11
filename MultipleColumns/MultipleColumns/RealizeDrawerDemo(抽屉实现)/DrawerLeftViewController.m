//
//  DeawerLeftViewController.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "DrawerLeftViewController.h"
#import "DrawerTabBarController.h"
#import "DrawerNullViewController.h"
#import "DrawerHomeViewController.h"
#import "UIView+LCFrame.h"

@interface DrawerLeftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation DrawerLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellinde";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld个Cell",indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[DrawerNullViewController alloc] init]]];
    
    DrawerHomeViewController *homeVC = (DrawerHomeViewController*)[(DrawerTabBarController *)self.sideMenuViewController.contentViewController HomeVC];
    [homeVC.navigationController pushViewController:[[DrawerNullViewController alloc] init] animated:YES];
//    [.navigationController pushViewController:[[DrawerNullViewController alloc] init] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
