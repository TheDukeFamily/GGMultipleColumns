//
//  AddressBookTableVC.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "AddressBookTableVC.h"
#import "GGGetAddressBook.h"

@interface AddressBookTableVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , copy) NSDictionary *contactPeopleDict;

@property (nonatomic , copy) NSArray *keys;

@property (nonatomic , copy) NSArray *dataSource;

@property (nonatomic , weak) UIButton *selectedBtn;

@end

@implementation AddressBookTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.navigationItem.title = @"联系人";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 40);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"切换A~Z" forState:UIControlStateNormal];
    [button setTitle:@"切换默认" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(navigationItemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedBtn = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.tableView.rowHeight = 80;
    
    [GGGetAddressBook getOriginalAddressBook:^(NSArray<GGPersonModel *> *addressBookArray) {
        self.dataSource = addressBookArray;
        [self.tableView reloadData];
    } authorizationFailure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.selectedBtn.selected) {
        return 1;
    }else{
        return _keys.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.selectedBtn.selected) {
        return _dataSource.count;
    }else{
        NSString *key = _keys[section];
        return [_contactPeopleDict[key] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!self.selectedBtn.selected) {
        return nil;
    }else{
        return _keys[section];
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (!self.selectedBtn.selected) {
        return nil;
    }else{
        return _keys;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    if (!self.selectedBtn.selected) {
        GGPersonModel *people = _dataSource[indexPath.row];
        cell.imageView.image = people.headerImage ? people.headerImage : [UIImage imageNamed:@"defult"];
        CGSize itemSize = CGSizeMake(60, 60);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.imageView.layer.cornerRadius = 60/2;
        cell.imageView.clipsToBounds = YES;
        cell.textLabel.text = people.name;
    }else{
        NSString *key = _keys[indexPath.section];
        GGPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
        
        cell.imageView.image = people.headerImage ? people.headerImage : [UIImage imageNamed:@"defult"];
        CGSize itemSize = CGSizeMake(60, 60);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.imageView.layer.cornerRadius = 60/2;
        cell.imageView.clipsToBounds = YES;
        
        cell.textLabel.text = people.name;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.selectedBtn.selected) {
        return 0.001;
    }else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSectionr:(NSIndexPath *)indexPath{
    return 0.001;
}

- (void)navigationItemClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    if (!self.selectedBtn.selected) {
        [GGGetAddressBook getOriginalAddressBook:^(NSArray<GGPersonModel *> *addressBookArray) {
            self.dataSource = addressBookArray;
            [self.tableView reloadData];
        } authorizationFailure:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }else{
        [GGGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
            self.contactPeopleDict = addressBookDict;
            self.keys = nameKeys;
            [self.tableView reloadData];
        } authorizationFailure:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
}


@end
