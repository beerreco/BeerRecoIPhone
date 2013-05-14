//
//  PlacesViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlacesViewController.h"

@interface PlacesViewController ()

@end

@implementation PlacesViewController

@synthesize parentArea = _parentArea;
@synthesize parentPlaceType = _parentPlaceType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    if (self.parentArea == nil && self.parentPlaceType == nil)
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
    self.navigationItem.title = self.parentArea.name;
}

-(void)setup
{
}

#pragma mark - BaseSearchAndRefreshTableViewController

-(void)loadCurrentData
{
    if (self.parentArea)
    {
        [[ComServices sharedComServices].areasService getPlacesByArea:self.parentArea.id oncComplete:^(NSMutableArray *places, NSError *error)
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
    else if (self.parentPlaceType)
    {
        [[ComServices sharedComServices].placeTypeService getPlacesByPlaceType:self.parentPlaceType.id oncComplete:^(NSMutableArray *places, NSError *error)
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
    return @"place.name";
}

-(NSString*)getSearchablePropertyName
{
    return @"place.name";
}

-(NSString*)getCellIdentifier
{
    return [super getCellIdentifier];
}

-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    [cell.detailTextLabel setText:@""];
    [cell.imageView setImage:nil];
    
    if ([object isKindOfClass:([PlaceViewM class])])
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
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
}

-(void)tableItemSelected:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"PlaceDetailsSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object
{    
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

@end
