//
//  FacebookHelper.m
//  BeerReco
//
//  Created by RLemberg on 4/30/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FacebookHelper.h"

@implementation FacebookHelper

+ (FacebookHelper*)sharedFacebookHelper
{
    static FacebookHelper *_sharedFacebookHelper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFacebookHelper = [[FacebookHelper alloc] init];
    });
    
    return _sharedFacebookHelper;
}

-(BOOL)hasSessionWithAccessToken
{
    if (FBSession.activeSession == nil ||
        !FBSession.activeSession.isOpen ||
        FBSession.activeSession.accessTokenData == nil ||
        FBSession.activeSession.accessTokenData.accessToken == nil)
    {
        return false;
    }
    
    return true;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"state = %d",state);
    switch (state)
    {
        case FBSessionStateOpen:
        {
            NSLog(@"state = FBSessionStateOpen");
            
            if (!error)
            {
                NSLog(@"Valid open session");
                [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_FB_LoggedIn object:nil userInfo:nil];
            }
            
            break;
        }
        case FBSessionStateClosed:
        {
            NSLog(@"state = FBSessionStateClosed");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_FB_LoggedOut object:nil userInfo:nil];
            
            break;
        }
        case FBSessionStateClosedLoginFailed:
        {
            NSLog(@"state = FBSessionStateClosedLoginFailed");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_FB_LoggedOut object:nil userInfo:nil];
            break;
        }
        default:
            break;
    }
    
    if (error)
    {
        NSLog(@"%@", error);
    }
}

 -(void)closeSession
{
    [self closeSession:NO];
}

-(void)closeSession:(BOOL)fullClose
{
    if (FBSession.activeSession != nil)
    {
        if (!fullClose)
        {
            [FBSession.activeSession close];
            return;
        }
        else
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            [FBSession setActiveSession:nil];
        }
    }
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage* storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies])
    {
        NSString *domainStr = (NSString *)[cookie domain];
       
        if([domainStr isEqualToString:@".facebook.com" ])
        {
             NSLog(@"delete cookie of domain: %@",domainStr);
            [storage deleteCookie:cookie];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)openSession:(void (^)(NSError *error))onComplete
{
    [self openSession:YES onComplete:onComplete];
}

-(void)openSession:(BOOL)newSession onComplete:(void (^)(NSError *error))onComplete
{
    if (!newSession && [self hasSessionWithAccessToken])
    {
        if (onComplete)
        {
            onComplete(nil);
        }
    }
    else
    {
        if (newSession)
        {
            [self closeSession:YES];
        }
                
        [self openActiveSessionWithPermissions:[self getPublishPermissions] allowLoginUI:YES allowSystemAccount:NO isRead:NO isNew:newSession defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             [self sessionStateChanged:session state:status error:error];
             
             if (onComplete)
             {
                 onComplete(error);
             }
         }];
    }
}

-(BOOL)openActiveSessionWithPermissions:(NSArray*)permissions
                            allowLoginUI:(BOOL)allowLoginUI
                      allowSystemAccount:(BOOL)allowSystemAccount
                                  isRead:(BOOL)isRead
                                  isNew:(BOOL)isNew
                         defaultAudience:(FBSessionDefaultAudience)defaultAudience
                       completionHandler:(FBSessionStateHandler)handler
{
    BOOL result = NO;
    FBSession *session = [[FBSession alloc] initWithAppID:nil
                                               permissions:permissions
                                           defaultAudience:defaultAudience
                                           urlSchemeSuffix:nil
                                        tokenCacheStrategy:nil];
    
    if (allowLoginUI || session.state == FBSessionStateCreatedTokenLoaded)
    {
        [FBSession setActiveSession:session];
        
        // we open after the fact, in order to avoid overlapping close
        // and open handler calls for blocks
        FBSessionLoginBehavior howToBehave = allowSystemAccount ?
        FBSessionLoginBehaviorUseSystemAccountIfPresent :
        isNew ? FBSessionLoginBehaviorForcingWebView : FBSessionLoginBehaviorWithFallbackToWebView;
        
        [session openWithBehavior:howToBehave
                completionHandler:handler];
        result = session.isOpen;
    }
    
    return result;
}

-(void)requestFBPermissions:(void (^)(NSError *error))onComplete
{
    [FBSession openActiveSessionWithPublishPermissions:[self getPublishPermissions] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
     {
         if (onComplete)
         {
             onComplete(error);
         }
     }];
}

-(NSArray*)getReadPermissions
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes",
                            nil];
    
    return permissions;
}

-(NSArray*)getPublishPermissions
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"publish_actions",
                            nil];
    
    return permissions;
}

-(void)checkIfExternalObjectExists:(NSString*)objectId onComplete:(void (^)(BOOL exist, NSError *error))onComplete
{
    [FBRequestConnection startWithGraphPath:objectId
                                 parameters:nil HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", error);
             
             if (onComplete)
             {
                 onComplete(NO, error);
             }
         }
         else
         {
             if (onComplete)
             {
                 onComplete(YES, error);
             }
         }
     }];
}

-(void)checkIfExternalObjectIsLiked:(NSString*)objectId onComplete:(void (^)(BOOL liked, NSError *error))onComplete
{
    [self checkIfExternalObjectExists:objectId onComplete:^(BOOL exist, NSError *error)
    {
        if (exist)
        {
            NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
            action[@"object"] = objectId;
            
            [FBRequestConnection startWithGraphPath:@"me/og.likes"
                                         parameters:action HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection,
                                                      id result,
                                                      NSError *innerError)
             {
                 if (innerError)
                 {
                     NSLog(@"%@", innerError);
                     
                     if (onComplete)
                     {
                         onComplete(NO, innerError);
                     }
                 }
                 else
                 {                     
                     NSArray* data = [result valueForKey:@"data"];
                     
                     if (onComplete)
                     {
                         onComplete(data != nil && data.count != 0, innerError);
                     }
                 }
             }];
        }
        else
        {
            if (onComplete)
            {
                onComplete(NO, error);
            }
        }
    }];
}

-(void)getLikeObjectIdOnExternalObject:(NSString*)objectId onComplete:(void (^)(NSString* likeObjectId, NSError *error))onComplete
{
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
    action[@"object"] = objectId;
    
    [FBRequestConnection startWithGraphPath:@"me/og.likes"
                                 parameters:action HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", error);
             
             if (onComplete)
             {
                 onComplete(NO, error);
             }
         }
         else
         {
             NSString* likedObjectId = nil;
             NSArray* data = [result valueForKey:@"data"];
             if (data != nil && data.count != 0)
             {
                 likedObjectId = [[data objectAtIndex:0] valueForKey:@"id"];
             }
             
             if (onComplete)
             {
                 onComplete(likedObjectId, error);
             }
         }
     }];
}

-(void)getCommentsCountForExternalObject:(NSString*)objectId onComplete:(void (^)(int commentsCount, NSError *error))onComplete
{
    [FBRequestConnection startWithGraphPath:objectId
                                 parameters:nil HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         int count = 0;
         
         if (error)
         {
             NSLog(@"%@", error);
             
             if (onComplete)
             {
                 onComplete(count, error);
             }
         }
         else
         {
             count = [[result valueForKey:@"comments"] intValue];
             
             if (onComplete)
             {
                 onComplete(count, error);
             }
         }
     }];
}

-(void)likeExternalObject:(NSString*)objectId onComplete:(void (^)(BOOL added, NSError *error))onComplete
{
    if (![self hasSessionWithAccessToken])
    {
        if (onComplete)
        {
            onComplete(NO, [NSError errorWithDomain:@"No Access Token" code:-1 userInfo:nil]);
        }
    }
    
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
    action[@"object"] = objectId;
    action[@"accessToken"] = FBSession.activeSession.accessTokenData.accessToken;
    
    [FBRequestConnection startForPostWithGraphPath:@"me/og.likes"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error)
     {
         BOOL ret = NO;
         
         if (error)
         {
             NSLog(@"%@", error);
             
             if (error.userInfo)
             {
                 id facebookResponse = [error.userInfo valueForKey:@"com.facebook.sdk:ParsedJSONResponseKey"];
                 if (facebookResponse)
                 {
                     id body = [facebookResponse valueForKey:@"body"];
                     if (body)
                     {
                         id err = [body valueForKey:@"error"];
                         if (err)
                         {
                             id code = [[err valueForKey:@"code"] stringValue];
                             if (code && [code isEqualToString:@"3501"])
                             {
                                 ret = YES;
                             }
                         }
                     }
                 }
             }
         }
         else
         {
             NSLog(@"%@", result);
             
             ret = YES;
         }
         
         if (onComplete)
         {
             onComplete(ret, error);
         }
     }];
}

-(void)removeOGObject:(NSString*)objectId onComplete:(void (^)(BOOL deleted, NSError *error))onComplete
{
    if (![self hasSessionWithAccessToken])
    {
        if (onComplete)
        {
            onComplete(NO, [NSError errorWithDomain:@"No Access Token" code:-1 userInfo:nil]);
        }
    }
    
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
    action[@"accessToken"] = FBSession.activeSession.accessTokenData.accessToken;
    
    [FBRequestConnection startWithGraphPath:objectId
                                 parameters:action HTTPMethod:@"DELETE"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", error);
             
             if (onComplete)
             {
                 onComplete(NO, error);
             }
         }
         else
         {
             NSLog(@"%@", result);
             
             NSString* res = [[result valueForKey:@"FACEBOOK_NON_JSON_RESULT"] stringValue];
             
             if (onComplete)
             {
                 onComplete((res != nil && [res isKindOfClass:([NSString class])] && [res isEqualToString:TrueStr]), error);
             }
         }
     }];
}

@end
