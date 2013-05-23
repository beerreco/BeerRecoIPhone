//
//  OriginCountryService.h
//  BeerReco
//
//  Created by RLemberg on 5/9/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CountryM.h"
#import "FieldUpdateDataM.h"

@interface OriginCountryService : NSObject

-(void)getAllOriginCountries:(void (^)(NSMutableArray* countries, NSError *error))onComplete;

-(void)getBeersByOriginCountry:(NSString*)countryId oncComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete;

-(void)addOriginCountry:(CountryM*)country onComplete:(void (^)(CountryM* country, NSError *error))onComplete;

-(void)updateOriginCountry:(FieldUpdateDataM*)fieldUpdateData  onComplete:(void (^)(NSError *error))onComplete;

-(void)deleteOriginCountry:(NSString*)countryId onComplete:(void (^)(NSError *error))onComplete;

@end
