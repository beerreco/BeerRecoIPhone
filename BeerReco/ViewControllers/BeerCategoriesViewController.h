//
//  BeerCategoriesViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchAndRefreshTableViewController.h"

#import "BeerM.h"
#import "BeerTypeM.h"

@protocol BeerSelectionDelegate <NSObject>
-(void)selectedBeer:(BeerViewM*)beerView;
@end

@protocol BeerTypeSelectionDelegate <NSObject>
-(void)selectedBeerType:(BeerTypeM*)beerType;
@end

@protocol BrewerySelectionDelegate <NSObject>
-(void)selectedBrewery:(BreweryM*)brewery;
@end

@protocol OriginCountrySelectionDelegate <NSObject>
-(void)selectedOriginCountry:(CountryM*)country;
@end

@interface BeerCategoriesViewController : BaseSearchAndRefreshTableViewController

@property (nonatomic) BOOL beerSelectionMode;
@property (nonatomic, weak) id<BeerSelectionDelegate> beerSelectionDelegate;

@property (nonatomic) BOOL beerTypeSelectionMode;
@property (nonatomic, weak) id<BeerTypeSelectionDelegate> beerTypeSelectionDelegate;

@property (nonatomic) BOOL brewerySelectionMode;
@property (nonatomic, weak) id<BrewerySelectionDelegate> brewerySelectionDelegate;

@property (nonatomic) BOOL originCountrySelectionMode;
@property (nonatomic, weak) id<OriginCountrySelectionDelegate> originCountrySelectionDelegate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segCategories;

- (IBAction)categorySegValueChanged:(id)sender;

@end
