//
//  SettingsViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/7/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookReceivedUser:) name:GlobalMessage_FB_ReceivedUser object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoggedOut:) name:GlobalMessage_FB_LoggedOut object:nil];
    
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
    [self createBeersWithBrewery:@[@"Jems Wheat", @"Jems Pils"] andBrewery:@"Jems"];
    [self createPlacesWithType:@[@"Shemrok", @"Dublin"] andType:@"Irish Pub"];*/
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

-(void)createPlaceWithType:(NSString*)placeName andTypeId:(NSString*)typeId
{
    PlaceM* place = [[PlaceM alloc] init];
    place.name = placeName;
    place.placeTypeId = typeId;
    [[ComServices sharedComServices].placesService addPlace:place onComplete:^(PlaceM* place, NSError *error)
     {
         [NSThread sleepForTimeInterval:2];
     }];
}

-(void)createPlacesWithType:(NSArray*)placeNames andType:(NSString*)typeName
{
    PlaceTypeM* placeType = [[PlaceTypeM alloc] init];
    placeType.name = typeName;
    [[ComServices sharedComServices].placeTypeService addPlaceType:placeType onComplete:^(PlaceTypeM *placeType, NSError *error)
    {   
         for (NSString* placeName in placeNames)
         {
             [self createPlaceWithType:placeName andTypeId:placeType.id];
         }
     }];
}

-(void)visualSetup
{
    self.title = @"Settings";
}

#pragma mark - Action Handlers


- (IBAction)switchValueChanged:(UISwitch *)sender
{
    if (sender.tag == 1)
    {
        [GeneralDataStore sharedDataStore].contributerMode = sender.isOn;
    }
}

#pragma mark - Notifications Handlers

-(void)facebookReceivedUser:(NSNotification*)notification
{
    [self.tbSettings reloadData];
}

-(void)facebookLoggedOut:(NSNotification*)notification
{
    [self.tbSettings reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"cell";
    
    if (indexPath.section == 1)
    {
        CellIdentifier = @"cell2";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (cell.backgroundView == nil)
    {
        UIImageView* backgroud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg"]];
        backgroud.alpha = 0.85;
        backgroud.layer.cornerRadius = 15;
        backgroud.clipsToBounds = YES;
        
        backgroud.layer.borderWidth = 0.5;
        backgroud.layer.borderColor = [[UIColor grayColor] CGColor];
        
        cell.backgroundView = backgroud;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.section == 0)
    {
        [cell.textLabel setText:@"Facebook"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if (indexPath.section == 1)
    {
        UILabel* label = (UILabel*)[cell viewWithTag:0];
        if (label)
        {
            label.text = @"Contributer Mode";
        }
        
        UISwitch* switchCon = (UISwitch*)[cell viewWithTag:1];
        if (switchCon)
        {
            [switchCon setOn:[GeneralDataStore sharedDataStore].contributionAllowed];
            
            [switchCon setEnabled:[GeneralDataStore sharedDataStore].hasFBUser];
        }
    }
    
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
