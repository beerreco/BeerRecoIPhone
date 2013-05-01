//
//  FacebookHelper.h
//  BeerReco
//
//  Created by RLemberg on 4/30/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookHelper : NSObject

+ (FacebookHelper*)sharedFacebookHelper;

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error;
-(void)closeSession;
-(void)closeSession:(BOOL)fullClose;
-(void)openSession:(void (^)(NSError *error))onComplete;
-(void)openSession:(BOOL)newSession onComplete:(void (^)(NSError *error))onComplete;

-(BOOL)hasSessionWithAccessToken;

-(NSArray*)getReadPermissions;
-(NSArray*)getPublishPermissions;

-(void)checkIfExternalObjectExists:(NSString*)objectId onComplete:(void (^)(BOOL exist, NSError *error))onComplete;

-(void)checkIfExternalObjectIsLiked:(NSString*)objectId onComplete:(void (^)(BOOL liked, NSError *error))onComplete;

-(void)getLikeObjectIdOnExternalObject:(NSString*)objectId onComplete:(void (^)(NSString* likeObjectId, NSError *error))onComplete;

-(void)getCommentsCountForExternalObject:(NSString*)objectId onComplete:(void (^)(int commentsCount, NSError *error))onComplete;

-(void)likeExternalObject:(NSString*)objectId onComplete:(void (^)(BOOL added, NSError *error))onComplete;

-(void)removeOGObject:(NSString*)objectId onComplete:(void (^)(BOOL deleted, NSError *error))onComplete;

@end
