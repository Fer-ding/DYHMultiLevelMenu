//
//  MenuData.m
//  DYHMultiLevelMenu
//
//  Created by YueHui on 16/6/2.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import "MenuData.h"

@interface MenuData ()
{
    MyItem * rootItem;
    
    NSMutableArray * treeItemsToRemove;
    NSMutableArray * treeItemsToInsert;
}
@end

@implementation MenuData

- (instancetype)init
{
    self = [super init];
    if (self) {
        treeItemsToRemove = [NSMutableArray array];
        treeItemsToInsert = [NSMutableArray array];
        
        [self initModelData];
        
    }
    return  self;
}

- (void) initModelData
{
    rootItem = [[MyItem alloc] init];
    
    rootItem.title = @"根菜单";
    rootItem.subItems = [NSMutableArray array];
    rootItem.level = 0;
    
    NSArray * firstMenuData;
    NSArray * thirdMenuData0;
    firstMenuData = [NSArray arrayWithObjects:@"菜单一",@"菜单二",@"菜单三", @"菜单四", @"菜单五",  nil];
    NSArray * secondMenuData0,* secondMenuData1;
    
    secondMenuData0 = [NSArray arrayWithObjects:@"子项一",@"子项二", @"子项三",nil];
    
    secondMenuData1 = [NSArray arrayWithObjects:@"选择一",@"选择二",nil];
    
    thirdMenuData0 = [NSArray arrayWithObjects:@"内容1",@"内容2", nil];
    
    
    //init first Menu
    for (int i = 0; i < [firstMenuData count]; i++)
    {
        NSString * title =[firstMenuData objectAtIndex:i];
        MyItem *firstItem;
        firstItem = [[MyItem alloc]init];
        firstItem.title = title;
        firstItem.subItems = [NSMutableArray array];
        //parent item??
        firstItem.level =1;
        if ([title isEqualToString: @"菜单一"]) {
            for (int i = 0; i < [secondMenuData1 count]; i++) {
                NSString * title =[secondMenuData1 objectAtIndex:i];
                MyItem *secondeItem;
                secondeItem = [[MyItem alloc]init];
                secondeItem.title = title;
                secondeItem.subItems = [NSMutableArray array];
                //parent item??
                secondeItem.level =2;
                [firstItem.subItems addObject:secondeItem];
            }
        }
        
        if ([title isEqualToString: @"菜单四"]) {
            for (int i = 0; i < [secondMenuData0 count]; i++) {
                NSString * title =[secondMenuData0 objectAtIndex:i];
                MyItem *secondeItem;
                secondeItem = [[MyItem alloc]init];
                secondeItem.title = title;
                secondeItem.subItems = [NSMutableArray array];
                //parent item??
                secondeItem.level =2;
                secondeItem.isSubCascadeOpen = NO;
                if ([title isEqualToString:@"子项三"]) {
                    for (int i = 0; i< [thirdMenuData0 count]; i++) {
                        NSString *title = [thirdMenuData0 objectAtIndex:i];
                        MyItem *thirdItem;
                        thirdItem  = [[MyItem alloc]init];
                        thirdItem.title = title;
                        thirdItem.subItems = [NSMutableArray array];
                        thirdItem.level = 3;
                        [secondeItem.subItems addObject:thirdItem];
                    }
                }
                [firstItem.subItems addObject:secondeItem];
                
            }
            
        }
        [rootItem.subItems addObject:firstItem];
    }
    
    [self.tableViewData addObject:rootItem];
}

#pragma mark - insert
- (NSArray *)insertMenuIndexPaths:(MyItem *)item {
    
    NSArray *arr;
    [treeItemsToInsert removeAllObjects];
    [self insertMenuObject:item];
    arr = [self insertIndexsOfMenuObject:treeItemsToInsert];
    return arr;
}

//查找item下的所有需要插入的模型，临时保存到treeItemsToInsert数组中
- (void)insertMenuObject:(MyItem *)item {
    
    if (item == nil) {
        return ;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tableViewData indexOfObject:item] inSection:0];
    
    MyItem *childItem;
    for (int i = 0; i < [item.subItems count]; i++) {
        childItem = item.subItems[i];
        [self.tableViewData insertObject:childItem atIndex:indexPath.row + i +1];
        [treeItemsToInsert addObject:childItem];
        item.isSubItemOpen = YES;
    }
    
    for (int i = 0; i < [item.subItems count]; i++) {
        childItem = item.subItems[i];
        
        if (childItem .isSubCascadeOpen) {
            [self insertMenuObject:childItem];
        }
        
    }
}
//返回tableView需要插入的数组(indexPath路径)
- (NSArray *)insertIndexsOfMenuObject:(NSMutableArray *)array {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MyItem *item in array) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tableViewData indexOfObject:item] inSection:0];
        [arr addObject:indexPath];
    }
    return arr;
}

#pragma mark - delete
- (NSArray *)deleteMenuIndexPaths:(MyItem *)item {
    
    NSArray * arr;
    [treeItemsToRemove removeAllObjects];
    [self deleteMenuObject:item];
    arr = [self deleteIndexsOfMenuObject:treeItemsToRemove];
    return arr;
}

//查找需要删除的模型数组
- (void) deleteMenuObject:(MyItem *)item {
    if (item == nil)
    {
        return ;
    }
    
    MyItem *childItem;
    for (int i = 0; i<[item.subItems count] && item.isSubItemOpen ; i++) {
        childItem = [item.subItems objectAtIndex:i];
        [self deleteMenuObject:childItem];
        
        [treeItemsToRemove addObject:childItem];
        // [tableViewData removeObject:childItem];
        
    }
    
    item.isSubItemOpen = NO;
    
    return ;
}

//返回需要删除的indexpatn数组
- (NSArray *) deleteIndexsOfMenuObject:(NSMutableArray *)arr {
    
    NSMutableArray *mutableArr;
    mutableArr = [NSMutableArray array];
    NSMutableIndexSet * set;
    set = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [treeItemsToRemove count]; i++)
    {
        MyItem * item;
        item = [treeItemsToRemove objectAtIndex:i];
        NSIndexPath *path = [NSIndexPath indexPathForRow:[self.tableViewData indexOfObject:item] inSection:0];
        [mutableArr addObject:path];
        [set addIndex:path.row];
    }
    
    [self.tableViewData removeObjectsAtIndexes:set];
    
    return mutableArr;
}


#pragma mark - Property
- (NSMutableArray *)tableViewData {
    if (!_tableViewData) {
        _tableViewData = [NSMutableArray array];
    }
    return _tableViewData;
}
@end
