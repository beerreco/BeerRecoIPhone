//
//  BreweryService.h
//  BeerReco
//
//  Created by RLemberg on 5/13/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldUpdateDataM.h"

@interface BreweryService : NSObject

-(void)getAllBreweries:(void (^)(NSMutableArray* breweries, NSError *error))onComplete;

-(void)getBeersByBrewery:(NSString*)breweryId oncComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete;

-(void)addBrewery:(BreweryM*)brewery onComplete:(void (^)(BreweryM* brewery, NSError *error))onComplete;

-(void)updateBrewery:(FieldUpdateDataM*)fieldUpdateData  onComplete:(void (^)(NSError *error))onComplete;

@end
