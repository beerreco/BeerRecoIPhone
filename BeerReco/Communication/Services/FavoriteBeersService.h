//
//  FavoriteBeersService.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteBeersService : NSObject

-(void)getPublicFavoriteBeers:(void (^)(NSArray* beers, NSError *error))onComplete;

-(void)getFavoriteBeersForUser:(NSString*)userId onComplete:(void (^)(NSArray* beers, NSError *error))onComplete;

-(void)addBeerToFavorites:(NSString*)beerId forUser:(NSString*)userId onComplete:(void (^)(NSError *error))onComplete;

-(void)removeBeerFromFavorites:(NSString*)beerId forUser:(NSString*)userId onComplete:(void (^)(NSError *error))onComplete;

@end
