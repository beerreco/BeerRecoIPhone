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
#define PathParam_Update @"update"

#define QueryParam_Beer @"beer"

#define ResultPath_Beers @"beers"

@implementation BeersService

-(NSString*)getFullUrlForBeerId:(NSString*)beerId
{
    return [NSString stringWithFormat:@"%@%@%@/%@", BaseURL, BaseIpadPathPrefix, ServicePath_Beers, beerId];
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

-(void)updateBeer:(BeerM*)beer onComplete:(void (^)(BeerM* beer, NSError *error))onComplete
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
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", ServicePath_Beers, PathParam_Update];
    
    [[BeerRecoAPIClient sharedClient] putPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
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

@end
