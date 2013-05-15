//
//  PlaceM.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlaceM.h"

#define PropertyName_Id @"id"
#define PropertyName_Name @"name"
#define PropertyName_Type @"type"
#define PropertyName_AreaId @"areaId"
#define PropertyName_PlaceTypeId @"placeTypeId"
#define PropertyName_Address @"address"
#define PropertyName_GeoLocation @"geoLocation"
#define PropertyName_PlaceIconUrl @"placeIconUrl"

@implementation PlaceM

@synthesize id = _id;
@synthesize name = _name;
@synthesize creationDate = _creationDate;
@synthesize updateDate = _updateDate;
@synthesize type = _type;
@synthesize areaId = _areaId;
@synthesize placeTypeId = _placeTypeId;
@synthesize address = _address;
@synthesize geoLocation = _geoLocation;
@synthesize placeIconUrl = _placeIconUrl;

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
    
    self.type = [[json valueForKeyPath:@"type"] stringValue];
    self.areaId = [[json valueForKeyPath:@"areaId"] stringValue];
    self.placeTypeId = [[json valueForKeyPath:@"placeTypeId"] stringValue];
    self.address = [[json valueForKeyPath:@"address"] stringValue];
    self.geoLocation = [[json valueForKeyPath:@"geoLocation"] stringValue];
    
    self.placeIconUrl = [[[json valueForKeyPath:@"placeIconUrl"] stringValue] URLEncodedString];
    
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
    
    if (![NSString isNullOrEmpty:self.type])
    {
        [propertyDict setObject:self.type forKey:PropertyName_Type];
    }
    
    if (![NSString isNullOrEmpty:self.areaId])
    {
        [propertyDict setObject:self.areaId forKey:PropertyName_AreaId];
    }
    
    if (![NSString isNullOrEmpty:self.placeTypeId])
    {
        [propertyDict setObject:self.placeTypeId forKey:PropertyName_PlaceTypeId];
    }
    
    if (![NSString isNullOrEmpty:self.address])
    {
        [propertyDict setObject:self.address forKey:PropertyName_Address];
    }

    if (![NSString isNullOrEmpty:self.geoLocation])
    {
        [propertyDict setObject:self.geoLocation forKey:PropertyName_GeoLocation];
    }
    
    if (![NSString isNullOrEmpty:self.placeIconUrl])
    {
        [propertyDict setObject:self.placeIconUrl forKey:PropertyName_PlaceIconUrl];
    }
    
    return propertyDict;
}

@end
