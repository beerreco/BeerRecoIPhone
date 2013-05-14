//
//  PlaceView.m
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlaceViewM.h"

#define PropertyName_Area @"area"
#define PropertyName_Place @"place"
#define PropertyName_PlaceType @"placeType"

@implementation PlaceViewM

@synthesize area = _area;
@synthesize place = _place;
@synthesize placeType = _placeType;

#pragma mark - Instance Methods

-(id)initWithJson:(NSDictionary*)json
{
    self = [super init];
    
    if (!self || json == nil || [json isKindOfClass:([NSNull class])])
    {
        return nil;
    }
    
    self.area = [[AreaM alloc] initWithJson:[json valueForKey:@"area"]];
    self.place = [[PlaceM alloc] initWithJson:[json valueForKey:@"place"]];
    self.placeType = [[PlaceTypeM alloc] initWithJson:[json valueForKey:@"placeType"]];
    
    return self;
}

#pragma mark - Public Methods

-(NSDictionary*)ToDictionary
{
    NSMutableDictionary* propertyDict = [[NSMutableDictionary alloc] init];
    
    if (self.area != nil)
    {
        [propertyDict setObject:[self.area ToDictionary] forKey:PropertyName_Area];
    }
    
    if (self.placeType != nil)
    {
        [propertyDict setObject:[self.placeType ToDictionary] forKey:PropertyName_PlaceType];
    }
    
    if (self.place != nil)
    {
        [propertyDict setObject:[self.place ToDictionary] forKey:PropertyName_Place];
    }
    
    return propertyDict;
}

@end
