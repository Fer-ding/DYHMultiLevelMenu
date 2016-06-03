##UITableView多层级列表
众所周知，`UITableView`只有`section`和`row`,是没有多层级概念的。所以，想要做到像OA系统中的多级部门管理列表，就需要自己手动实现。

###原理
`tableView`作为一个容器，每一行一个`cell`，点击一行`cell`时，去查找当前cell下的模型(model)的子模型数组，插入到当前模型下面，展示在界面上。隐藏时，再查找子模型数组删除。

###数据模型
```
@property (nonatomic, copy  ) NSString       * title;
@property (nonatomic, assign) NSInteger      level;
@property (nonatomic, strong) NSMutableArray * subItems;
@property (nonatomic, assign) BOOL           isSubItemOpen;
@property (nonatomic, assign) BOOL           isSubCascadeOpen;
```
`isSubItemOpen`标记当前cell展开或隐藏；`isSubCascadeOpen`标记该子菜单是否要在其父菜单展开时自动展开；`level`标记当前cell层级。

###cell插入
```
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

```

###cell删除
```
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

```

###cell点击
```
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

```
