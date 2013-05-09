//
//  OriginCountryService.h
//  BeerReco
//
//  Created by RLemberg on 5/9/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OriginCountryService : NSObject

-(void)getAllOriginCountries:(void (^)(NSMutableArray* countries, NSError *error))onComplete;

-(void)getBeersByOriginCountry:(NSString*)countryId oncComplete:(void (^)(NSMutableArray* beers, NSError *error))onComplete;

-(void)addOriginCountry:(CountryM*)country onComplete:(void (^)(CountryM* country, NSError *error))onComplete;

-(void)updateOriginCountry:(CountryM*)country onComplete:(void (^)(CountryM* country, NSError *error))onComplete;

@end
