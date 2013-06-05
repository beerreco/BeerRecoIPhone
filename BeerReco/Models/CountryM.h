//
//  CountryM.h
//  BeerReco
//
//  Created by RLemberg on 5/9/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntityM.h"

@interface CountryM : BaseEntityM

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
