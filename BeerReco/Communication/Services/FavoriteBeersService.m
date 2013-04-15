//
//  FavoriteBeersService.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FavoriteBeersService.h"
#import "BeerM.h"

#define ServicePath_Favorites @"/favorite"

#define PathParam_All @"all"
#define PathParam_Delete @"Delete"
#define PathParam_Add @"Add"

#define QueryParam_UserID @"userId"
#define QueryParam_BeerID @"beerId"

#define ResultPath_Beers @"beer"

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
             BeerM *item = [[BeerM alloc] initWithJson:json];
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
             BeerM *item = [[BeerM alloc] initWithJson:json];
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
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
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
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
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
