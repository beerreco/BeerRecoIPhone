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
     /*
     [self createBeerWithCategory:@"Heiniken" andCategory:@"Ale"];
     [self createBeerWithCategory:@"GoldStar" andCategory:@"Pils"];
     [self createBeerWithCategory:@"Baltika" andCategory:@"Ale"];
     [self createBeerWithCategory:@"Jems" andCategory:@"Wheat"];
     [self createBeerWithCategory:@"Erdinger" andCategory:@"Wheat"];
     */
    /*
     [self createPlaceWithArea:@"Mikes Place" andArea:@"HaMerkaz"];
     [self createPlaceWithArea:@"Leo Blooms" andArea:@"HaMerkaz"];
     [self createPlaceWithArea:@"Meet Ball" andArea:@"HaDarom"];
      */
    [self createBeersWithCountry:@[@"Malka", @"GoldStar", @"Jems"] andCountry:@"Israel"];
    [self createBeersWithCategory:@[@"Carlsberg", @"Heiniken"] andCategory:@"Ale"];
}

#pragma mark - Private Methods

-(void)createBeerWithCategoryId:(NSString*)beerName andCategoryId:(NSString*)categoryId
{
    BeerM* beer = [[BeerM alloc] init];
    beer.name = beerName;
    beer.beerTypeId = categoryId;
    [[ComServices sharedComServices].beersService addBeer:beer onComplete:^(BeerM* beer, NSError *error)
     {
         [NSThread sleepForTimeInterval:100];
     }];
}

-(void)createBeersWithCategory:(NSArray*)beerNames andCategory:(NSString*)categoryName
{
    BeerCategoryM* beerCategory = [[BeerCategoryM alloc] init];
    beerCategory.name = categoryName;
    [[ComServices sharedComServices].categoriesService addBeerCategory:beerCategory onComplete:^(BeerCategoryM* beerCategory, NSError *error)
     {
         for (NSString* beerName in beerNames)
         {
             [self createBeerWithCategoryId:beerName andCategoryId:beerCategory.id];
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
         [NSThread sleepForTimeInterval:100];
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

-(void)createPlaceWithArea:(NSString*)placeName andArea:(NSString*)areaName
{
    AreaM* area = [[AreaM alloc] init];
    area.name = areaName;
    [[ComServices sharedComServices].areasService addArea:area onComplete:^(AreaM* area, NSError *error)
     {
         PlaceM* place = [[PlaceM alloc] init];
         place.name = placeName;
         place.areaId = area.id;
         [[ComServices sharedComServices].placesService addPlace:place onComplete:^(PlaceM* place, NSError *error)
          {
              [NSThread sleepForTimeInterval:100];
          }];
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
