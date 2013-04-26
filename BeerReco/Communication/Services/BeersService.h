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

-(void)addBeer:(BeerM*)beer onComplete:(void (^)(BeerM* beer, NSError *error))onComplete;

-(void)updateBeer:(BeerM*)beer onComplete:(void (^)(BeerM* beer, NSError *error))onComplete;

@end
