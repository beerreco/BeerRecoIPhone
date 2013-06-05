//
//  BaseEntityM.m
//  BeerReco
//
//  Created by RLemberg on 6/5/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BaseEntityM.h"

#define PropertyName_Id @"id"
#define PropertyName_Name @"name"
#define PropertyName_contributorId @"contributorId"

@implementation BaseEntityM

@synthesize id = _id;
@synthesize name = _name;
@synthesize creationDate = _creationDate;
@synthesize updateDate = _updateDate;
@synthesize contributorId = _contributorId;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.contributorId = [GeneralDataStore sharedDataStore].FBUserID;
    }
    
    return self;
}

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
    
    self.contributorId = [[json valueForKeyPath:@"contributorId"] stringValue];
    
    return self;
}

#pragma mark - Public Methods

-(NSMutableDictionary*)ToDictionary
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
    
    if (![NSString isNullOrEmpty:self.contributorId])
    {
        [propertyDict setObject:self.contributorId forKey:PropertyName_contributorId];
    }
    
    return propertyDict;
}

@end
