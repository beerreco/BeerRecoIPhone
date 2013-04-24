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
#define PropertyName_CreationDate @"creationDate"
#define PropertyName_UpdateDate @"updateDate"
#define PropertyName_DrinkType @"drinkType"
#define PropertyName_Origin @"origin"
#define PropertyName_Brewery @"brewery"
#define PropertyName_MadeOf @"madeOf"
#define PropertyName_Type @"type"
#define PropertyName_AlchoholPrecent @"alchoholPrecent"
#define PropertyName_BeerIconUrl @"beerIconUrl"

@implementation BeerM

@synthesize id = _id;
@synthesize name = _name;
@synthesize creationDate = _creationDate;
@synthesize updateDate = _updateDate;
@synthesize drinkType = _drinkType;
@synthesize origin = _origin;
@synthesize brewery = _brewery;
@synthesize madeOf = _madeOf;
@synthesize category = _category;
@synthesize alchoholPrecent = _alchoholPrecent;
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
    self.origin = [[json valueForKeyPath:@"origin"] stringValue];
    self.brewery = [[json valueForKeyPath:@"brewery"] stringValue];
    self.madeOf = [[json valueForKeyPath:@"madeOf"] stringValue];
    self.alchoholPrecent = [[json valueForKeyPath:@"alchoholPrecent"] floatValue];
    self.category = [[BeerCategoryM alloc] initWithJson:[json valueForKeyPath:@"type"]];
    
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

    if (self.creationDate != nil)
    {
        [propertyDict setObject:self.creationDate forKey:PropertyName_CreationDate];
    }
    
    if (self.updateDate != nil)
    {
        [propertyDict setObject:self.updateDate forKey:PropertyName_UpdateDate];
    }
    
    if (![NSString isNullOrEmpty:self.drinkType])
    {
        [propertyDict setObject:self.drinkType forKey:PropertyName_DrinkType];
    }
    
    if (![NSString isNullOrEmpty:self.origin])
    {
        [propertyDict setObject:self.origin forKey:PropertyName_Origin];
    }
    
    if (![NSString isNullOrEmpty:self.brewery])
    {
        [propertyDict setObject:self.brewery forKey:PropertyName_Brewery];
    }
    
    if (![NSString isNullOrEmpty:self.madeOf])
    {
        [propertyDict setObject:self.madeOf forKey:PropertyName_MadeOf];
    }
    
    if (self.category != nil)
    {
        [propertyDict setObject:[self.category ToDictionary] forKey:PropertyName_Type];
    }
    
    if (self.alchoholPrecent != 0)
    {
        NSNumber* num = [NSNumber numberWithFloat:self.alchoholPrecent];
        [propertyDict setObject:num forKey:PropertyName_AlchoholPrecent];
    }
    
    if (![NSString isNullOrEmpty:self.beerIconUrl])
    {
        [propertyDict setObject:self.beerIconUrl forKey:PropertyName_BeerIconUrl];
    }
    
    return propertyDict;
}

@end
