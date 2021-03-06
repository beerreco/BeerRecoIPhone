//
//  BeerInPlacesViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/11/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerInPlacesViewController.h"

#import "PlaceDetailsViewController.h"
#import "AddEditBeerInPlacesViewController.h"

@interface BeerInPlacesViewController ()

@end

@implementation BeerInPlacesViewController

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
    if (self.beerView == nil)
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
    self.navigationItem.title = self.beerView.beer.name;
}

-(void)setup
{
}

#pragma mark - BaseSearchAndRefreshTableViewController

-(void)loadCurrentData
{
    if (self.beerView)
    {
        [[ComServices sharedComServices].beersService getPlacesByBeer:self.beerView.beer.id onComplete:^(NSMutableArray *beerInPlaceViews, NSError *error)
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
    return @"placeView.place.name";
}

-(NSString*)getSearchablePropertyName
{
    return @"placeView.place.name";
}

-(NSString*)getCellIdentifier
{
    return [super getCellIdentifier];
}

-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryView:[super makeDetailDisclosureButton]];
    
    [cell.detailTextLabel setText:@""];
    [cell.imageView setImage:nil];
    
    if ([object isKindOfClass:([BeerInPlaceViewM class])])
    {
        BeerInPlaceViewM *beerInPlaceView = object;
        
        // Configure the cell
        [cell.textLabel setText:beerInPlaceView.placeView.place.name];
        
        NSString* details = @"";
        
        if (beerInPlaceView.beerInPlace.price > 0)
        {
            details = [details stringByAppendingFormat:@"Price: %.1f", beerInPlaceView.beerInPlace.price];
        }
        else
        {
            details = @"Price: N/A";
        }
        
        [cell.detailTextLabel setText:details];
        
        NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:beerInPlaceView.placeView.place.placeIconUrl];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"place_icon_default"]];
    }
}

-(void)tableItemAccessoryClicked:(NSIndexPath *)indexPath
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    AddEditBeerInPlacesViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditBeerInPlacesViewController"];
    
    vc.editedItem = [self.itemsArray objectAtIndex:indexPath.row];
    vc.beerView = self.beerView;
    
    [navController setViewControllers:@[vc]];
    
    [self presentModalViewController:navController animated:YES];
}

-(void)tableItemSelected:(NSIndexPath *)indexPath withObject:(id)object
{
    [self performSegueWithIdentifier:@"PlaceDetailsSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object
{
    if ([segue.identifier isEqualToString:@"PlaceDetailsSegue"])
    {
        PlaceDetailsViewController *placeDetailsViewController = [segue destinationViewController];
        
        if ([object isKindOfClass:([BeerInPlaceViewM class])])
        {
            BeerInPlaceViewM* beerInPlaceViewM = object;
            placeDetailsViewController.placeView = beerInPlaceViewM.placeView;
        }
    }
}

-(void)addNewItem
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    AddEditBeerInPlacesViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditBeerInPlacesViewController"];
    
    vc.beerView = self.beerView;
    
    [navController setViewControllers:@[vc]];
    
    [self presentModalViewController:navController animated:YES];
}

@end
