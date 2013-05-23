//
//  BeerM.m
//  BeerReco
//
//  Created by RLemberg on 4/3/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerM.h"

#define PropertyName_Id @"id"
#define PropertyName_Name @"name"
#define PropertyName_DrinkType @"drinkType"
#define PropertyName_OriginCountryId @"originCountryId"
#define PropertyName_BreweryId @"breweryId"
#define PropertyName_MadeOf @"madeOf"
#define PropertyName_BeerTypeId @"beerTypeId"
#define PropertyName_AlcoholPercent @"alcoholPercent"
#define PropertyName_BeerIconUrl @"beerIconUrl"

@implementation BeerM

@synthesize id = _id;
@synthesize name = _name;
@synthesize creationDate = _creationDate;
@synthesize updateDate = _updateDate;
@synthesize drinkType = _drinkType;
@synthesize originCountryId = _originCountryId;
@synthesize breweryId = _breweryId;
@synthesize madeOf = _madeOf;
@synthesize beerTypeId = _beerTypeId;
@synthesize alcoholPercent = _alchoholPrecent;
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
    self.name = [[json valueForKeyPath:@"name"] stringValue];
    
    self.creationDate = [NSDateFormatter getDateFromWindowsTimestamp:[json valueForKeyPath:@"creationDate"]];
    self.updateDate = [NSDateFormatter getDateFromWindowsTimestamp:[json valueForKeyPath:@"updateDate"]];
        
    self.drinkType = [[json valueForKeyPath:@"drinkType"] stringValue];
    self.originCountryId = [[json valueForKeyPath:@"originCountryId"] stringValue];
    self.breweryId = [[json valueForKeyPath:@"breweryId"] stringValue];
    self.madeOf = [[json valueForKeyPath:@"madeOf"] stringValue];
    self.alcoholPercent = [[json valueForKeyPath:@"alcoholPercent"] floatValue];
    self.beerTypeId = [[[json valueForKeyPath:@"beerTypeId"] stringValue] URLEncodedString];
    
    self.beerIconUrl = [[[json valueForKeyPath:@"beerIconUrl"] stringValue] URLEncodedString];
    
    return self;
}

#pragma mark - Public Methods

-(NSDictionary*)ToDictionary
{
    NSMutableDictionary* propertyDict = [[NSMutableDictionary alloc] init];
    if (![NSString isNullOrEmpty:self.id])
    {
        [propertyDict setObject:self.id forKey:PropertyName_Id];
    }
    
    if (![NSString isNullOrEmpty:self.name])
    {
        [propertyDict setObject:self.name forKey:PropertyName_Name];
    }
    
    if (![NSString isNullOrEmpty:self.drinkType])
    {
        [propertyDict setObject:self.drinkType forKey:PropertyName_DrinkType];
    }
    
    if (![NSString isNullOrEmpty:self.originCountryId])
    {
        [propertyDict setObject:self.originCountryId forKey:PropertyName_OriginCountryId];
    }
    
    if (![NSString isNullOrEmpty:self.breweryId])
    {
        [propertyDict setObject:self.breweryId forKey:PropertyName_BreweryId];
    }
    
    if (![NSString isNullOrEmpty:self.madeOf])
    {
        [propertyDict setObject:self.madeOf forKey:PropertyName_MadeOf];
    }
    
    if (![NSString isNullOrEmpty:self.beerTypeId])
    {
        [propertyDict setObject:self.beerTypeId forKey:PropertyName_BeerTypeId];
    }
    
    if (self.alcoholPercent != 0)
    {
        NSNumber* num = [NSNumber numberWithFloat:self.alcoholPercent];
        [propertyDict setObject:num forKey:PropertyName_AlcoholPercent];
    }
    
    if (![NSString isNullOrEmpty:self.beerIconUrl])
    {
        [propertyDict setObject:self.beerIconUrl forKey:PropertyName_BeerIconUrl];
    }
    
    return propertyDict;
}

@end
