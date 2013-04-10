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

#pragma mark - Instance Methods

-(id)initWithJson:(NSDictionary*)json
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark - Class Methods

+ (BeerM*)beerOfCategory:(NSString *)category name:(NSString *)name
{
    BeerM *newBeer = [[self alloc] init];
    [newBeer setCategory:category];
    [newBeer setName:name];
    
    return newBeer;
}

@end
