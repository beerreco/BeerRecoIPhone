//
//  PlacesService.m
//  BeerReco
//
//  Created by RLemberg on 4/20/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlacesService.h"

#define ServicePath_PublicData @"/public-data"
#define ServicePath_Places @"/places"
#define ServicePath_BeerInPlace @"/beer-in-place"

#define PathParam_Place @"place"
#define PathParam_All @"all"
#define PathParam_Add @"add"
#define PathParam_Update @"update"
#define PathParam_Beers @"beers"

#define QueryParam_Place @"place"
#define QueryParam_BeerInPlace @"beerInPlace"
#define QueryParam_FieldUpdateData @"fieldUpdateData"

#define ResultPath_Places @"places"
#define ResultPath_Items @"items"

@implementation PlacesService

-(NSString*)getFullUrlForPlaceId:(NSString*)placeId
{
    return [NSString stringWithFormat:@"%@%@%@/%@/%@", BaseURL, BaseIpadPathPrefix, ServicePath_PublicData, PathParam_Place, placeId];
}

-(void)getAllPlaces:(void (^)(NSMutableArray* places, NSError *error))onComplete
{
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Places, PathParam_All];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         NSArray *itemsFromResponse = [JSON valueForKeyPath:ResultPath_Places];
         NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[itemsFromResponse count]];
         for (NSDictionary *json in itemsFromResponse)
         {
             PlaceViewM *item = [[PlaceViewM alloc] initWithJson:json];
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

-(void)getBeersByPlace:(NSString*)placeId onComplete:(void (^)(NSMutableArray* beerInPlaceViews, NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:placeId])
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", ServicePath_Places, placeId, PathParam_Beers];
    
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

-(void)addPlace:(PlaceM *)place onComplete:(void (^)(PlaceM *, NSError *))onComplete
{
    if (place == nil)
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_Place:[place ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Places, PathParam_Add];
    
    [[BeerRecoAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         PlaceM* item = [[PlaceM alloc] initWithJson:JSON];
         
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

-(void)updatePlace:(FieldUpdateDataM*)fieldUpdateData  onComplete:(void (^)(NSError *))onComplete
{
    if (fieldUpdateData == nil)
    {
        if (onComplete)
        {
            onComplete([NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_FieldUpdateData:[fieldUpdateData ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Places, PathParam_Update];
    
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

-(void)addBeer:(NSString*)beerId toPlace:(NSString*)placeId onComplete:(void (^)(BeerInPlaceM * beerInPlace, NSError *error))onComplete
{
    [self addBeer:beerId toPlace:placeId withPrice:0 onComplete:onComplete];
}

-(void)addBeer:(NSString*)beerId toPlace:(NSString*)placeId withPrice:(double)price onComplete:(void (^)(BeerInPlaceM * beerInPlace, NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:beerId] || [NSString isNullOrEmpty:placeId])
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    BeerInPlaceM* beerInPlace = [[BeerInPlaceM alloc] init];
    beerInPlace.beerId = beerId;
    beerInPlace.placeId = placeId;
    beerInPlace.price = price;
    
    NSDictionary* params = @{QueryParam_BeerInPlace:[beerInPlace ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_BeerInPlace, PathParam_Add];
    
    [[BeerRecoAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         BeerInPlaceM* item = [[BeerInPlaceM alloc] initWithJson:JSON];
         
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

-(void)updateBeerInPlace:(FieldUpdateDataM*)fieldUpdateData onComplete:(void (^)(NSError *error))onComplete
{
    if (fieldUpdateData == nil)
    {
        if (onComplete)
        {
            onComplete([NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_FieldUpdateData:[fieldUpdateData ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_BeerInPlace, PathParam_Update];
    
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
