//
//  OriginCountryService.m
//  BeerReco
//
//  Created by RLemberg on 5/9/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "OriginCountryService.h"

#define ServicePath_Countries @"/countries"

#define PathParam_All @"all"
#define PathParam_Beers @"beers"

#define PathParam_Add @"add"
#define PathParam_Update @"update"

#define QueryParam_BeerID @"beerId"
#define QueryParam_Country @"country"

#define ResultPath_Countries @"countries"
#define ResultPath_Beers @"beers"

@implementation OriginCountryService

-(void)getAllOriginCountries:(void (^)(NSMutableArray* countries, NSError *error))onComplete
{
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Countries, PathParam_All];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         NSArray *itemsFromResponse = [JSON valueForKeyPath:ResultPath_Countries];
         NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[itemsFromResponse count]];
         for (NSDictionary *json in itemsFromResponse)
         {
             CountryM *item = [[CountryM alloc] initWithJson:json];
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

-(void)getBeersByOriginCountry:(NSString*)countryId oncComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:countryId])
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", ServicePath_Countries, countryId, PathParam_Beers];
    
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

-(void)addOriginCountry:(CountryM*)country onComplete:(void (^)(CountryM* country, NSError *error))onComplete
{
    if (country == nil)
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_Country:[country ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Countries, PathParam_Add];
    
    [[BeerRecoAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         CountryM *item = [[CountryM alloc] initWithJson:JSON];
         
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

-(void)updateOriginCountry:(FieldUpdateDataM*)fieldUpdateData  onComplete:(void (^)(NSError *error))onComplete
{
    if (fieldUpdateData == nil)
    {
        if (onComplete)
        {
            onComplete([NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_Country:[fieldUpdateData ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Countries, PathParam_Update];
    
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
