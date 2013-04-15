//
//  BeerM.m
//  BeerReco
//
//  Created by RLemberg on 4/3/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerM.h"

@implementation BeerM

@synthesize id = _id;
@synthesize creationDate = _creationDate;
@synthesize updateDate = _updateDate;
@synthesize drinkType = _drinkType;
@synthesize origin = _origin;
@synthesize brewery = _brewery;
@synthesize type = _type;
@synthesize madeOf = _madeOf;
@synthesize alchoholPrecent = _alchoholPrecent;
@synthesize category = _category;
@synthesize name = _name;
@synthesize beerIconUrl = _beerIconUrl;

#pragma mark - Instance Methods

-(id)initWithJson:(NSDictionary*)json
{
    self = [super init];
    
    if (!self || json == nil || [json isKindOfClass:([NSNull class])])
    {
        return nil;
    }
    
    self.id = [[json valueForKeyPath:@"id"] stringValue];
    if ([NSString isNullOrEmpty:self.id])
    {
        self.id = [NSString uuid];
    }
    
    self.creationDate = [NSDateFormatter getDateFromWindowsTimestamp:[json valueForKeyPath:@"creationDate"]];
    self.updateDate = [NSDateFormatter getDateFromWindowsTimestamp:[json valueForKeyPath:@"updateDate"]];
        
    self.drinkType = [[json valueForKeyPath:@"drinkType"] stringValue];
    self.origin = [[json valueForKeyPath:@"origin"] stringValue];
    self.brewery = [[json valueForKeyPath:@"brewery"] stringValue];
    self.type = [[json valueForKeyPath:@"type"] stringValue];
    self.madeOf = [[json valueForKeyPath:@"madeOf"] stringValue];
    self.alchoholPrecent = [[json valueForKeyPath:@"alchoholPrecent"] floatValue];
    self.category = [[json valueForKeyPath:@"category"] stringValue];
    self.name = [[json valueForKeyPath:@"name"] stringValue];
    
    self.beerIconUrl = [[[json valueForKeyPath:@"beerIconUrl"] stringValue] URLEncodedString];
    
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
