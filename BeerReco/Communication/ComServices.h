//
//  ComServices.h
//  BeerReco
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BeersService.h"
#import "FavoriteBeersService.h"

@interface ComServices : NSObject

+ (ComServices*)sharedComServices;

@property (nonatomic, strong) BeersService* beersService;
@property (nonatomic, strong) FavoriteBeersService* favoriteBeersService;

@end
