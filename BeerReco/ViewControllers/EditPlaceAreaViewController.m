//
//  EditPlaceAreaViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "EditPlaceAreaViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EditPlaceAreaViewController ()

@end

@implementation EditPlaceAreaViewController

@synthesize selectedItem = _selectedItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{   
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods

-(void)updateBeerWithNewId:(NSString*)newId
{
    FieldUpdateDataM* fieldUpdateData = [[FieldUpdateDataM alloc] init];
    fieldUpdateData.originalObjectId = self.editedItem.place.id;
    fieldUpdateData.editedFieldName = @"areaId";
    fieldUpdateData.oldValue = self.editedItem.place.areaId;
    fieldUpdateData.suggestedValue = newId;
    
    [[ComServices sharedComServices].placesService updatePlace:fieldUpdateData onComplete:^(NSError *error)
     {
         NSString* msg;
         int result = 0;
         
         if (error)
         {
             msg = @"An error occured while updating area of place";
         }
         else
         {
             msg = @"Area of place was updated and awaits admin's approval";
             result = 666;
         }
         
         [super showSaveResult:result withMessage:msg];
     }];
}

#pragma mark - Virtual Methods

-(void)innerVisualSetup
{
    self.viewTitle = [NSString stringWithFormat:@"Area of '%@'", self.editedItem.place.name];
}

-(void)innerSetup
{
}

-(BOOL)formValidation
{
    BOOL isValid = self.selectedItem != nil;
    
    [self.btnSave setEnabled:isValid];
    
    return isValid;
}

-(void)saveItem:(id)object
{
    if (self.editedItem)
    {
        [self updateBeerWithNewId:self.selectedItem.id];
    }
}

#pragma mark - BrewerySelectionDelegate

-(void)selectedArea:(AreaM *)area
{
    self.selectedItem = area;
    
    [self.tbSelection reloadData];
    
    [self formValidation];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"areaSelectionSegue"])
    {
        PlaceAreasViewController *placeAreasViewController = [segue destinationViewController];
        placeAreasViewController.areaSelectionDelegate = self;
        placeAreasViewController.areaSelectionMode = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
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
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell.textLabel.text = self.editedItem.area.name;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            if (self.selectedItem)
            {
                cell.textLabel.text = self.selectedItem.name;
            }
            else
            {
                cell.textLabel.text = @"Select Area: ...";
            }
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
    NSString* title = @"";
    
    if (section == 0)
    {
        title = @"Current Area";
    }
    else if (section == 1)
    {
        
        title = @"New Selection";
    }
    
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            // Perform segue to beer detail
            [self performSegueWithIdentifier:@"areaSelectionSegue" sender:tableView];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
