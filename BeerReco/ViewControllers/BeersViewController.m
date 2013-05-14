//
//  BeersViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeersViewController.h"

@interface BeersViewController ()

@end

@implementation BeersViewController

@synthesize parentBeerType = _parentBeerType;
@synthesize parentBrewery = _parentBrewery;
@synthesize parentCountry = _parentCountry;

@synthesize beerView = _beerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if (self.parentBeerType == nil &&
        self.parentCountry == nil &&
        self.parentBrewery == nil &&
        self.beerView == nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
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
    if (self.parentBeerType)
    {
        self.navigationItem.title = self.parentBeerType.name;
    }
    else if (self.parentCountry)
    {
        self.navigationItem.title = self.parentCountry.name;
    }
    else if (self.parentBrewery)
    {
        self.navigationItem.title = self.parentBrewery.name;
    }
    else if (self.beerView)
    {
        self.navigationItem.title = [NSString stringWithFormat:@"Similar to '%@'", self.beerView.beer.name];
    }
}

-(void)setup
{
}

#pragma mark - BaseSearchAndRefreshTableViewController

-(void)loadCurrentData
{
    if (self.parentBeerType)
    {
        [[ComServices sharedComServices].beerTypesService getBeersByType:self.parentBeerType.id oncComplete:^(NSMutableArray *beers, NSError *error)
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
    else if (self.parentCountry)
    {
        [[ComServices sharedComServices].originCountryService getBeersByOriginCountry:self.parentCountry.id oncComplete:^(NSMutableArray *beers, NSError *error)
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
    else if (self.parentBrewery)
    {
        [[ComServices sharedComServices].breweryService getBeersByBrewery:self.parentBrewery.id oncComplete:^(NSMutableArray *beers, NSError *error)
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
    else if (self.beerView)
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
    return @"beer.name";
}

-(NSString*)getSearchablePropertyName
{
    return @"beer.name";
}

-(NSString*)getCellIdentifier
{
    return [super getCellIdentifier];
}

-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    [cell.detailTextLabel setText:@""];
    [cell.imageView setImage:nil];
    
    if ([object isKindOfClass:([BeerViewM class])])
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
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"weihenstephaner_hefe_icon"]];
    }    
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
}

-(void)tableItemSelected:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"BeerDetailsSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object
{
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

@end
