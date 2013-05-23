//
//  BeerCategoriesViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerCategoriesViewController.h"
#import "beersViewController.h"
#import "AddEditBeerTypeViewController.h"
#import "AddEditBreweryViewController.h"
#import "AddEditCountryViewController.h"
#import "AddBeerViewController.h"

@interface BeerCategoriesViewController ()

@end

@implementation BeerCategoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    
    return self;
}

- (void)viewDidLoad
{    
    [self visualSetup];
    
    [self setup];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{
    if (self.beerSelectionMode)
    {
        self.navigationItem.titleView = nil;
        
        self.navigationItem.title = @"Beer Selection";
    }
    else if (self.beerTypeSelectionMode)
    {
        self.navigationItem.titleView = nil;
        
        self.navigationItem.title = @"Beer Type Selection";
    }
    else if (self.originCountrySelectionMode)
    {
        self.navigationItem.titleView = nil;
        
        self.navigationItem.title = @"Origin Country Selection";
    }
    else if (self.brewerySelectionMode)
    {
        self.navigationItem.titleView = nil;
        
        self.navigationItem.title = @"Brewery Selection";
    }
    else
    {
        self.navigationItem.title = @"Beer Categories";
    }
}

-(void)setup
{
}

#pragma mark - BaseSearchAndRefreshTableViewController

-(BOOL)canShowContributionToolBar
{
    return self.beerSelectionMode ||
    self.beerTypeSelectionMode ||
    self.brewerySelectionMode ||
    self.originCountrySelectionMode ? NO : YES;
}

-(void)loadCurrentData
{
    if ((self.segCategories && self.segCategories.selectedSegmentIndex == 0) || self.beerTypeSelectionMode)
    {
        [[ComServices sharedComServices].beerTypesService getAllBeerTypes:^(NSMutableArray *beerTypes, NSError *error)
        {            
             if (error == nil && beerTypes != nil)
             {
                 [self dataLoaded:beerTypes];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
    else if ((self.segCategories && self.segCategories.selectedSegmentIndex == 1) || self.originCountrySelectionMode)
    {
        [[ComServices sharedComServices].originCountryService getAllOriginCountries:^(NSMutableArray *countries, NSError *error)
         {
             if (error == nil && countries != nil)
             {
                 [self dataLoaded:countries];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
    else if ((self.segCategories && self.segCategories.selectedSegmentIndex == 2) || self.brewerySelectionMode)
    {
        [[ComServices sharedComServices].breweryService getAllBreweries:^(NSMutableArray *breweries, NSError *error)
         {            
             if (error == nil && breweries != nil)
             {
                 [self dataLoaded:breweries];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
    else if ((self.segCategories && self.segCategories.selectedSegmentIndex == 3) || self.beerSelectionMode)
    {
        [[ComServices sharedComServices].beersService getAllBeers:^(NSMutableArray *beers, NSError *error)
         {
             if (error == nil && beers != nil)
             {
                 [self dataLoaded:beers];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
}

-(NSString*)getSortingKeyPath
{
    if ((self.segCategories && self.segCategories.selectedSegmentIndex == 3) || self.beerSelectionMode)
    {
        return @"beer.name";
    }
    else
    {
        return @"name";
    }
}

-(NSString*)getSearchablePropertyName
{
    if ((self.segCategories && self.segCategories.selectedSegmentIndex == 3) || self.beerSelectionMode)
    {
        return @"beer.name";
    }
    else
    {
        return [super getSearchablePropertyName];
    }
}

-(NSString*)getCellIdentifier
{
    return [super getCellIdentifier];
}

-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    if (self.beerSelectionMode ||
        self.beerTypeSelectionMode ||
        self.brewerySelectionMode ||
        self.originCountrySelectionMode)
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setEditingAccessoryView:[super makeDetailDisclosureButton]];
    }
    
    [cell.detailTextLabel setText:@""];
    [cell.imageView setImage:nil];
    
    if ([object isKindOfClass:([BeerTypeM class])])
    {
        BeerTypeM *beerCategory = object;
        
        // Configure the cell
        [cell.textLabel setText:beerCategory.name];
    }
    else if ([object isKindOfClass:([CountryM class])])
    {
        CountryM *country = object;
        
        // Configure the cell
        [cell.textLabel setText:country.name];
    }
    else if ([object isKindOfClass:([BreweryM class])])
    {
        BreweryM *brewery = object;
        
        // Configure the cell
        [cell.textLabel setText:brewery.name];
    }
    else if ([object isKindOfClass:([BeerViewM class])])
    {
        BeerViewM *beerView = object;
        
        // Configure the cell
        [cell.textLabel setText:beerView.beer.name];
        
        NSString* details = @"";
        
        if (beerView.beerType)
        {
            details = [details stringByAppendingFormat:@"Type: %@", beerView.beerType.name];
        }
        
        if (beerView.country)
        {
            if (![NSString isNullOrEmpty:details])
            {
                details = [details stringByAppendingString:@" - "];
            }
            
            details = [details stringByAppendingFormat:@"Origin Country: %@", beerView.country.name];
        }
        
        if (beerView.brewery && (!beerView.country || !beerView.beerType))
        {
            if (![NSString isNullOrEmpty:details])
            {
                details = [details stringByAppendingString:@" - "];
            }
            
            details = [details stringByAppendingFormat:@"Brewery: %@", beerView.brewery.name];
        }
        
        [cell.detailTextLabel setText:details];
        
        NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:beerView.beer.beerIconUrl];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"beer_icon_default"]];
    }
}

-(void)tableItemAccessoryClicked:(NSIndexPath *)indexPath
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    if (self.segCategories.selectedSegmentIndex == 0)
    {
        AddEditBeerTypeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditBeerTypeViewController"];
        
        vc.editedItem = [self.itemsArray objectAtIndex:indexPath.row];
        
        [navController setViewControllers:@[vc]];
    }
    else if (self.segCategories.selectedSegmentIndex == 1)
    {
        AddEditCountryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditCountryViewController"];
        
        vc.editedItem = [self.itemsArray objectAtIndex:indexPath.row];
        
        [navController setViewControllers:@[vc]];
    }
    else if (self.segCategories.selectedSegmentIndex == 2)
    {
        AddEditBreweryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditBreweryViewController"];
        
        vc.editedItem = [self.itemsArray objectAtIndex:indexPath.row];
        
        [navController setViewControllers:@[vc]];
    }
    
    [self presentModalViewController:navController animated:YES];
}

-(void)tableItemSelected:(NSIndexPath *)indexPath withObject:(id)object
{
    if (self.beerSelectionMode)
    {
        [self.beerSelectionDelegate selectedBeer:object];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.beerTypeSelectionMode)
    {
        [self.beerTypeSelectionDelegate selectedBeerType:object];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.originCountrySelectionMode)
    {
        [self.originCountrySelectionDelegate selectedOriginCountry:object];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.brewerySelectionMode)
    {
        [self.brewerySelectionDelegate selectedBrewery:object];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (self.segCategories && self.segCategories.selectedSegmentIndex == 3)
        {
            [self performSegueWithIdentifier:@"BeerDetailsSegue" sender:nil];
        }
        else
        {
            [self performSegueWithIdentifier:@"BeersInCategorySegue" sender:nil];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object
{
    if ([segue.identifier isEqualToString:@"BeersInCategorySegue"])
    {
        BeersViewController *beersViewController = [segue destinationViewController];
        
        if ([object isKindOfClass:([BeerTypeM class])])
        {
            BeerTypeM* beerType = object;
            beersViewController.parentBeerType = beerType;
        }
       
        if ([object isKindOfClass:([CountryM class])])
        {
            CountryM* country = object;
            beersViewController.parentCountry = country;
        }
        
        if ([object isKindOfClass:([BreweryM class])])
        {
            BreweryM* brewery = object;
            beersViewController.parentBrewery = brewery;
        }
    }
    
    if ([segue.identifier isEqualToString:@"BeerDetailsSegue"])
    {
        BeerDetailsViewController *beerDetailsViewController = [segue destinationViewController];
        
        if ([object isKindOfClass:([BeerViewM class])])
        {
            BeerViewM* beerView = object;
            beerDetailsViewController.beerView = beerView;
        }
    }
}

-(void)addNewItem
{
    UINavigationController* navController = [[UINavigationController alloc] init];
                                             
    if (self.segCategories.selectedSegmentIndex == 0)
    {
        AddEditBeerTypeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditBeerTypeViewController"];
        
        [navController setViewControllers:@[vc]];
    }
    else if (self.segCategories.selectedSegmentIndex == 1)
    {
        AddEditCountryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditCountryViewController"];
        
        [navController setViewControllers:@[vc]];
    }
    else if (self.segCategories.selectedSegmentIndex == 2)
    {
        AddEditBreweryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditBreweryViewController"];
        
        [navController setViewControllers:@[vc]];
    }
    else if (self.segCategories.selectedSegmentIndex == 3)
    {
        AddBeerViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBeerViewController"];
        
        [navController setViewControllers:@[vc]];
    }
    
    [self presentModalViewController:navController animated:YES];
}

#pragma mark - Action Handlers

- (IBAction)categorySegValueChanged:(id)sender
{
    if (self.editing)
    {
        [super toggleEditMode];
    }

    [self.barBtnEdit setEnabled:self.segCategories.selectedSegmentIndex != 3];
    
    if (self.loadErrorViewController)
    {
        [self.loadErrorViewController removeFloatingViewControllerFromParent:^(BOOL finished)
         {
             [self setLoadErrorViewController:nil];
             
             [self loadData];
         }];
    }
    else
    {
        [self loadData];
    }
}

@end
