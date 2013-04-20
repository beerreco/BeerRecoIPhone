//
//  BeersService.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BeerM.h"

@interface BeersService : NSObject

-(void)getBeersByCatergory:(NSString*)categoryId oncComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete;

-(void)addBeer:(BeerM*)beer onComplete:(void (^)(NSError *error))onComplete;

@end
