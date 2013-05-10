//
//  PlaceAreasViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlaceAreasViewController.h"
#import "PlacesViewController.h"

@interface PlaceAreasViewController ()

@end

@implementation PlaceAreasViewController

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
    self.navigationItem.title = @"Areas";
}

-(void)setup
{
}

#pragma mark - BaseSearchAndRefreshTableViewController

-(void)loadCurrentData
{
    if (self.segPlaceFiltering.selectedSegmentIndex == 0)
    {
        [[ComServices sharedComServices].areasService getAllAreas:^(NSMutableArray *areas, NSError *error)
         {
             if (error == nil && areas != nil)
             {
                 [self dataLoaded:areas];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
    else if (self.segPlaceFiltering.selectedSegmentIndex == 1)
    {
        [[ComServices sharedComServices].placesService getAllPlaces:^(NSMutableArray *places, NSError *error)
         {
             if (error == nil && places != nil)
             {
                 [self dataLoaded:places];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
}

-(NSString*)getSearchablePropertyName
{
    if (self.segPlaceFiltering.selectedSegmentIndex == 1)
    {
        return @"place.name";
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
    
    if ([object isKindOfClass:([AreaM class])])
    {
        AreaM *area = object;
        
        // Configure the cell
        [cell.textLabel setText:area.name];
    }
    else if ([object isKindOfClass:([PlaceViewM class])])
    {
        PlaceViewM* placeView = object;
        
        [cell.textLabel setText:placeView.place.name];
        [cell.detailTextLabel setText:placeView.area.name];
        
        NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:placeView.place.placeIconUrl];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"weihenstephaner_hefe_icon"]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
}

-(void)tableItemSelected:(NSIndexPath *)indexPath
{
    if (self.segPlaceFiltering.selectedSegmentIndex == 1)
    {
        [self performSegueWithIdentifier:@"PlaceDetailsSegue" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"PlacesInAreaSegue" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object
{
    if ([segue.identifier isEqualToString:@"PlacesInAreaSegue"])
    {
        PlacesViewController *placesViewController = [segue destinationViewController];
        
        if ([object isKindOfClass:([AreaM class])])
        {
            AreaM* area = object;            
            placesViewController.parentArea = area;
            [placesViewController setTitle:area.name];
        }
    }
    
    if ([segue.identifier isEqualToString:@"PlaceDetailsSegue"])
    {
        PlaceDetailsViewController *placeDetailsViewController = [segue destinationViewController];
        
        if ([object isKindOfClass:([PlaceViewM class])])
        {
            PlaceViewM* placeView = object;
            placeDetailsViewController.placeView = placeView;
            [placeDetailsViewController setTitle:placeView.place.name];
        }
    }
}

#pragma mark - Action Handlers

- (IBAction)placeFilteringValueChanged:(id)sender
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
