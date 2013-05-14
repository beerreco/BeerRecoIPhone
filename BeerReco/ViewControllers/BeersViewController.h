//
//  BeersViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseSearchAndRefreshTableViewController.h"
#import "BeerDetailsViewController.h"
#import "BeerM.h"

@interface BeersViewController : BaseSearchAndRefreshTableViewController

@property (nonatomic, strong) BeerTypeM* parentBeerType;
@property (nonatomic, strong) BreweryM* parentBrewery;
@property (nonatomic, strong) CountryM* parentCountry;

@property (nonatomic, strong) BeerViewM* beerView;

@end
