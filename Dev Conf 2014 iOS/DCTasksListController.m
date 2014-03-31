//
//  DCTasksListController.m
//  Dev Conf 2014 iOS
//
//  Created by Tadeas Kriz on 02/02/14.
//  Copyright (c) 2014 Tadeas Kriz. All rights reserved.
//

#import "DCTasksListController.h"
#import "DCTasksListItem.h"
#import "AGDataManager.h"
#import "DCAddTaskController.h"
#import "DCTask.h"
#import "AGPipeline.h"

typedef NS_ENUM(NSUInteger, DCActiveTasksList) {
    kDCActiveTasksListNone, kDCActiveTasksListUnfinished, kDCActiveTasksListFinished, kDCActiveTasksListBoth
};

@interface DCTasksListController () <DCAddTaskControllerDelegate, DCTasksListItemDelegate>

@property (nonatomic, strong) NSArray* unfinishedTasks;
@property (nonatomic, strong) NSArray* finishedTasks;

@property (nonatomic, strong) AGPipeline* mainPipeline;
@property (nonatomic, strong) id <AGPipe> tasksPipe;

@end

@implementation DCTasksListController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                      initWithTitle:@""
                              style:UIBarButtonItemStyleBordered
                             target:nil
                             action:nil];

    NSURL* serverURL = [NSURL URLWithString:@"http://devconf2014-detox.rhcloud.com/rest/"];

    self.mainPipeline = [AGPipeline pipelineWithBaseURL:serverURL];

    self.tasksPipe = [self.mainPipeline pipe:^(id <AGPipeConfig> config) {
        [config setName:@"tasks"];
        [config setRecordId:@"id"];
    }];

    [self reloadTasks];
}

- (void)reloadTasks {

    [self.tasksPipe read:^(id responseObject) {
        NSArray* tasksDictionary = responseObject;

        NSMutableArray* unfinishedTasks = [[NSMutableArray alloc] init];
        NSMutableArray* finishedTasks = [[NSMutableArray alloc] init];

        for (NSDictionary* taskDictionary in tasksDictionary) {
            DCTask* task = [[DCTask alloc] initWithDictionary:taskDictionary];
            if ([task.done boolValue]) {
                [finishedTasks addObject:task];
            } else {
                [unfinishedTasks addObject:task];
            }
        }

        self.unfinishedTasks = unfinishedTasks;
        self.finishedTasks = finishedTasks;
        [self.tableView reloadData];
    }            failure:^(NSError* error) {
        NSLog(@"%@, %@", error, [error userInfo]);

        [[[UIAlertView alloc]
                       initWithTitle:@"Error"
                             message:[NSString stringWithFormat:@"%@, %@", error, [error userInfo]]
                            delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles:nil] show];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addTask"] || [segue.identifier isEqualToString:@"editTask"]) {

        DCAddTaskController* controller = segue.destinationViewController;
        controller.delegate = self;
        if([sender isKindOfClass:[DCTasksListItem class]]) {
            controller.task = [sender task];
        }
    }
}

- (DCActiveTasksList)activeTasksList {
    NSUInteger unfinishedCount = [self.unfinishedTasks count];
    NSUInteger finishedCount = [self.finishedTasks count];
    if (unfinishedCount > 0 && finishedCount > 0) {
        return kDCActiveTasksListBoth;
    } else if (unfinishedCount == 0 && finishedCount > 0) {
        return kDCActiveTasksListFinished;
    } else if (unfinishedCount > 0 && finishedCount == 0) {
        return kDCActiveTasksListUnfinished;
    } else {
        return kDCActiveTasksListNone;
    }
}

- (DCTask*)taskForIndexPath:(NSIndexPath*)indexPath {
    DCActiveTasksList activeTasksList = [self activeTasksList];
    if (indexPath.section == 0 && activeTasksList != kDCActiveTasksListFinished) {
        return [self.unfinishedTasks objectAtIndex:(NSUInteger) indexPath.row];
    } else {
        return [self.finishedTasks objectAtIndex:(NSUInteger) indexPath.row];
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    DCActiveTasksList activeTasksList = [self activeTasksList];
    if (section == 0 && activeTasksList != kDCActiveTasksListFinished) {
        return [self.unfinishedTasks count];
    } else {
        return [self.finishedTasks count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    switch ([self activeTasksList]) {
        case kDCActiveTasksListUnfinished:
        case kDCActiveTasksListFinished:
            return 1;
        case kDCActiveTasksListBoth:
            return 2;
        case kDCActiveTasksListNone:
        default:
            return 0;
    }
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    DCActiveTasksList activeTasksList = [self activeTasksList];
    if (section == 0 && activeTasksList != kDCActiveTasksListFinished) {
        return @"THINGS TO DO";
    } else {
        return @"THINS I'VE DONE";
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    DCTasksListItem* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    DCTask* task = [self taskForIndexPath:indexPath];
    cell.delegate = self;
    cell.task = task;
    return cell;
}

- (void)addTaskController:(DCAddTaskController*)controller saveTask:(DCTask*)task {
    [self.tasksPipe save:[task toDictionary] success:^(id responseObject) {
        // We do nothing and wait for the push notification to reload data

    }            failure:^(NSError* error) {

        NSLog(@"%@, %@", error, [error userInfo]);

        [[[UIAlertView alloc]
                       initWithTitle:@"Error"
                             message:[NSString stringWithFormat:@"%@, %@", error, [error userInfo]]
                            delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles:nil] show];
    }];
}

- (void)addTaskController:(DCAddTaskController*)controller deleteTask:(DCTask*)task {
    [self.tasksPipe remove:[task toDictionary] success:^(id responseObject) {
        // We do nothing and wait for the push notification to reload data
    }              failure:^(NSError* error) {
        NSLog(@"%@, %@", error, [error userInfo]);

        [[[UIAlertView alloc]
                       initWithTitle:@"Error"
                             message:[NSString stringWithFormat:@"%@, %@", error, [error userInfo]]
                            delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles:nil] show];
    }];
}

- (void)tasksListItem:(DCTasksListItem*)item checkBox:(UIButton*)checkBox checkStateChanged:(BOOL)checked {
    item.task.done = @(checked);
    [self.tasksPipe save:[item.task toDictionary] success:^(id responseObject) {
        // We do nothing and wait for the push notification to reload data
    }            failure:^(NSError* error) {
        NSLog(@"%@, %@", error, [error userInfo]);

        [[[UIAlertView alloc]
                       initWithTitle:@"Error"
                             message:[NSString stringWithFormat:@"%@, %@", error, [error userInfo]]
                            delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles:nil] show];
    }];
}

@end