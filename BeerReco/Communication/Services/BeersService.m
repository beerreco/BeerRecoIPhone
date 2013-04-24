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
