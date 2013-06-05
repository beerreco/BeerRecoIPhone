//
//  BreweryM.h
//  BeerReco
//
//  Created by RLemberg on 5/13/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntityM.h"

@interface BreweryM : BaseEntityM

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
