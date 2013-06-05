//
//  BreweryM.m
//  BeerReco
//
//  Created by RLemberg on 5/13/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BreweryM.h"

@implementation BreweryM

-(id)initWithJson:(NSDictionary*)json
{
    self = [super initWithJson:json];
    
    if (!self || json == nil || [json isKindOfClass:([NSNull class])])
    {
        return nil;
    }
    
    return self;
}

#pragma mark - Public Methods

-(NSDictionary*)ToDictionary
{
    NSMutableDictionary* propertyDict = [super ToDictionary];
    
    return propertyDict;
}

@end
