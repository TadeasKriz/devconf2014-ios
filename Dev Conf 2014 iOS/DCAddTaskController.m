//
// Created by Tadeas Kriz on 02/02/14.
// Copyright (c) 2014 Tadeas Kriz. All rights reserved.
//

#import "DCAddTaskController.h"
#import "DCTask.h"

@interface DCAddTaskController ()
@property (weak, nonatomic) IBOutlet UIButton *add;
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteTask;

@end

@implementation DCAddTaskController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    if(!self.task) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.label.text = @"EDIT TASK";
        [self.add setTitle:@"SAVE" forState:UIControlStateNormal];
        [self.add setTitle:@"SAVE" forState:UIControlStateHighlighted];
        self.text.text = self.task.text;
    }
}

- (IBAction)deleteTask:(id)sender {
    if(self.delegate) {
        [self.delegate addTaskController:self deleteTask:self.task];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveTask:(id)sender {
    if(self.delegate) {
        DCTask* task = self.task;

        if(!task) {
            task = [[DCTask alloc] init];
            task.done = @(NO);
        }

        task.text = self.text.text;

        [self.delegate addTaskController:self saveTask:task];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end