//
//  GeneralDataStore.m
//  BeerReco
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "GeneralDataStore.h"
#import <FacebookSDK/FacebookSDK.h>

#define PersistantKey_ContributerMode @"PersistantKey_ContributerMode"

@implementation GeneralDataStore

@synthesize FBUserID = _FBUserID;
@synthesize contributerMode = _contributerMode;

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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // Read from NSUserDefaults
        self.contributerMode = [[defaults objectForKey:PersistantKey_ContributerMode] boolValue];
        
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

-(void)setFBUserID:(NSString *)FBUserID
{
    _FBUserID = FBUserID;
    
    if (![NSString isNullOrEmpty:_FBUserID])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_FB_ReceivedUser object:nil userInfo:nil];
    }
    
    [self announceContributionMode];
}

-(void)setContributerMode:(BOOL)contributerMode
{
    _contributerMode = contributerMode;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_contributerMode] forKey:PersistantKey_ContributerMode];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self announceContributionMode];
}

-(BOOL)hasFBUser
{
    return ![NSString isNullOrEmpty:self.FBUserID];
}

-(BOOL)contributionAllowed
{
    return self.hasFBUser && self.contributerMode;
}

-(void)announceContributionMode
{
    if (self.contributionAllowed)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_ContributionAllowed object:nil userInfo:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_ContributionNotAllowed object:nil userInfo:nil];
    }
}

@end
