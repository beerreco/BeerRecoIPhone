//
//  CategoriesService.m
//  BeerReco
//
//  Created by RLemberg on 4/20/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerTypesService.h"

#define ServicePath_BeerTypes @"/beer-types"

#define PathParam_All @"all"
#define PathParam_Beers @"beers"

#define PathParam_Add @"add"
#define PathParam_Update @"update"

#define QueryParam_BeerID @"beerId"
#define QueryParam_BeerType @"beerType"

#define ResultPath_BeerTypes @"beerTypes"
#define ResultPath_Beers @"beers"

@implementation BeerTypesService

-(void)getAllBeerTypes:(void (^)(NSMutableArray* beerTypes, NSError *error))onComplete
{
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_BeerTypes, PathParam_All];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         NSArray *itemsFromResponse = [JSON valueForKeyPath:ResultPath_BeerTypes];
         NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[itemsFromResponse count]];
         for (NSDictionary *json in itemsFromResponse)
         {
             BeerTypeM *item = [[BeerTypeM alloc] initWithJson:json];
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

-(void)getBeersByType:(NSString*)beerTypeId oncComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:beerTypeId])
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", ServicePath_BeerTypes, beerTypeId, PathParam_Beers];
    
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

-(void)addBeerType:(BeerTypeM*)category onComplete:(void (^)(BeerTypeM* beerType, NSError *error))onComplete
{
    if (category == nil)
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_BeerType:[category ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_BeerTypes, PathParam_Add];
    
    [[BeerRecoAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         BeerTypeM *item = [[BeerTypeM alloc] initWithJson:JSON];
         
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

-(void)updateBeerType:(FieldUpdateDataM*)fieldUpdateData  onComplete:(void (^)(NSError *error))onComplete
{
    if (fieldUpdateData == nil)
    {
        if (onComplete)
        {
            onComplete([NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_BeerType:[fieldUpdateData ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_BeerTypes, PathParam_Update];
    
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
