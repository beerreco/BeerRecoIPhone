//
//  BeersService.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeersService.h"

#define ServicePath_Beers @"/beers"

#define PathParam_Add @"add"

#define QueryParam_Beer @"beer"

#define ResultPath_Beers @"beers"

@implementation BeersService

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
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Beers, categoryId];
    
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

-(void)addBeer:(BeerM*)beer onComplete:(void (^)(NSError *error))onComplete
{
    if (beer == nil)
    {
        if (onComplete)
        {
            onComplete([NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_Beer:[beer ToDictionary]};
    //NSDictionary* dict = @{@"id": @"id", @"name": @"name"};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Beers, PathParam_Add];
    
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

@end
