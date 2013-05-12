//
//  PlacesService.h
//  BeerReco
//
//  Created by RLemberg on 4/20/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PlaceM.h"

@interface PlacesService : NSObject

-(NSString*)getFullUrlForPlaceId:(NSString*)placeId;

-(void)getAllPlaces:(void (^)(NSMutableArray* places, NSError *error))onComplete;

-(void)getBeersByPlace:(NSString*)placeId onComplete:(void (^)(NSMutableArray* beerInPlaceViews, NSError *error))onComplete;

-(void)addPlace:(PlaceM*)place onComplete:(void (^)(PlaceM* place, NSError *error))onComplete;

-(void)updatePlace:(PlaceM*)place onComplete:(void (^)(PlaceM* place, NSError *error))onComplete;

-(void)addBeer:(NSString*)beerId toPlace:(NSString*)placeId onComplete:(void (^)(BeerInPlaceM * beerInPlace, NSError *error))onComplete;
-(void)addBeer:(NSString*)beerId toPlace:(NSString*)placeId withPrice:(double)price onComplete:(void (^)(BeerInPlaceM * beerInPlace, NSError *error))onComplete;

@end
