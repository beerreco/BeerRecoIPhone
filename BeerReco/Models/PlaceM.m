//
//  PlaceM.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlaceM.h"

@implementation PlaceM

@synthesize id = _id;
@synthesize creationDate = _creationDate;
@synthesize updateDate = _updateDate;
@synthesize type = _type;
@synthesize address = _address;
@synthesize geoLocation = _geoLocation;
@synthesize name = _name;
@synthesize placeIconUrl = _placeIconUrl;

-(id)initWithJson:(NSDictionary*)json
{
    self = [super init];
    
    if (!self || json == nil || [json isKindOfClass:([NSNull class])])
    {
        return nil;
    }
    
    self.id = [[json valueForKeyPath:@"id"] stringValue];
    
    self.creationDate = [NSDateFormatter getDateFromWindowsTimestamp:[json valueForKeyPath:@"creationDate"]];
    self.updateDate = [NSDateFormatter getDateFromWindowsTimestamp:[json valueForKeyPath:@"updateDate"]];
    
    self.type = [[json valueForKeyPath:@"type"] stringValue];
    self.address = [[json valueForKeyPath:@"address"] stringValue];
    self.geoLocation = [[json valueForKeyPath:@"geoLocation"] stringValue];
    self.name = [[json valueForKeyPath:@"name"] stringValue];
    
    self.placeIconUrl = [[[json valueForKeyPath:@"placeIconUrl"] stringValue] URLEncodedString];
    
    return self;
}

@end
