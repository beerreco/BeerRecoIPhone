//
//  AddEditBeerInPlaceViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/16/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "AddEditBeerInPlaceViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AddEditBeerInPlaceViewController ()

@end

@implementation AddEditBeerInPlaceViewController

@synthesize beerView = _beerView;
@synthesize placeView = _placeView;

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
    [self setLblBoxLabel:nil];
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

#pragma mark - Virtual Methods

-(void)innerVisualSetup
{
    self.viewTitle = [NSString stringWithFormat:@"Beer in '%@'", self.placeView.place.name];
    self.textFieldPlaceHolder = @"0.0";
    
    self.lblBoxLabel.text = [NSString stringWithFormat:@"Price in '%@'", self.placeView.place.name];
    
    if (self.editedItem)
    {
        self.previousValue = [NSString stringWithFormat:@"%.1f", self.editedItem.beerInPlace.price];
    }
    
    [self.txtFieldName setKeyboardType:UIKeyboardTypeDecimalPad];
}

-(void)innerSetup
{
    
}

-(BOOL)innerFormValidation
{
    return self.placeView || self.editedItem;
}

-(BOOL)innerValidateEditedTextField:(id)sender
{
    BOOL isValid = YES;
    NSArray* parts = [self.txtFieldName.text componentsSeparatedByString:@"."];
    int times = parts.count - 1;
    
    isValid &= times == 0 || times == 1;
    
    if (isValid)
    {
        NSString* decimalPart = [parts objectAtIndex:0];
        isValid &= decimalPart.length < 4;
    }
    
    if (isValid && times == 1)
    {
        NSString* floatPart = [parts objectAtIndex:1];
        isValid &= floatPart.length < 2;
    }
    
    return isValid;
}

-(void)saveItem:(id)object
{
    if (self.editedItem)
    {
        FieldUpdateDataM* fieldUpdateData = [[FieldUpdateDataM alloc] init];
        fieldUpdateData.originalObjectId = self.editedItem.beerInPlace.id;
        fieldUpdateData.editedFieldName = @"price";
        fieldUpdateData.oldValue = [NSString stringWithFormat:@"%.1f", self.editedItem.beerInPlace.price];
        fieldUpdateData.suggestedValue = object;
        
        [[ComServices sharedComServices].placesService updateBeerInPlace:fieldUpdateData onComplete:^(NSError *error)
         {
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while updating price of beer in place";
             }
             else
             {
                 msg = @"Price of beer in place was updated and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
    else
    {
        double price = [object doubleValue];
        
        [[ComServices sharedComServices].placesService addBeer:self.beerView.beer.id toPlace:self.placeView.place.id withPrice:price onComplete:^(BeerInPlaceM *beerInPlace, NSError *error)
         {
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while adding a beer to place";
             }
             else
             {
                 msg = @"A beer was added to place and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
}

#pragma mark - BeerSelectionDelegate

-(void)selectedBeer:(BeerViewM *)beerView
{
    self.beerView = beerView;
    
    [self.tbSelection reloadData];
    
    [super formValidation];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"beerSelectionSegue"])
    {
        BeerCategoriesViewController *beerCategoriesViewController = [segue destinationViewController];
        beerCategoriesViewController.beerSelectionDelegate = self;
        beerCategoriesViewController.beerSelectionMode = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cell";
    
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
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    BeerViewM* beerView;
    
    if (self.editedItem)
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        beerView = self.editedItem.beerView;
    }
    else if (self.beerView)
    {
        beerView = self.beerView;
    }
    
    if (beerView)
    {
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
    else
    {
        cell.textLabel.text = @"Select Beer: ...";
        cell.detailTextLabel.text = @"";
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
    if (self.editedItem == nil)
    {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                // Perform segue to beer detail
                [self performSegueWithIdentifier:@"beerSelectionSegue" sender:tableView];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
