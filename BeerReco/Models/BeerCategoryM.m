//
//  BeerCategoryM.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerCategoryM.h"

#define PropertyName_Id @"id"
#define PropertyName_Name @"name"
#define PropertyName_CreationDate @"creationDate"
#define PropertyName_UpdateDate @"updateDate"

@implementation BeerCategoryM

@synthesize id = _id;
@synthesize name = _name;
@synthesize creationDate = _creationDate;
@synthesize updateDate = _updateDate;

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
    
    return propertyDict;
}

@end
