//
// Created by Tadeas Kriz on 02/02/14.
// Copyright (c) 2014 Tadeas Kriz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCTask;
@protocol DCAddTaskControllerDelegate;

@interface DCAddTaskController : UIViewController

@property (nonatomic, weak) id<DCAddTaskControllerDelegate> delegate;
@property (nonatomic, strong) DCTask* task;

@end

@protocol DCAddTaskControllerDelegate

-(void)addTaskController:(DCAddTaskController*)controller saveTask:(DCTask*)task;

-(void)addTaskController:(DCAddTaskController*)controller deleteTask:(DCTask*)task;

@end