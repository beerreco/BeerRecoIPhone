//
//  BeerM.h
//  BeerReco
//
//  Created by RLemberg on 4/3/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerM : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;

-(id)initWithJson:(NSDictionary*)json;

+ (BeerM*)beerOfCategory:(NSString*)category name:(NSString*)name;

@end
