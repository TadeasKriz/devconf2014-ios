//
// Created by Tadeas Kriz on 02/02/14.
// Copyright (c) 2014 Tadeas Kriz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCTasksListItemDelegate;
@class DCTask;

@interface DCTasksListItem : UITableViewCell

@property (weak) id <DCTasksListItemDelegate> delegate;
@property (weak, nonatomic) DCTask* task;

@end

@protocol DCTasksListItemDelegate

- (void)tasksListItem:(DCTasksListItem*)item checkBox:(UIButton*)checkBox checkStateChanged:(BOOL)checked;

@end