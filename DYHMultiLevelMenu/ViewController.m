//
//  ViewController.m
//  DYHMultiLevelMenu
//
//  Created by YueHui on 16/6/2.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "MenuData.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) MenuData * menuData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuData.tableViewData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [TableViewCell cellWithTableView:tableView];
    MyItem *item = self.menuData.tableViewData[indexPath.row];
    cell.item = item;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = (TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    MyItem *item = cell.item;
    
    if (item.isSubItemOpen) {
        //删除
        NSArray *arr = [self.menuData deleteMenuIndexPaths:item];
        [self.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        //插入
        NSArray *arr = [self.menuData insertMenuIndexPaths:item];
        [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
    }
}

#pragma mark - Property
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
- (MenuData *)menuData {
    if (!_menuData) {
        _menuData = [[MenuData alloc] init];
    }
    return _menuData;
}
@end
