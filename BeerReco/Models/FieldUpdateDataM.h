//
//  FieldUpdateDataM.h
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldUpdateDataM : NSObject

@property (nonatomic, strong) NSString* originalObjectId;
@property (nonatomic, strong) NSString* editedFieldName;
@property (nonatomic, strong) NSString* oldValue;
@property (nonatomic, strong) NSString* suggestedValue;
@property (nonatomic, strong) NSString* editingUserId;

-(NSDictionary*)ToDictionary;

@end
