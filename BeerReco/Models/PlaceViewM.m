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

@implementation PlaceViewM

@synthesize area = _area;
@synthesize place = _place;

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
    
    if (self.place != nil)
    {
        [propertyDict setObject:[self.place ToDictionary] forKey:PropertyName_Place];
    }
    
    return propertyDict;
}

@end
