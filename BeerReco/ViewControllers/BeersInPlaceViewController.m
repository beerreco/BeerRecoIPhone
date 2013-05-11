//
//  BeersInPlaceViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/12/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeersInPlaceViewController.h"

#import "BeerDetailsViewController.h"

@interface BeersInPlaceViewController ()

@end

@implementation BeersInPlaceViewController

@synthesize placeView = _placeView;

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
    if (self.placeView == nil)
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
    self.navigationItem.title = self.placeView.place.name;
}

-(void)setup
{
}

#pragma mark - BaseSearchAndRefreshTableViewController

-(void)loadCurrentData
{
    if (self.placeView)
    {
        [[ComServices sharedComServices].placesService getBeersByPlace:self.placeView.place.id onComplete:^(NSMutableArray *beerInPlaceViews, NSError *error)
        {            
             if (error == nil && beerInPlaceViews != nil)
             {
                 [self dataLoaded:beerInPlaceViews];
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
    return @"beerView.beer.name";
}

-(NSString*)getSearchablePropertyName
{
    return @"beerView.beer.name";
}

-(NSString*)getCellIdentifier
{
    return [super getCellIdentifier];
}

-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    [cell.detailTextLabel setText:@""];
    [cell.imageView setImage:nil];
    
    if ([object isKindOfClass:([BeerInPlaceViewM class])])
    {
        BeerInPlaceViewM *beerInPlaceView = object;
        
        // Configure the cell
        [cell.textLabel setText:beerInPlaceView.beerView.beer.name];
        
        NSString* details = @"";
        
        if (beerInPlaceView.beerInPlace.price > 0)
        {
            details = [details stringByAppendingFormat:@"Price: %.0f", beerInPlaceView.beerInPlace.price];
        }
        else
        {
            details = @"Price: N/A";
        }
        
        [cell.detailTextLabel setText:details];
        
        NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:beerInPlaceView.beerView.beer.beerIconUrl];
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
        
        if ([object isKindOfClass:([BeerInPlaceViewM class])])
        {
            BeerInPlaceViewM* beerInPlaceViewM = object;
            beerDetailsViewController.beerView = beerInPlaceViewM.beerView;
        }
    }
}

@end
