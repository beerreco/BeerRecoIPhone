//
//  AppDelegate.m
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"
#import <Crashlytics/Crashlytics.h>

#define FlurryKey @"SMBQM78KS2KRMKX28JVR"
#define CrashlyticsKey @"32289e6bba54e988e2bbbe934024b9cf9b3c0e45"

@implementation AppDelegate

void uncaughtExceptionHandler(NSException *exception);

+(AppDelegate*)getMainApp
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

#pragma mark - Private Methods

- (void)clearTempDocuments
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (error == nil)
    {
        for (NSString *path in directoryContents)
        {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess)
            {
                // Error handling
                NSLog(@"Could not remove file: %@", fullPath);
            }
            else
            {
                NSLog(@"Removed file: %@", fullPath);
            }
        }
    }
    else
    {
        // Error handling
        NSLog(@"Could not get contents of folder: %@", documentsDirectory);
    }
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //LocalizationSetLanguage(@"he-IL");
    
    [BeerRecoAPIClient sharedClient];
    
    //[Flurry startSession:FlurryKey];
    [Crashlytics startWithAPIKey:CrashlyticsKey];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_ApplicationWillResignActive object:nil userInfo:nil];
    
    [self clearTempDocuments];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_ApplicationDidEnterBackground object:nil userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_ApplicationWillEnterForeground object:nil userInfo:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_ApplicationDidBecomeActive object:nil userInfo:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - uncaughtExceptionHandler

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@",exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

@end
