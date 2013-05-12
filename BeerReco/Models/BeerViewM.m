//
//  BeerView.m
//  BeerReco
//
//  Created by RLemberg on 4/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerViewM.h"

#define PropertyName_Beer @"beer"
#define PropertyName_BeerType @"beerType"
#define PropertyName_Brewery @"brewery"
#define PropertyName_Country @"country"

@implementation BeerViewM

@synthesize beer = _beer;
@synthesize beerType = _beerType;
@synthesize brewery = _brewery;
@synthesize country = _country;

#pragma mark - Instance Methods

-(id)initWithJson:(NSDictionary*)json
{
    self = [super init];
    
    if (!self || json == nil || [json isKindOfClass:([NSNull class])])
    {
        return nil;
    }
    
    self.beer = [[BeerM alloc] initWithJson:[json valueForKey:@"beer"]];
    self.beerType = [[BeerTypeM alloc] initWithJson:[json valueForKey:@"beerType"]];
    self.brewery = [[BreweryM alloc] initWithJson:[json valueForKey:@"brewery"]];
    self.country = [[CountryM alloc] initWithJson:[json valueForKey:@"country"]];
    
    return self;
}

#pragma mark - Public Methods

-(NSDictionary*)ToDictionary
{
    NSMutableDictionary* propertyDict = [[NSMutableDictionary alloc] init];
    
    if (self.beer != nil)
    {
        [propertyDict setObject:[self.beer ToDictionary] forKey:PropertyName_Beer];
    }
    
    if (self.beerType != nil)
    {
        [propertyDict setObject:[self.beerType ToDictionary] forKey:PropertyName_BeerType];
    }
    
    if (self.brewery != nil)
    {
        [propertyDict setObject:[self.brewery ToDictionary] forKey:PropertyName_Brewery];
    }
    
    if (self.country != nil)
    {
        [propertyDict setObject:[self.beerType ToDictionary] forKey:PropertyName_Country];
    }
    
    return propertyDict;
}

@end
