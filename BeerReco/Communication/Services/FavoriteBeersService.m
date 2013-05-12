//
//  FavoriteBeersService.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FavoriteBeersService.h"

#define ServicePath_Favorites @"/favorite"

#define PathParam_All @"all"
#define PathParam_Delete @"delete"
#define PathParam_Add @"add"
#define PathParam_InFavorites @"is-in-favorites"

#define QueryParam_UserID @"userId"
#define QueryParam_BeerID @"beerId"

#define ResultPath_Beers @"beers"
#define ResultPath_Value @"value"

@implementation FavoriteBeersService

-(void)getPublicFavoriteBeers:(void (^)(NSMutableArray* beers, NSError *error))onComplete
{    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Favorites, PathParam_All];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         NSArray *itemsFromResponse = [JSON valueForKeyPath:ResultPath_Beers];
         NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[itemsFromResponse count]];
         for (NSDictionary *json in itemsFromResponse)
         {
             BeerViewM *item = [[BeerViewM alloc] initWithJson:json];
             [mutableItems addObject:item];
         }
         
         if (onComplete)
         {
             onComplete(mutableItems, nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (onComplete)
         {
             onComplete(nil, error);
         }
     }];
}

-(void)getFavoriteBeersForUser:(void (^)(NSMutableArray* beers, NSError *error))onComplete
{    
    if ([NSString isNullOrEmpty:[GeneralDataStore sharedDataStore].FBUserID])
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Favorites, [GeneralDataStore sharedDataStore].FBUserID];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         NSArray *itemsFromResponse = [JSON valueForKeyPath:ResultPath_Beers];
         NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[itemsFromResponse count]];
         for (NSDictionary *json in itemsFromResponse)
         {
             BeerViewM *item = [[BeerViewM alloc] initWithJson:json];
             [mutableItems addObject:item];
         }
         
         if (onComplete)
         {
             onComplete(mutableItems, nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (onComplete)
         {
             onComplete(nil, error);
         }
     }];
}

-(void)isBeerInFavorites:(NSString*)beerId onComplete:(void (^)(BOOL inFavorites, NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:[GeneralDataStore sharedDataStore].FBUserID] || [NSString isNullOrEmpty:beerId])
    {
        if (onComplete)
        {
            onComplete(NO, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_UserID:[GeneralDataStore sharedDataStore].FBUserID, QueryParam_BeerID:beerId};
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Favorites, PathParam_InFavorites];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         BOOL inFav = [[JSON valueForKey:ResultPath_Value] boolValue];
         
         if (onComplete)
         {
             onComplete(inFav, nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (onComplete)
         {
             onComplete(NO, error);
         }
     }];
}

-(void)addBeerToFavorites:(NSString*)beerId onComplete:(void (^)(NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:[GeneralDataStore sharedDataStore].FBUserID])
    {
        if (onComplete)
        {
            onComplete([NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_UserID:[GeneralDataStore sharedDataStore].FBUserID, QueryParam_BeerID:beerId};
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Favorites, PathParam_Add];
    
    [[BeerRecoAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {         
         if (onComplete)
         {
             onComplete(nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (onComplete)
         {
             onComplete(error);
         }
     }];
}

-(void)removeBeerFromFavorites:(NSString*)beerId onComplete:(void (^)(NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:[GeneralDataStore sharedDataStore].FBUserID])
    {
        if (onComplete)
        {
            onComplete([NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }

    NSDictionary* params = @{QueryParam_UserID:[GeneralDataStore sharedDataStore].FBUserID, QueryParam_BeerID:beerId};
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Favorites, PathParam_Delete];
    
    [[BeerRecoAPIClient sharedClient] deletePath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         if (onComplete)
         {
             onComplete(nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (onComplete)
         {
             onComplete(error);
         }
     }];
}

@end
