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

@implementation BeerViewM

@synthesize beer = _beer;
@synthesize beerCategory = _beerCategory;

#pragma mark - Instance Methods

-(id)initWithJson:(NSDictionary*)json
{
    self = [super init];
    
    if (!self || json == nil || [json isKindOfClass:([NSNull class])])
    {
        return nil;
    }
    
    self.beer = [[BeerM alloc] initWithJson:[json valueForKey:@"beer"]];
    self.beerCategory = [[BeerCategoryM alloc] initWithJson:[json valueForKey:@"beerType"]];
    
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
    
    if (self.beerCategory != nil)
    {
        [propertyDict setObject:[self.beerCategory ToDictionary] forKey:PropertyName_BeerType];
    }
    
    return propertyDict;
}

@end
