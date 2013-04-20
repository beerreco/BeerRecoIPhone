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

-(NSDictionary*)ToDictionary
{
    NSMutableDictionary* propertyDict = [[NSMutableDictionary alloc] init];
    [propertyDict setObject:self.id forKey:PropertyName_Id];
    [propertyDict setObject:self.name forKey:PropertyName_Name];
    /*
    NSNumber* dateNumber = [NSDateFormatter getWindowsTimestampFromDate:self.created];
    [propertyDict setObject:dateNumber forKey:PropertyName_created];
    
    if (![NSString isNullOrEmpty:self.resourceId])
    {
        [propertyDict setObject:self.resourceId forKey:PropertyName_resourceId];
    }
    
    if (self.screen != -1)
    {
        [propertyDict setValue:[NSNumber numberWithInt:self.screen] forKey:PropertyName_screen];
    }
    
    if (self.action != -1)
    {
        [propertyDict setValue:[NSNumber numberWithInt:self.action] forKey:PropertyName_action];
    }
    
    if (self.resourceType != -1)
    {
        [propertyDict setValue:[NSNumber numberWithInt:self.resourceType] forKey:PropertyName_resourceType];
    }
    */
    return propertyDict;
}

@end
