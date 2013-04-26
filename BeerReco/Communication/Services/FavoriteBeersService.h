//
//  FavoriteBeersService.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BeerViewM.h"

@interface FavoriteBeersService : NSObject

-(void)getPublicFavoriteBeers:(void (^)(NSMutableArray* beers, NSError *error))onComplete;

-(void)getFavoriteBeersForUser:(void (^)(NSMutableArray* beers, NSError *error))onComplete;

-(void)isBeerInFavorites:(NSString*)beerId onComplete:(void (^)(BOOL inFavorites, NSError *error))onComplete;

-(void)addBeerToFavorites:(NSString*)beerId onComplete:(void (^)(NSError *error))onComplete;

-(void)removeBeerFromFavorites:(NSString*)beerId onComplete:(void (^)(NSError *error))onComplete;

@end
