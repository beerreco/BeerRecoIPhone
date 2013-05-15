//
//  PlaceTypeService.m
//  BeerReco
//
//  Created by RLemberg on 5/14/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlaceTypeService.h"

#define ServicePath_PlaceTypes @"/place-types"

#define PathParam_All @"all"
#define PathParam_Places @"places"

#define PathParam_Add @"add"
#define PathParam_Update @"update"

#define QueryParam_PlaceID @"placeId"
#define QueryParam_PlaceType @"placeType"

#define ResultPath_PlaceTypes @"placeTypes"
#define ResultPath_Places @"places"

@implementation PlaceTypeService

-(void)getAllPlaceTypes:(void (^)(NSMutableArray* placeTypes, NSError *error))onComplete
{
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_PlaceTypes, PathParam_All];
    
    [[BeerRecoAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         NSArray *itemsFromResponse = [JSON valueForKeyPath:ResultPath_PlaceTypes];
         NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[itemsFromResponse count]];
         for (NSDictionary *json in itemsFromResponse)
         {
             PlaceTypeM *item = [[PlaceTypeM alloc] initWithJson:json];
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

-(void)getPlacesByPlaceType:(NSString*)placeTypeId oncComplete:(void (^)(NSMutableArray* places, NSError *error))onComplete
{
    if ([NSString isNullOrEmpty:placeTypeId])
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", ServicePath_PlaceTypes, placeTypeId, PathParam_Places];
    
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

-(void)addPlaceType:(PlaceTypeM*)placeType onComplete:(void (^)(PlaceTypeM* placeType, NSError *error))onComplete
{
    if (placeType == nil)
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_PlaceType:[placeType ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_PlaceTypes, PathParam_Add];
    
    [[BeerRecoAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         PlaceTypeM *item = [[PlaceTypeM alloc] initWithJson:JSON];
         
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

-(void)updatePlaceType:(FieldUpdateDataM*)fieldUpdateData  onComplete:(void (^)(NSError *error))onComplete
{
    if (fieldUpdateData == nil)
    {
        if (onComplete)
        {
            onComplete([NSError errorWithDomain:@"" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary* params = @{QueryParam_PlaceType:[fieldUpdateData ToDictionary]};
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_PlaceTypes, PathParam_Update];
    
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
