//
//  BeerM.m
//  BeerReco
//
//  Created by RLemberg on 4/3/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerM.h"

@implementation BeerM

@synthesize category = _category;
@synthesize name = _name;

+ (BeerM*)beerOfCategory:(NSString *)category name:(NSString *)name
{
    BeerM *newBeer = [[self alloc] init];
    [newBeer setCategory:category];
    [newBeer setName:name];
    
    return newBeer;
}

@end
