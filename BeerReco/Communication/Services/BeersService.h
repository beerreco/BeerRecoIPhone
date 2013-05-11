//
//  BeersService.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BeerM.h"
#import "BeerInPlaceViewM.h"

@interface BeersService : NSObject

-(NSString*)getFullUrlForBeerId:(NSString*)beerId;

-(void)getAllBeers:(void (^)(NSMutableArray* beers, NSError *error))onComplete;

-(void)getPlacesByBeer:(NSString*)beerId onComplete:(void (^)(NSMutableArray* beerInPlaceViews, NSError *error))onComplete;

-(void)addBeer:(BeerM*)beer onComplete:(void (^)(BeerM* beer, NSError *error))onComplete;

-(void)updateBeer:(BeerM*)beer onComplete:(void (^)(BeerM* beer, NSError *error))onComplete;

@end
