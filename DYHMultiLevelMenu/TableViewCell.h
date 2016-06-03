//
//  TableViewCell.h
//  DYHMultiLevelMenu
//
//  Created by YueHui on 16/6/2.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyItem.h"

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) MyItem * item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
