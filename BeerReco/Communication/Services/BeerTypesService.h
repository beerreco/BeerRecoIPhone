//
//  CategoriesService.h
//  BeerReco
//
//  Created by RLemberg on 4/20/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BeerTypeM.h"
#import "BeerViewM.h"
#import "FieldUpdateDataM.h"

@interface BeerTypesService : NSObject

-(void)getAllBeerTypes:(void (^)(NSMutableArray* beerTypes, NSError *error))onComplete;

-(void)getBeersByType:(NSString*)beerTypeId oncComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete;

-(void)addBeerType:(BeerTypeM*)category onComplete:(void (^)(BeerTypeM* beerType, NSError *error))onComplete;

-(void)updateBeerType:(FieldUpdateDataM*)fieldUpdateData onComplete:(void (^)(NSError *error))onComplete;

-(void)deleteBeerType:(NSString*)beerTypeId onComplete:(void (^)(NSError *error))onComplete;

@end
