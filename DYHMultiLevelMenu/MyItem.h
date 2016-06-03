//
//  MyItem.h
//  DYHMultiLevelMenu
//
//  Created by YueHui on 16/6/2.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyItem : NSObject

@property (nonatomic, copy  ) NSString       * title;
@property (nonatomic, assign) NSInteger      level;
@property (nonatomic, strong) NSMutableArray * subItems;
@property (nonatomic, assign) BOOL           isSubItemOpen;
@property (nonatomic, assign) BOOL           isSubCascadeOpen;//标记该子菜单是否要在其父菜单展开时自动展开。

@end
