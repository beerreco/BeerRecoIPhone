//
//  CountryM.m
//  BeerReco
//
//  Created by RLemberg on 5/9/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "CountryM.h"

@implementation CountryM

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
