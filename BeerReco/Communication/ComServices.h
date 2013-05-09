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
#import "CategoriesService.h"
#import "PlacesService.h"
#import "FileManagementService.h"
#import "AreasService.h"
#import "OriginCountryService.h"

@interface ComServices : NSObject

+ (ComServices*)sharedComServices;

@property (nonatomic, strong) BeersService* beersService;
@property (nonatomic, strong) FavoriteBeersService* favoriteBeersService;
@property (nonatomic, strong) CategoriesService* categoriesService;
@property (nonatomic, strong) PlacesService* placesService;
@property (nonatomic, strong) AreasService* areasService;
@property (nonatomic, strong) OriginCountryService* originCountryService;
@property (nonatomic, strong) FileManagementService* fileManagementService;

@end
