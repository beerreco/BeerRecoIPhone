//
//  GeneralDataStore.m
//  BeerReco
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "GeneralDataStore.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation GeneralDataStore

@synthesize FBUserID = _FBUserID;

+ (GeneralDataStore *)sharedDataStore
{
    static GeneralDataStore *_sharedDataStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[GeneralDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

-(id)init
{
    self = [super init];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoggedIn:) name:GlobalMessage_FB_LoggedIn object:nil];
         
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoggedOut:) name:GlobalMessage_FB_LoggedOut object:nil];
    }
    
    return self;
}

#pragma mark - Notifications Handlers

-(void)facebookLoggedIn:(NSNotification*)notification
{
    NSDictionary *dict = [notification userInfo];
    NSString* userId = [dict objectForKey:@"userId"];
    
    if (![NSString isNullOrEmpty:userId])
    {
        self.FBUserID = userId;
    }
    else
    {
        if (FBSession.activeSession.isOpen)
        {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
             {
                 self.FBUserID = error ? nil : [user objectForKey:@"id"];
             }];
        }
    }
}

-(void)facebookLoggedOut:(NSNotification*)notification
{
    self.FBUserID = nil;
}

@end
