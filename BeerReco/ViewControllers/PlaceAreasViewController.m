//
//  PlaceAreasViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlaceAreasViewController.h"
#import "PlacesViewController.h"
#import "AddEditAreaViewController.h"
#import "AddEditPlaceTypeViewController.h"
#import "AddEditPlaceViewController.h"

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
    if (self.placeSelectionMode)
    {
        self.navigationItem.titleView = nil;
        
        self.navigationItem.title = @"Place Selection";
    }
    else if (self.placeTypeSelectionMode)
    {
        self.navigationItem.titleView = nil;
        
        self.navigationItem.title = @"Place Type Selection";
    }
    else if (self.areaSelectionMode)
    {
        self.navigationItem.titleView = nil;
        
        self.navigationItem.title = @"Area Selection";
    }
    else
    {
        self.navigationItem.title = @"Place Categories";
    }
}

-(void)setup
{
}

#pragma mark - BaseSearchAndRefreshTableViewController

-(BOOL)canShowContributionToolBar
{
    return self.placeSelectionMode ||
    self.placeTypeSelectionMode ||
    self.areaSelectionMode ||
    self.segPlaceFiltering.selectedSegmentIndex == 0 ? NO : YES;
}

-(BOOL)shouldSortItemsList
{
    return self.areaSelectionMode ||
    (self.segPlaceFiltering && self.segPlaceFiltering.selectedSegmentIndex == 0) ? NO : YES;
}

-(void)loadCurrentData
{
    if ((self.segPlaceFiltering && self.segPlaceFiltering.selectedSegmentIndex == 0) || self.areaSelectionMode)
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
    else if ((self.segPlaceFiltering &&self.segPlaceFiltering.selectedSegmentIndex == 1) || self.placeTypeSelectionMode)
    {
        [[ComServices sharedComServices].placeTypeService getAllPlaceTypes:^(NSMutableArray *placeTypes, NSError *error)
        {   
             if (error == nil && placeTypes != nil)
             {
                 [self dataLoaded:placeTypes];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
    else if ((self.segPlaceFiltering && self.segPlaceFiltering.selectedSegmentIndex == 2) ||
             self.placeSelectionMode)
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

-(NSString*)getSortingKeyPath
{
    if ((self.segPlaceFiltering && self.segPlaceFiltering.selectedSegmentIndex == 2) ||
        self.placeSelectionMode)
    {
        return @"place.name";
    }
    else
    {
        return @"name";
    }
}

-(NSString*)getSearchablePropertyName
{
    if ((self.segPlaceFiltering && self.segPlaceFiltering.selectedSegmentIndex == 2) ||
        self.placeSelectionMode)
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
    if (self.placeSelectionMode ||
        self.placeTypeSelectionMode ||
        self.areaSelectionMode)
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
    
    if ([object isKindOfClass:([AreaM class])])
    {
        AreaM *area = object;
        
        // Configure the cell
        [cell.textLabel setText:area.name];
    }
    else if ([object isKindOfClass:([PlaceTypeM class])])
    {
        PlaceTypeM *placeType = object;
        
        // Configure the cell
        [cell.textLabel setText:placeType.name];
    }
    else if ([object isKindOfClass:([PlaceViewM class])])
    {
        PlaceViewM* placeView = object;
        
        [cell.textLabel setText:placeView.place.name];
        
        NSString* details = @"";
        
        if (placeView.area)
        {
            details = [details stringByAppendingFormat:@"Area: %@", placeView.area.name];
        }
        
        if (placeView.placeType)
        {
            if (![NSString isNullOrEmpty:details])
            {
                details = [details stringByAppendingString:@" - "];
            }
            
            details = [details stringByAppendingFormat:@"Type: %@", placeView.placeType.name];
        }
        
        [cell.detailTextLabel setText:details];
        
        NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:placeView.place.placeIconUrl];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"place_icon_default"]];
    }
}

-(void)tableItemAccessoryClicked:(NSIndexPath *)indexPath
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    if (self.segPlaceFiltering.selectedSegmentIndex == 0)
    {
        AddEditAreaViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditAreaViewController"];

        vc.editedItem = [self.itemsArray objectAtIndex:indexPath.row];
        
        [navController setViewControllers:@[vc]];
    }
    else if (self.segPlaceFiltering.selectedSegmentIndex == 1)
    {
        AddEditPlaceTypeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditPlaceTypeViewController"];
        
        vc.editedItem = [self.itemsArray objectAtIndex:indexPath.row];
        
        [navController setViewControllers:@[vc]];
    }
    
    [self presentModalViewController:navController animated:YES];
}

-(void)tableItemSelected:(NSIndexPath *)indexPath withObject:(id)object
{
    if (self.placeSelectionMode)
    {
        [self.placeSelectionDelegate selectedPlace:object];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.placeTypeSelectionMode)
    {
        [self.placeTypeSelectionDelegate selectedPlaceType:object];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.areaSelectionMode)
    {
        [self.areaSelectionDelegate selectedArea:object];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (self.segPlaceFiltering && self.segPlaceFiltering.selectedSegmentIndex == 2)
        {
            [self performSegueWithIdentifier:@"PlaceDetailsSegue" sender:nil];
        }
        else
        {
            [self performSegueWithIdentifier:@"PlacesInAreaSegue" sender:nil];
        }
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
        }
        else if ([object isKindOfClass:([PlaceTypeM class])])
        {
            PlaceTypeM* placeType = object;
            placesViewController.parentPlaceType = placeType;
        }
    }
    
    if ([segue.identifier isEqualToString:@"PlaceDetailsSegue"])
    {
        PlaceDetailsViewController *placeDetailsViewController = [segue destinationViewController];
        
        if ([object isKindOfClass:([PlaceViewM class])])
        {
            PlaceViewM* placeView = object;
            placeDetailsViewController.placeView = placeView;
        }
    }
}

-(void)addNewItem
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    if (self.segPlaceFiltering.selectedSegmentIndex == 0)
    {
        AddEditAreaViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditAreaViewController"];
        
        [navController setViewControllers:@[vc]];
    }
    else if (self.segPlaceFiltering.selectedSegmentIndex == 1)
    {
        AddEditPlaceTypeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditPlaceTypeViewController"];
        
        [navController setViewControllers:@[vc]];
    }
    else if (self.segPlaceFiltering.selectedSegmentIndex == 2)
    {
        AddEditPlaceViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditPlaceViewController"];
        
        [navController setViewControllers:@[vc]];
    }
    
    [self presentModalViewController:navController animated:YES];
}

#pragma mark - Action Handlers

- (IBAction)placeFilteringValueChanged:(id)sender
{
    if (self.editing)
    {
        [super toggleEditMode];
    }
    
    [self.barBtnEdit setEnabled:self.segPlaceFiltering.selectedSegmentIndex != 2];
    
    [super showHideContributionToolBar];
    
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
