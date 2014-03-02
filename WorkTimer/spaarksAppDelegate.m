//
//  spaarksAppDelegate.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "spaarksAppDelegate.h"

@implementation spaarksAppDelegate

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after app launch.
//    ChooseTimesheetToolViewController *settingsView =
//        [[ChooseTimesheetToolViewController alloc]init];
//    [self.window addSubview:settingsView.view];
//    [self.window makeKeyAndVisible];
//    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//-(ButtonGridViewController*)GetButtonGridViewController
//{
//UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//MasterViewController *result;
//
////check to see if navbar "get" worked
//if (navigationController.viewControllers)
//
////look for the nav controller in tab bar views
//for (UINavigationController *view in navigationController.viewControllers) {
//    
//    //when found, do the same thing to find the MasterViewController under the nav controller
//    if ([view isKindOfClass:[UINavigationController class]])
//        for (UIViewController *view2 in view.viewControllers)
//            if ([view2 isKindOfClass:[MasterViewController class]])
//                result = (MasterViewController *) view2;
//}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.


    //Fetch the running task
    
    //Save the running task to the database
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    //Fetch the running task from the database
    //Call method to restart the timer
    //NB - Might have to mark the task to be loaded later in the cycle
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [Repository closeSettingsDatabase];
}

@end
