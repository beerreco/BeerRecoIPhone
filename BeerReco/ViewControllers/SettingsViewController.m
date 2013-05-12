//
//  SettingsViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/7/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setTbSettings:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self visualSetup];
    
    /*
     [[ComServices sharedComServices].fileManagementService uploadFile:^(NSString *filePath, NSError *error) {
     
     }];
     */
    /*[self createBeersWithCountry:@[@"Malka", @"GoldStar", @"Jems"] andCountry:@"Israel"];
    [self createBeersWithCategory:@[@"Carlsberg", @"Heiniken"] andCategory:@"Ale"];
    [self createPlacesWithArea:@[@"Mikes Place", @"Leo Blooms"] andArea:@"HaMerkaz"];
    [self createPlacesWithArea:@[@"Meet Ball"] andArea:@"HaDarom"];
     [self createBeersWithBrewery:@[@"Malka Dark", @"Malka Light"] andBrewery:@"HaGolan"];
    [self createBeersWithBrewery:@[@"Jems Wheat", @"Jems Pils"] andBrewery:@"Jems"];*/
    /*
    [[ComServices sharedComServices].placesService addBeer:@"36471366-d3ec-4af5-ae86-04f9bcdfcd45" toPlace:@"5a58aae6-ee19-4a65-a0e4-c10c5b7bf9e5" withPrice:29 onComplete:^(BeerInPlaceM* beerInPlace, NSError *error)
    {
        NSLog(@"beer adding to place %@", error ? @"failed" : @"succedded");
    }];*/
}

#pragma mark - Private Methods

-(void)createBeerWithCategoryId:(NSString*)beerName andCategoryId:(NSString*)categoryId
{
    BeerM* beer = [[BeerM alloc] init];
    beer.name = beerName;
    beer.beerTypeId = categoryId;
    [[ComServices sharedComServices].beersService addBeer:beer onComplete:^(BeerM* beer, NSError *error)
     {
         [NSThread sleepForTimeInterval:2];
     }];
}

-(void)createBeersWithCategory:(NSArray*)beerNames andCategory:(NSString*)categoryName
{
    BeerTypeM* beerCategory = [[BeerTypeM alloc] init];
    beerCategory.name = categoryName;
    [[ComServices sharedComServices].beerTypesService addBeerType:beerCategory onComplete:^(BeerTypeM* beerCategory, NSError *error)
     {
         for (NSString* beerName in beerNames)
         {
             [self createBeerWithCategoryId:beerName andCategoryId:beerCategory.id];
         }
     }];
}

-(void)createBeerWithBreweryId:(NSString*)beerName andBreweryId:(NSString*)breweryId
{
    BeerM* beer = [[BeerM alloc] init];
    beer.name = beerName;
    beer.breweryId = breweryId;
    [[ComServices sharedComServices].beersService addBeer:beer onComplete:^(BeerM* beer, NSError *error)
     {
         [NSThread sleepForTimeInterval:2];
     }];
}

-(void)createBeersWithBrewery:(NSArray*)beerNames andBrewery:(NSString*)breweryName
{
    BreweryM* brewery = [[BreweryM alloc] init];
    brewery.name = breweryName;
    [[ComServices sharedComServices].breweryService addBrewery:brewery onComplete:^(BreweryM *brewery, NSError *error)
    {   
         for (NSString* beerName in beerNames)
         {
             [self createBeerWithBreweryId:beerName andBreweryId:brewery.id];
         }
     }];
}

-(void)createBeerWithCountryId:(NSString*)beerName andCountryId:(NSString*)countryId
{
    BeerM* beer = [[BeerM alloc] init];
    beer.name = beerName;
    beer.originCountryId = countryId;
    [[ComServices sharedComServices].beersService addBeer:beer onComplete:^(BeerM* beer, NSError *error)
     {
         [NSThread sleepForTimeInterval:2];
     }];
}

-(void)createBeersWithCountry:(NSArray*)beerNames andCountry:(NSString*)countryName
{
    CountryM* country = [[CountryM alloc] init];
    country.name = countryName;
    [[ComServices sharedComServices].originCountryService addOriginCountry:country onComplete:^(CountryM *country, NSError *error)
     {        
         for (NSString* beerName in beerNames)
         {
             [self createBeerWithCountryId:beerName andCountryId:country.id];
         }
     }];
}

-(void)createPlaceWithArea:(NSString*)placeName andAreaId:(NSString*)areaId
{
    PlaceM* place = [[PlaceM alloc] init];
    place.name = placeName;
    place.areaId = areaId;
    [[ComServices sharedComServices].placesService addPlace:place onComplete:^(PlaceM* place, NSError *error)
     {
         [NSThread sleepForTimeInterval:2];
     }];
}

-(void)createPlacesWithArea:(NSArray*)placeNames andArea:(NSString*)areaName
{
    AreaM* area = [[AreaM alloc] init];
    area.name = areaName;
    [[ComServices sharedComServices].areasService addArea:area onComplete:^(AreaM* area, NSError *error)
     {
         for (NSString* placeName in placeNames)
         {
             [self createPlaceWithArea:placeName andAreaId:area.id];
         }
     }];
}

-(void)visualSetup
{
    self.title = @"Settings";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    [cell.textLabel setText:@"Facebook"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            
            // Perform segue to beer detail
            [self performSegueWithIdentifier:@"facebookSettingsSegue" sender:tableView];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
