//
//  FavoriteBeersService.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FavoriteBeersService.h"

@implementation FavoriteBeersService

-(void)getPublicFavoriteBeers:(void (^)(NSArray* beers, NSError *error))onComplete
{
    NSMutableArray* beers = [[NSMutableArray alloc] init];
    
    if (onComplete)
    {
        onComplete(beers, nil);
    }
}

-(void)getFavoriteBeersForUser:(NSString*)userId onComplete:(void (^)(NSArray* beers, NSError *error))onComplete
{
    NSMutableArray* beers = [[NSMutableArray alloc] init];
    
    if (onComplete)
    {
        onComplete(beers, nil);
    }    
}


-(void)addBeerToFavorites:(NSString*)beerId forUser:(NSString*)userId onComplete:(void (^)(NSError *error))onComplete
{
    if (onComplete)
    {
        onComplete(nil);
    }
}

-(void)removeBeerFromFavorites:(NSString*)beerId forUser:(NSString*)userId onComplete:(void (^)(NSError *error))onComplete
{
    if (onComplete)
    {
        onComplete(nil);
    }
}

@end
