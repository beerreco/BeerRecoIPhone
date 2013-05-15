//
//  BeersService.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeersService.h"

#define ServicePath_PublicData @"/public-data"
#define ServicePath_Beers @"/beers"

#define PathParam_Beer @"beer"
#define PathParam_Add @"add"
#define PathParam_Update @"update"
#define PathParam_All @"all"
#define PathParam_Places @"places"
#define PathParam_Similar @"similar"

#define QueryParam_Beer @"beer"

#define ResultPath_Beers @"beers"
#define ResultPath_Items @"items"

@implementation BeersService

-(NSString*)getFullUrlForBeerId:(NSString*)beerId
{
    return [NSString stringWithFormat:@"%@%@%@/%@/%@", BaseURL, BaseIpadPathPrefix, ServicePath_PublicData, PathParam_Beer, beerId];
}

-(void)getAllBeers:(void (^)(NSMutableArray* beers, NSError *error))onComplete
{
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Beers, PathParam_All];
    
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

-(void)getSimilarBeersTo:(NSString*)beerId onComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:beerId])
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", ServicePath_Beers, beerId, PathParam_Similar];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         NSArray *itemsFromResponse = [JSON valueForKeyPath:ResultPath_Items];
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

-(void)getPlacesByBeer:(NSString*)beerId onComplete:(void (^)(NSMutableArray* beerInPlaceViews, NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:beerId])
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", ServicePath_Beers, beerId, PathParam_Places];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         NSArray *itemsFromResponse = [JSON valueForKeyPath:ResultPath_Items];
         NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[itemsFromResponse count]];
         for (NSDictionary *json in itemsFromResponse)
         {
             BeerInPlaceViewM *item = [[BeerInPlaceViewM alloc] initWithJson:json];
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

-(void)addBeer:(BeerM*)beer onComplete:(void (^)(BeerM* beer, NSError *error))onComplete
{
    if (beer == nil)
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_Beer:[beer ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Beers, PathParam_Add];
    
    [[BeerRecoAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         BeerM* item = [[BeerM alloc] initWithJson:JSON];
         
         if (onComplete)
         {
             onComplete(item, nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (onComplete)
         {
             onComplete(nil, error);
         }
     }];
}

-(void)updateBeer:(FieldUpdateDataM*)fieldUpdateData  onComplete:(void (^)(NSError *error))onComplete
{
    if (fieldUpdateData == nil)
    {
        if (onComplete)
        {
            onComplete([NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_Beer:[fieldUpdateData ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Beers, PathParam_Update];
    
    [[BeerRecoAPIClient sharedClient] putPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
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
