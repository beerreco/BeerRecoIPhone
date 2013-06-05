//
//  BeerCategoryM.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntityM.h"

@interface BeerTypeM : BaseEntityM

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
