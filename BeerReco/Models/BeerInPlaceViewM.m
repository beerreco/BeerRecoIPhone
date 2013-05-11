//
//  BeerInPlaceViewM.m
//  BeerReco
//
//  Created by RLemberg on 5/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerInPlaceViewM.h"

#define PropertyName_BeerView @"beerView"
#define PropertyName_PlaceView @"placeView"
#define PropertyName_BeerInPlace @"beerInPlace"

@implementation BeerInPlaceViewM

@synthesize beerView = _beerView;
@synthesize placeView = _placeView;
@synthesize beerInPlace = _beerInPlace;

#pragma mark - Instance Methods

-(id)initWithJson:(NSDictionary*)json
{
    self = [super init];
    
    if (!self || json == nil || [json isKindOfClass:([NSNull class])])
    {
        return nil;
    }
    
    self.beerView = [[BeerViewM alloc] initWithJson:[json valueForKey:@"beerView"]];
    self.placeView = [[PlaceViewM alloc] initWithJson:[json valueForKey:@"placeView"]];
    self.beerInPlace = [[BeerInPlaceM alloc] initWithJson:[json valueForKey:@"beerInPlace"]];
    
    return self;
}

#pragma mark - Public Methods

-(NSDictionary*)ToDictionary
{
    NSMutableDictionary* propertyDict = [[NSMutableDictionary alloc] init];
    
    if (self.beerView != nil)
    {
        [propertyDict setObject:[self.beerView ToDictionary] forKey:PropertyName_BeerView];
    }
    
    if (self.placeView != nil)
    {
        [propertyDict setObject:[self.placeView ToDictionary] forKey:PropertyName_PlaceView];
    }
    
    if (self.beerInPlace != nil)
    {
        [propertyDict setObject:[self.beerInPlace ToDictionary] forKey:PropertyName_BeerInPlace];
    }
    
    return propertyDict;
}

@end
