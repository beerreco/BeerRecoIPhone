//
//  CategoriesService.h
//  BeerReco
//
//  Created by RLemberg on 4/20/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BeerCategoryM.h"
#import "BeerViewM.h"

@interface CategoriesService : NSObject

-(void)getAllCategories:(void (^)(NSMutableArray* categories, NSError *error))onComplete;

-(void)getBeersByCatergory:(NSString*)categoryId oncComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete;

-(void)addBeerCategory:(BeerCategoryM*)category onComplete:(void (^)(BeerCategoryM* beerCategory, NSError *error))onComplete;

-(void)updateBeerCategory:(BeerCategoryM*)category onComplete:(void (^)(BeerCategoryM* beerCategory, NSError *error))onComplete;

@end
