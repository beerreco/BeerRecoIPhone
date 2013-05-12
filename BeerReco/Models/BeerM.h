//
//  BeerM.h
//  BeerReco
//
//  Created by RLemberg on 4/3/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeerTypeM.h"

@interface BeerM : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *updateDate;
@property (nonatomic, strong) NSString *drinkType;
@property (nonatomic, strong) NSString *originCountryId;
@property (nonatomic, strong) NSString *breweryId;
@property (nonatomic, strong) NSString *madeOf;
@property (nonatomic) float alchoholPrecent;
@property (nonatomic, strong) NSString *beerTypeId;
@property (nonatomic, strong) NSString *beerIconUrl;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
