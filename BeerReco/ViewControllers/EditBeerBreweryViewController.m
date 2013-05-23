//
//  EditBreweryViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "EditBeerBreweryViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EditBeerBreweryViewController ()

@property (nonatomic, weak) UISwitch* switchControl;
@property (nonatomic, weak) UILabel* lblNew;
@property (nonatomic, weak) UILabel* lblNewBeerType;

@end

@implementation EditBeerBreweryViewController

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
    [self setBtnClearSelection:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
    fieldUpdateData.originalObjectId = self.editedItem.beer.id;
    fieldUpdateData.editedFieldName = @"breweryId";
    fieldUpdateData.oldValue = self.editedItem.beer.breweryId;
    fieldUpdateData.suggestedValue = newId;
    
    [[ComServices sharedComServices].beersService updateBeer:fieldUpdateData onComplete:^(NSError *error)
     {
         NSString* msg;
         int result = 0;
         
         if (error)
         {
             msg = @"An error occured while updating brewery of beer";
         }
         else
         {
             msg = @"Brewery of beer was updated and awaits admin's approval";
             result = 666;
         }
         
         [super showSaveResult:result withMessage:msg];
     }];
}

#pragma mark - Notification Handlers

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
        [self.tbSelection setContentInset:edgeInsets];
        [self.tbSelection setScrollIndicatorInsets:edgeInsets];
        
        [self.tbSelection scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [self.tbSelection setContentInset:edgeInsets];
        [self.tbSelection setScrollIndicatorInsets:edgeInsets];
    }];
}

#pragma mark - Virtual Methods

-(void)innerVisualSetup
{
    self.viewTitle = [NSString stringWithFormat:@"Brewery of '%@'", self.editedItem.beer.name];
}

-(void)innerSetup
{
}

-(BOOL)formValidation
{
    BOOL isValid = self.selectedItem != nil && !self.switchControl.isOn;
    
    isValid |= self.switchControl.isOn && self.txtFieldName.text.length > 0;
    
    [self.btnSave setEnabled:isValid];
    
    return isValid;
}

-(BOOL)innerValidateEditedTextField:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= self.txtFieldName.text.length < 40;
    
    return isValid;
}

-(void)saveItem:(id)object
{
    if (self.editedItem)
    {
        if (self.switchControl.isOn && ![NSString isNullOrEmpty:object])
        {
            BreweryM* brewery = [[BreweryM alloc] init];
            brewery.name = object;
            
            [[ComServices sharedComServices].breweryService addBrewery:brewery onComplete:^(BreweryM *brewery, NSError *error)
            {   
                 if (error)
                 {
                     [super showSaveResult:0 withMessage:@"An error occured while creating a beer brewery"];
                 }
                 else
                 {
                     [self updateBeerWithNewId:brewery.id];
                 }
             }];
        }
        else
        {
            [self updateBeerWithNewId:self.selectedItem.id];
        }
    }
}

#pragma mark - Action Handlers

- (IBAction)clearSelectionClicked:(id)sender
{
    [self selectedBrewery:nil];
}

-(void)switchValueChanged:(UISwitch*)sender
{
    [self.txtFieldName setEnabled:self.switchControl.on];
    
    [self.lblNewBeerType setEnabled:!self.switchControl.on];
    [self.lblNew setEnabled:self.switchControl.on];
    
    [self formValidation];
    
    UITableViewCell* cell = [self.tbSelection cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if (self.switchControl.isOn)
    {
        [self.btnClearSelection setHidden:YES];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.txtFieldName becomeFirstResponder];
    }
    else
    {
        [self.btnClearSelection setHidden:self.selectedItem == nil];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        [self.txtFieldName resignFirstResponder];
    }
}

#pragma mark - BrewerySelectionDelegate

-(void)selectedBrewery:(BreweryM *)brewery
{
    self.selectedItem = brewery;
    
    [self.tbSelection reloadData];
    
    [self formValidation];
    
    [self.btnClearSelection setHidden:self.selectedItem == nil];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"brewerySelectionSegue"])
    {
        BeerCategoriesViewController *beerCategoriesViewController = [segue destinationViewController];
        beerCategoriesViewController.brewerySelectionDelegate = self;
        beerCategoriesViewController.brewerySelectionMode = YES;
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
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cell";
    
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        CellIdentifier = @"cell2";
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        CellIdentifier = @"cell3";
    }
    
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
        cell.textLabel.text = self.editedItem.brewery.name;
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
                cell.textLabel.text = @"Select Brewery: ...";
            }
            
            self.lblNewBeerType = cell.textLabel;
        }
        else if (indexPath.row == 1)
        {
            if (self.switchControl == nil)
            {
                self.switchControl = (UISwitch*)[cell viewWithTag:666];
                [self.switchControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            }
            
            cell.textLabel.text = @"Create New";
            [cell.textLabel setEnabled:NO];
            
            self.lblNew = cell.textLabel;
        }
        else if (indexPath.row == 2)
        {
            if (self.txtFieldName == nil)
            {
                self.txtFieldName = (UITextField*)[cell viewWithTag:666];
                [self.txtFieldName addTarget:self action:@selector(fieldNameValueChanged:) forControlEvents:UIControlEventEditingChanged];
            }
            
            [self.txtFieldName setEnabled:self.switchControl.on];
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
        title = @"Current Brewery";
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
    if (indexPath.section == 1 && !self.switchControl.isOn)
    {
        if (indexPath.row == 0)
        {
            // Perform segue to beer detail
            [self performSegueWithIdentifier:@"brewerySelectionSegue" sender:tableView];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
