//
//  MenuData.h
//  DYHMultiLevelMenu
//
//  Created by YueHui on 16/6/2.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyItem.h"

@interface MenuData : NSObject

@property (nonatomic, strong) NSMutableArray * tableViewData;

- (NSArray *)insertMenuIndexPaths:(MyItem *)item;
- (NSArray *)deleteMenuIndexPaths:(MyItem *)item;

@end
