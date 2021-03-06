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
#import <FacebookSDK/FacebookSDK.h>

#define FlurryKey @"SMBQM78KS2KRMKX28JVR"
#define CrashlyticsKey @"32289e6bba54e988e2bbbe934024b9cf9b3c0e45"

@implementation AppDelegate

void uncaughtExceptionHandler(NSException *exception);

+(AppDelegate*)getMainApp
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //LocalizationSetLanguage(@"he-IL");
    
    [BeerRecoAPIClient sharedClient];
    [GeneralDataStore sharedDataStore];
    
    //[Flurry startSession:FlurryKey];
    [Crashlytics startWithAPIKey:CrashlyticsKey];
    
    // See if we have a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        [[FacebookHelper sharedFacebookHelper] openSession:NO onComplete:^(NSError *error)
        {
             
        }];
    }
    else
    {
        
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_ApplicationWillResignActive object:nil userInfo:nil];
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
    // Facebook SDK * login flow *
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_ApplicationDidBecomeActive object:nil userInfo:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Facebook SDK * pro-tip *
    // if the app is going away, we close the session object; this is a good idea because
    // things may be hanging off the session, that need releasing (completion block, etc.) and
    // other components in the app may be awaiting close notification in order to do cleanup
    [[FacebookHelper sharedFacebookHelper] closeSession];
}

#pragma mark - uncaughtExceptionHandler

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@",exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

@end
