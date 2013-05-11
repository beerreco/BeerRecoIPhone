//
//  BeerCategoriesViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerCategoriesViewController.h"
#import "beersViewController.h"

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
    self.navigationItem.title = @"Categories";
}

-(void)setup
{
}

#pragma mark - BaseSearchAndRefreshTableViewController

-(void)loadCurrentData
{
    if (self.segCategories.selectedSegmentIndex == 0)
    {
        [[ComServices sharedComServices].categoriesService getAllCategories:^(NSMutableArray *categories, NSError *error)
         {
             if (error == nil && categories != nil)
             {
                 [self dataLoaded:categories];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
    else if (self.segCategories.selectedSegmentIndex == 1)
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
    else if (self.segCategories.selectedSegmentIndex == 2)
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
    if (self.segCategories.selectedSegmentIndex == 2)
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
    if (self.segCategories.selectedSegmentIndex == 2)
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
    [cell.detailTextLabel setText:@""];
    [cell.imageView setImage:nil];
    
    if ([object isKindOfClass:([BeerCategoryM class])])
    {
        BeerCategoryM *beerCategory = object;
        
        // Configure the cell
        [cell.textLabel setText:beerCategory.name];
    }
    else if ([object isKindOfClass:([CountryM class])])
    {
        CountryM *country = object;
        
        // Configure the cell
        [cell.textLabel setText:country.name];
    }
    else if ([object isKindOfClass:([BeerViewM class])])
    {
        BeerViewM *beerView = object;
        
        // Configure the cell
        [cell.textLabel setText:beerView.beer.name];
        
        NSString* details = @"";
        
        if (beerView.beerCategory)
        {
            details = [details stringByAppendingFormat:@"Type: %@", beerView.beerCategory.name];
        }
        
        if (beerView.country)
        {
            if (![NSString isNullOrEmpty:details])
            {
                details = [details stringByAppendingString:@" - "];
            }
            
            details = [details stringByAppendingFormat:@"Origin Country: %@", beerView.country.name];
        }
        
        [cell.detailTextLabel setText:details];
        
        NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:beerView.beer.beerIconUrl];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"weihenstephaner_hefe_icon"]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
}

-(void)tableItemSelected:(NSIndexPath *)indexPath
{
    if (self.segCategories.selectedSegmentIndex == 2)
    {
        [self performSegueWithIdentifier:@"BeerDetailsSegue" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"BeersInCategorySegue" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object
{
    if ([segue.identifier isEqualToString:@"BeersInCategorySegue"])
    {
        BeersViewController *beersViewController = [segue destinationViewController];
        
        if ([object isKindOfClass:([BeerCategoryM class])])
        {
            BeerCategoryM* beerCategory = object;
            beersViewController.parentBeerCategory = beerCategory;
        }
       
        if ([object isKindOfClass:([CountryM class])])
        {
            CountryM* country = object;
            beersViewController.parentCountry = country;
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

#pragma mark - Action Handlers

- (IBAction)categorySegValueChanged:(id)sender
{
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
