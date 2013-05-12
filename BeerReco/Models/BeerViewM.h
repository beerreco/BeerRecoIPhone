//
//  BeerView.h
//  BeerReco
//
//  Created by RLemberg on 4/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CountryM.h"
#import "BreweryM.h"

@interface BeerViewM : NSObject

@property (nonatomic, strong) BeerM* beer;
@property (nonatomic, strong) BeerTypeM* beerType;
@property (nonatomic, strong) BreweryM* brewery;
@property (nonatomic, strong) CountryM* country;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
