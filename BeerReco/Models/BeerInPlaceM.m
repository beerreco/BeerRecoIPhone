//
//  BeerInPlaceM.m
//  BeerReco
//
//  Created by RLemberg on 5/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerInPlaceM.h"

#define PropertyName_BeerId @"beerId"
#define PropertyName_PlaceId @"placeId"
#define PropertyName_Price @"price"

@implementation BeerInPlaceM

@synthesize beerId = _beerId;
@synthesize placeId = _placeId;
@synthesize price = _price;

-(id)initWithJson:(NSDictionary*)json
{
    self = [super initWithJson:json];
    
    if (!self || json == nil || [json isKindOfClass:([NSNull class])])
    {
        return nil;
    }
    
    self.beerId = [[json valueForKeyPath:@"beerId"] stringValue];
    self.placeId = [[json valueForKeyPath:@"placeId"] stringValue];
    
    self.price = [[json valueForKey:@"price"] doubleValue];
    
    return self;
}

#pragma mark - Public Methods

-(NSDictionary*)ToDictionary
{
    NSMutableDictionary* propertyDict = [super ToDictionary];
    
    if (![NSString isNullOrEmpty:self.beerId])
    {
        [propertyDict setObject:self.beerId forKey:PropertyName_BeerId];
    }
    
    if (![NSString isNullOrEmpty:self.placeId])
    {
        [propertyDict setObject:self.placeId forKey:PropertyName_PlaceId];
    }
    
    if (self.price >= 0)
    {
        [propertyDict setObject:[NSNumber numberWithDouble:self.price] forKey:PropertyName_Price];
    }
    
    return propertyDict;
}

@end
