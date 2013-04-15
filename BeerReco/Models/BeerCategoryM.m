//
//  BeerCategoryM.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerCategoryM.h"

@implementation BeerCategoryM

@synthesize id = _id;
@synthesize name = _name;

-(id)initWithJson:(NSDictionary*)json
{
    self = [super init];
    
    if (!self || json == nil || [json isKindOfClass:([NSNull class])])
    {
        return nil;
    }
    
    self.id = [[json valueForKeyPath:@"id"] stringValue];
    self.name = [[json valueForKeyPath:@"name"] stringValue];
    
    return self;
}

@end
