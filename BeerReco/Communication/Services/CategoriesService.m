//
//  CategoriesService.m
//  BeerReco
//
//  Created by RLemberg on 4/20/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "CategoriesService.h"

#define ServicePath_Categories @"/categories"

#define PathParam_All @"all"
#define PathParam_Beers @"beers"

#define PathParam_Add @"add"
#define PathParam_Update @"update"

#define QueryParam_BeerID @"beerId"
#define QueryParam_BeerType @"beerType"

#define ResultPath_Categories @"beerTypes"
#define ResultPath_Beers @"beers"

@implementation CategoriesService

-(void)getAllCategories:(void (^)(NSMutableArray* categories, NSError *error))onComplete
{
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Categories, PathParam_All];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         NSArray *itemsFromResponse = [JSON valueForKeyPath:ResultPath_Categories];
         NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[itemsFromResponse count]];
         for (NSDictionary *json in itemsFromResponse)
         {
             BeerCategoryM *item = [[BeerCategoryM alloc] initWithJson:json];
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

-(void)getBeersByCatergory:(NSString*)categoryId oncComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:categoryId])
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", ServicePath_Categories, categoryId, PathParam_Beers];
    
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

-(void)addBeerCategory:(BeerCategoryM*)beerCategory onComplete:(void (^)(BeerCategoryM* beerCategory, NSError *error))onComplete
{
    if (beerCategory == nil)
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_BeerType:[beerCategory ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Categories, PathParam_Add];
    
    [[BeerRecoAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         BeerCategoryM *item = [[BeerCategoryM alloc] initWithJson:JSON];
         
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

-(void)updateBeerCategory:(BeerCategoryM*)beerCategory onComplete:(void (^)(BeerCategoryM* beerCategory, NSError *error))onComplete
{
    if (beerCategory == nil)
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_BeerType:[beerCategory ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Categories, PathParam_Update];
    
    [[BeerRecoAPIClient sharedClient] putPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         BeerCategoryM *item = [[BeerCategoryM alloc] initWithJson:JSON];
         
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

@end
