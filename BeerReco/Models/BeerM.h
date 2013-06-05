//
//  BeerM.h
//  BeerReco
//
//  Created by RLemberg on 4/3/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeerTypeM.h"
#import "BaseEntityM.h"

@interface BeerM : BaseEntityM

@property (nonatomic, strong) NSString *drinkType;
@property (nonatomic, strong) NSString *originCountryId;
@property (nonatomic, strong) NSString *breweryId;
@property (nonatomic, strong) NSString *madeOf;
@property (nonatomic) float alcoholPercent;
@property (nonatomic, strong) NSString *beerTypeId;
@property (nonatomic, strong) NSString *beerIconUrl;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
