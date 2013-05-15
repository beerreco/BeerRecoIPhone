//
//  FieldUpdateDataM.m
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FieldUpdateDataM.h"

#define PropertyName_originalObjectId @"originalObjectId"
#define PropertyName_editedFieldName @"editedFieldName"
#define PropertyName_oldValue @"oldValue"
#define PropertyName_suggestedValue @"newValue"
#define PropertyName_editingUserId @"editingUserId"

@implementation FieldUpdateDataM

@synthesize originalObjectId = _originalObjectId;
@synthesize editedFieldName = _editedFieldName;
@synthesize oldValue = _oldValue;
@synthesize suggestedValue = _suggestedValue;
@synthesize editingUserId = _editingUserId;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.editingUserId = [GeneralDataStore sharedDataStore].FBUserID;
    }
    
    return self;
}

#pragma mark - Public Methods

-(NSDictionary*)ToDictionary
{
    NSMutableDictionary* propertyDict = [[NSMutableDictionary alloc] init];
    
    if (![NSString isNullOrEmpty:self.originalObjectId])
    {
        [propertyDict setObject:self.originalObjectId forKey:PropertyName_originalObjectId];
    }
    
    if (![NSString isNullOrEmpty:self.editedFieldName])
    {
        [propertyDict setObject:self.editedFieldName forKey:PropertyName_editedFieldName];
    }
    
    if (![NSString isNullOrEmpty:self.oldValue])
    {
        [propertyDict setObject:self.oldValue forKey:PropertyName_oldValue];
    }
    
    if (![NSString isNullOrEmpty:self.suggestedValue])
    {
        [propertyDict setObject:self.suggestedValue forKey:PropertyName_suggestedValue];
    }
    
    if (![NSString isNullOrEmpty:self.editingUserId])
    {
        [propertyDict setObject:self.editingUserId forKey:PropertyName_editingUserId];
    }
    
    return propertyDict;
}

@end
