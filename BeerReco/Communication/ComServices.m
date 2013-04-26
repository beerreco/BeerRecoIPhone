//
//  ComServices.m
//  BeerReco
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "ComServices.h"

@implementation ComServices

+ (ComServices *)sharedComServices
{
    static ComServices *_sharedComServices = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedComServices = [[ComServices alloc] init];
        
        _sharedComServices.beersService = [[BeersService alloc] init];
        _sharedComServices.favoriteBeersService = [[FavoriteBeersService alloc] init];
        _sharedComServices.categoriesService = [[CategoriesService alloc] init];
        _sharedComServices.placesService = [[PlacesService alloc] init];
        _sharedComServices.fileManagementService = [[FileManagementService alloc] init];
    });
    
    return _sharedComServices;
}

@end
