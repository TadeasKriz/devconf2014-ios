//
//  DCAppDelegate.m
//  Dev Conf 2014 iOS
//
//  Created by Tadeas Kriz on 02/02/14.
//  Copyright (c) 2014 Tadeas Kriz. All rights reserved.
//

#import "DCAppDelegate.h"
#import "AGDeviceRegistration.h"
#import "DCTasksListController.h"

@implementation DCAppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [[UIApplication sharedApplication]
                    registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing unfinishedTasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication*)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication*)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication*)application {
    // Restart any unfinishedTasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication*)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    AGDeviceRegistration* registration = [[AGDeviceRegistration alloc]
                                                                initWithServerURL:[NSURL URLWithString:@"https://devconf2014push-detox.rhcloud.com/"]];

    [registration registerWithClientInfo:^(id <AGClientDeviceInformation> clientInfo) {

        [clientInfo setDeviceToken:deviceToken];
        [clientInfo setVariantID:@"17cc9223-550d-4a78-8885-495e2a30924f"];
        [clientInfo setVariantSecret:@"c4d5c267-8871-4ea9-9d55-a272719c7eaf"];

        // --optional config--
        UIDevice* currentDevice = [UIDevice currentDevice];
        [clientInfo setOperatingSystem:[currentDevice systemName]];
        [clientInfo setOsVersion:[currentDevice systemVersion]];
        [clientInfo setDeviceType:[currentDevice model]];
    }                            success:^() {
        NSLog(@"PushEE registration worked");
    }                            failure:^(NSError* error) {
        NSLog(@"PushEE registration Error: %@", error);
    }];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    UINavigationController* navigationController = (UINavigationController*) self.window.rootViewController;

    DCTasksListController* controller = [navigationController.viewControllers firstObject];
    [controller reloadTasks];
}

@end