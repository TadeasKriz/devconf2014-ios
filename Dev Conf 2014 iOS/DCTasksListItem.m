//
// Created by Tadeas Kriz on 02/02/14.
// Copyright (c) 2014 Tadeas Kriz. All rights reserved.
//

#import "DCTasksListItem.h"
#import "DCTask.h"

@interface DCTasksListItem ()

@property (weak, nonatomic) IBOutlet UIButton* checkBox;
@property (weak, nonatomic) IBOutlet UILabel* text;

@end

@implementation DCTasksListItem {
    __weak DCTask* _task;
}

@dynamic task;

- (DCTask*)task {
    return _task;
}

- (void)setTask:(DCTask*)task {
    _task = task;
    if(task.text && ![task.text isKindOfClass:[NSNull class]]) {
        self.text.text = task.text ? task.text : @"";
    }
    self.checkBox.selected = [task.done boolValue];
}

- (IBAction)checkBoxClick:(id)sender {
    UIButton* checkBox = sender;
    checkBox.selected = !checkBox.selected;

    if (self.delegate) {
        [self.delegate tasksListItem:self checkBox:sender checkStateChanged:checkBox.selected];
    }
}

@end