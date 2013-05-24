//
//  AddEditBeerViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "AddBeerViewController.h"

@interface AddBeerViewController ()

@property (nonatomic, strong) NSString* txtNewBeerPreviousValue;
@property (nonatomic, strong) NSString* txtNewBeerTypePreviousValue;
@property (nonatomic, strong) NSString* txtNewCountryPreviousValue;
@property (nonatomic, strong) NSString* txtNewBreweryPreviousValue;
@property (nonatomic, strong) NSString* txtComponentsPreviousValue;
@property (nonatomic, strong) NSString* txtAlcoholPreviousValue;

@property (nonatomic, weak) UILabel* lblSelectedBeerType;
@property (nonatomic, weak) UILabel* lblNewBeerType;
@property (nonatomic, weak) UILabel* lblSelectedCountry;
@property (nonatomic, weak) UILabel* lblNewCountry;
@property (nonatomic, weak) UILabel* lblSelectedBrewery;
@property (nonatomic, weak) UILabel* lblNewBrewery;

@property (nonatomic, strong) UIImage* selectedIcon;

@property (nonatomic, strong) BeerM* createdBeer;

@end

@implementation AddBeerViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTxtBeerName:nil];
    [self setImgBeerIcon:nil];
    [self setBtnGallery:nil];
    [self setBtnCamera:nil];
    [self setSwitchBeerType:nil];
    [self setTxtNewBeerType:nil];
    [self setBtnClearBeerType:nil];
    [self setBtnClearCountry:nil];
    [self setSwitchCountry:nil];
    [self setTxtNewCountry:nil];
    [self setBtnClearBrewery:nil];
    [self setSwitchNewBrewery:nil];
    [self setTxtNewBrewery:nil];
    [self setTxtComponents:nil];
    [self setTxtAlcohol:nil];
    [self setTbProperties:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Handlers

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
        [self.tbProperties setContentInset:edgeInsets];
        [self.tbProperties setScrollIndicatorInsets:edgeInsets];
        
        NSIndexPath *indexPath;
        
        if (self.txtBeerName.isFirstResponder)
        {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        else if (self.txtNewBeerType.isFirstResponder)
        {
            indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
        }
        else if (self.txtNewCountry.isFirstResponder)
        {
            indexPath = [NSIndexPath indexPathForRow:2 inSection:3];
        }
        else if (self.txtNewBrewery.isFirstResponder)
        {
            indexPath = [NSIndexPath indexPathForRow:2 inSection:4];
        }
        else if (self.txtComponents.isFirstResponder)
        {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:5];
        }
        else if (self.txtAlcohol.isFirstResponder)
        {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:6];
        }
        
        [self.tbProperties scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [self.tbProperties setContentInset:edgeInsets];
        [self.tbProperties setScrollIndicatorInsets:edgeInsets];
    }];
}

#pragma mark - Action Handlers

- (void)txtBeerNameValueChanged:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= self.txtFieldName.text.length < 40;
    
    if (!isValid)
    {
        self.txtBeerName.text = self.txtNewBeerPreviousValue;
    }
    else
    {
        self.txtNewBeerPreviousValue = self.txtBeerName.text;
        
        [self formValidation];
    }
}

- (void)galleryClicked:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)cameraClicked:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)switchBeerTypeValueChanged:(id)sender
{
    [self.lblSelectedBeerType setEnabled:!self.switchBeerType.on];
    
    [self.lblNewBeerType setEnabled:self.switchBeerType.on];
    [self.txtNewBeerType setEnabled:self.switchBeerType.on];
    
    [self formValidation];
    
    UITableViewCell* cell = [self.tbProperties cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    if (self.switchBeerType.isOn)
    {
        [self.btnClearBeerType setHidden:YES];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.txtNewBeerType becomeFirstResponder];
    }
    else
    {
        [self.btnClearBeerType setHidden:self.selectedBeerType == nil];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        [self.txtNewBeerType resignFirstResponder];
    }
}

- (void)txtNewBeerTypeValueChanged:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= self.txtNewBeerType.text.length < 40;
    
    if (!isValid)
    {
        self.txtNewBeerType.text = self.txtNewBeerTypePreviousValue;
    }
    else
    {
        self.txtNewBeerTypePreviousValue = self.txtNewBeerType.text;
        
        [self formValidation];
    }
}

- (void)clearCountryClicked:(id)sender
{
    [self selectedOriginCountry:nil];
}

- (void)switchCountryValueChanged:(id)sender
{
    [self.lblSelectedCountry setEnabled:!self.switchCountry.on];
    
    [self.lblNewCountry setEnabled:self.switchCountry.on];
    [self.txtNewCountry setEnabled:self.switchCountry.on];
    
    [self formValidation];
    
    UITableViewCell* cell = [self.tbProperties cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    
    if (self.switchCountry.isOn)
    {
        [self.btnClearCountry setHidden:YES];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.txtNewCountry becomeFirstResponder];
    }
    else
    {
        [self.btnClearCountry setHidden:self.selectedCountry == nil];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        [self.txtNewCountry resignFirstResponder];
    }
}

- (void)txtNewCountryValueChanged:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= self.txtNewCountry.text.length < 40;
    
    if (!isValid)
    {
        self.txtNewCountry.text = self.txtNewCountryPreviousValue;
    }
    else
    {
        self.txtNewCountryPreviousValue = self.txtNewCountry.text;
        
        [self formValidation];
    }
}

- (void)clearBreweryClicked:(id)sender
{
    [self selectedBrewery:nil];
}

- (void)clearBeerTypeClicked:(id)sender
{
    [self selectedBeerType:nil];
}

- (void)switchNewBreweryValueChanged:(id)sender
{
    [self.lblSelectedBrewery setEnabled:!self.switchNewBrewery.on];
    
    [self.lblNewBrewery setEnabled:self.switchNewBrewery.on];
    [self.txtNewBrewery setEnabled:self.switchNewBrewery.on];
    
    [self formValidation];
    
    UITableViewCell* cell = [self.tbProperties cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    
    if (self.switchNewBrewery.isOn)
    {
        [self.btnClearBrewery setHidden:YES];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.txtNewBrewery becomeFirstResponder];
    }
    else
    {
        [self.btnClearBrewery setHidden:self.selectedBrewery == nil];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        [self.txtNewBrewery resignFirstResponder];
    }
}

- (void)txtNewBreweryValueChanged:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= self.txtNewBrewery.text.length < 40;
    
    if (!isValid)
    {
        self.txtNewBrewery.text = self.txtNewBreweryPreviousValue;
    }
    else
    {
        self.txtNewBreweryPreviousValue = self.txtNewBrewery.text;
        
        [self formValidation];
    }
}

- (void)txtComponentsValueChanged:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= self.txtComponents.text.length < 40;
    
    if (!isValid)
    {
        self.txtComponents.text = self.txtComponentsPreviousValue;
    }
    else
    {
        self.txtComponentsPreviousValue = self.txtComponents.text;
        
        [self formValidation];
    }
}

- (void)txtAlcoholValueChanged:(id)sender
{
    BOOL isValid = YES;
    
    NSArray* parts = [self.txtAlcohol.text componentsSeparatedByString:@"."];
    int times = parts.count - 1;
    
    isValid &= times == 0 || times == 1;
    
    if (isValid)
    {
        NSString* decimalPart = [parts objectAtIndex:0];
        isValid &= decimalPart.length < 3;
    }
    
    if (isValid && times == 1)
    {
        NSString* floatPart = [parts objectAtIndex:1];
        isValid &= floatPart.length < 2;
    }
    
    if (!isValid)
    {
        self.txtAlcohol.text = self.txtAlcoholPreviousValue;
    }
    else
    {
        self.txtAlcoholPreviousValue = self.txtAlcohol.text;
        
        [self formValidation];
    }
}

#pragma mark - BeerTypeSelectionDelegate

-(void)selectedBeerType:(BeerTypeM *)beerType
{
    self.selectedBeerType = beerType;
    
    [self.tbProperties reloadData];
    
    [self formValidation];
    
    [self.btnClearBeerType setHidden:self.selectedBeerType == nil];
}

#pragma mark - BrewerySelectionDelegate

-(void)selectedOriginCountry:(CountryM *)country
{
    self.selectedCountry = country;
    
    [self.tbProperties reloadData];
    
    [self formValidation];
    
    [self.btnClearCountry setHidden:self.selectedCountry == nil];
}

#pragma mark - BrewerySelectionDelegate

-(void)selectedBrewery:(BreweryM *)brewery
{
    self.selectedBrewery = brewery;
    
    [self.tbProperties reloadData];
    
    [self formValidation];
    
    [self.btnClearBrewery setHidden:self.selectedBrewery == nil];
}

#pragma mark - UIImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage* resizedImge = [[ComServices sharedComServices].fileManagementService image:img ByScalingToSize:CGSizeMake(60, 60)];
    
    self.selectedIcon = resizedImge;

    [self.imgBeerIcon setImage:self.selectedIcon];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self formValidation];
    }];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"beerTypeSelectionSegue"])
    {
        BeerCategoriesViewController *beerCategoriesViewController = [segue destinationViewController];
        beerCategoriesViewController.beerTypeSelectionDelegate = self;
        beerCategoriesViewController.beerTypeSelectionMode = YES;
    }
    else if ([segue.identifier isEqualToString:@"brewerySelectionSegue"])
    {
        BeerCategoriesViewController *beerCategoriesViewController = [segue destinationViewController];
        beerCategoriesViewController.brewerySelectionDelegate = self;
        beerCategoriesViewController.brewerySelectionMode = YES;
    }
    else if ([segue.identifier isEqualToString:@"originCountrySelectionSegue"])
    {
        BeerCategoriesViewController *beerCategoriesViewController = [segue destinationViewController];
        beerCategoriesViewController.originCountrySelectionDelegate = self;
        beerCategoriesViewController.originCountrySelectionMode = YES;
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
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
    else if (section == 2)
    {
        return 3;
    }
    else if (section == 3)
    {
        return 3;
    }
    else if (section == 4)
    {
        return 3;
    }
    else if (section == 5)
    {
        return 1;
    }
    else if (section == 6)
    {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cell";
    
    if (indexPath.section == 0)
    {
        CellIdentifier = @"cell_name";
    }
    else if (indexPath.section == 1)
    {
        CellIdentifier = @"cell_icon";
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            CellIdentifier = @"cell_beer_type";
        }
        else if (indexPath.row == 1)
        {
            CellIdentifier = @"cell_beer_type2";
        }
        else if (indexPath.row == 2)
        {
            CellIdentifier = @"cell_beer_type3";
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            CellIdentifier = @"cell_country";
        }
        else if (indexPath.row == 1)
        {
            CellIdentifier = @"cell_country2";
        }
        else if (indexPath.row == 2)
        {
            CellIdentifier = @"cell_country3";
        }
    }
    else if (indexPath.section == 4)
    {
        if (indexPath.row == 0)
        {
            CellIdentifier = @"cell_brewery";
        }
        else if (indexPath.row == 1)
        {
            CellIdentifier = @"cell_brewery2";
        }
        else if (indexPath.row == 2)
        {
            CellIdentifier = @"cell_brewery3";
        }
    }
    else if (indexPath.section == 5)
    {
        CellIdentifier = @"cell_components";
    }
    else if (indexPath.section == 6)
    {
        CellIdentifier = @"cell_alcohol";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0)
    {
        if (self.txtBeerName == nil)
        {
            self.txtBeerName = (UITextField*)[cell viewWithTag:666];
            self.txtBeerName.delegate = self;
            [self.txtBeerName addTarget:self action:@selector(txtBeerNameValueChanged:) forControlEvents:UIControlEventEditingChanged];
        }
    }
    else if (indexPath.section == 1)
    {
        if (self.imgBeerIcon == nil)
        {
            self.imgBeerIcon = (UIImageView*)[cell viewWithTag:666];
        }
        
        if (self.btnGallery == nil)
        {
            self.btnGallery = (UIButton*)[cell viewWithTag:667];
            [self.btnGallery addTarget:self action:@selector(galleryClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (self.btnCamera == nil)
        {
            self.btnCamera = (UIButton*)[cell viewWithTag:668];
            [self.btnCamera addTarget:self action:@selector(cameraClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.btnCamera setEnabled:[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
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
            
            if (self.selectedBeerType)
            {
                cell.textLabel.text = self.selectedBeerType.name;
            }
            else
            {
                cell.textLabel.text = @"Select Beer Type: ...";
            }
            
            if (self.btnClearBeerType == nil)
            {
                UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(0, 0, 47, 25);
                [button setTitle:@"Clear" forState:UIControlStateNormal];
                
                self.btnClearBeerType = button;
                [self.btnClearBeerType setHidden:YES];
                [self.btnClearBeerType addTarget:self action:@selector(clearBeerTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell setAccessoryType:self.selectedBeerType ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator];
            
            cell.accessoryView = self.selectedBeerType ? self.btnClearBeerType : nil;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            self.lblSelectedBeerType = cell.textLabel;
        }
        else if (indexPath.row == 1)
        {
            if (self.switchBeerType == nil)
            {
                self.switchBeerType = (UISwitch*)[cell viewWithTag:666];
                [self.switchBeerType addTarget:self action:@selector(switchBeerTypeValueChanged:) forControlEvents:UIControlEventValueChanged];
            }
            
            cell.textLabel.text = @"Create New";
            [cell.textLabel setEnabled:NO];
            
            self.lblNewBeerType = cell.textLabel;
        }
        else if (indexPath.row == 2)
        {
            if (self.txtNewBeerType == nil)
            {
                self.txtNewBeerType = (UITextField*)[cell viewWithTag:666];
                self.txtNewBeerType.delegate = self;
                [self.txtNewBeerType addTarget:self action:@selector(txtNewBeerTypeValueChanged:) forControlEvents:UIControlEventEditingChanged];
            }
            
            [self.txtNewBeerType setEnabled:self.switchBeerType.on];
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
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
            
            if (self.selectedCountry)
            {
                cell.textLabel.text = self.selectedCountry.name;
            }
            else
            {
                cell.textLabel.text = @"Select Origin Country: ...";
            }
            
            if (self.btnClearCountry == nil)
            {
                UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(0, 0, 47, 25);
                [button setTitle:@"Clear" forState:UIControlStateNormal];
                
                self.btnClearCountry = button;
                [self.btnClearCountry setHidden:YES];
                [self.btnClearCountry addTarget:self action:@selector(clearCountryClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell setAccessoryType:self.selectedCountry ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator];
            
            cell.accessoryView = self.selectedCountry ? self.btnClearCountry : nil;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            self.lblSelectedCountry = cell.textLabel;
        }
        else if (indexPath.row == 1)
        {
            if (self.switchCountry == nil)
            {
                self.switchCountry = (UISwitch*)[cell viewWithTag:666];
                [self.switchCountry addTarget:self action:@selector(switchCountryValueChanged:) forControlEvents:UIControlEventValueChanged];
            }
            
            cell.textLabel.text = @"Create New";
            [cell.textLabel setEnabled:NO];
            
            self.lblNewCountry = cell.textLabel;
        }
        else if (indexPath.row == 2)
        {
            if (self.txtNewCountry == nil)
            {
                self.txtNewCountry = (UITextField*)[cell viewWithTag:666];
                self.txtNewCountry.delegate = self;
                [self.txtNewCountry addTarget:self action:@selector(txtNewCountryValueChanged:) forControlEvents:UIControlEventEditingChanged];
            }
            
            [self.txtNewCountry setEnabled:self.switchCountry.on];
        }
    }
    else if (indexPath.section == 4)
    {
        if (indexPath.row == 0)
        {
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

            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            if (self.selectedBrewery)
            {
                cell.textLabel.text = self.selectedBrewery.name;
            }
            else
            {
                cell.textLabel.text = @"Select Brewery: ...";
            }
            
            if (self.btnClearBrewery == nil)
            {
                UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(0, 0, 47, 25);
                [button setTitle:@"Clear" forState:UIControlStateNormal];
                
                self.btnClearBrewery = button;
                [self.btnClearBrewery setHidden:YES];
                [self.btnClearBrewery addTarget:self action:@selector(clearBreweryClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell setAccessoryType:self.selectedBrewery ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator];
            
            cell.accessoryView = self.selectedBrewery ? self.btnClearBrewery : nil;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            self.lblSelectedBrewery = cell.textLabel;
        }
        else if (indexPath.row == 1)
        {
            if (self.switchNewBrewery == nil)
            {
                self.switchNewBrewery = (UISwitch*)[cell viewWithTag:666];
                [self.switchNewBrewery addTarget:self action:@selector(switchNewBreweryValueChanged:) forControlEvents:UIControlEventValueChanged];
            }
            
            cell.textLabel.text = @"Create New";
            [cell.textLabel setEnabled:NO];
            
            self.lblNewBrewery = cell.textLabel;
        }
        else if (indexPath.row == 2)
        {
            if (self.txtNewBrewery == nil)
            {
                self.txtNewBrewery = (UITextField*)[cell viewWithTag:666];
                self.txtNewBrewery.delegate = self;
                [self.txtNewBrewery addTarget:self action:@selector(txtNewBreweryValueChanged:) forControlEvents:UIControlEventEditingChanged];
            }
            
            [self.txtNewBrewery setEnabled:self.switchNewBrewery.on];
        }
    }
    else if (indexPath.section == 5)
    {
        if (self.txtComponents == nil)
        {
            self.txtComponents = (UITextField*)[cell viewWithTag:666];
            self.txtComponents.delegate = self;
            [self.txtComponents addTarget:self action:@selector(txtComponentsValueChanged:) forControlEvents:UIControlEventEditingChanged];
        }
    }
    else if (indexPath.section == 6)
    {
        if (self.txtAlcohol == nil)
        {
            self.txtAlcohol = (UITextField*)[cell viewWithTag:666];
            self.txtAlcohol.delegate = self;
            [self.txtAlcohol addTarget:self action:@selector(txtAlcoholValueChanged:) forControlEvents:UIControlEventEditingChanged];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return 70;
    }
    
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title = @"";
    
    if (section == 0)
    {
        title = @"Name";
    }
    else if (section == 1)
    {
        
        title = @"Icon";
    }
    else if (section == 2)
    {
        
        title = @"Type";
    }
    else if (section == 3)
    {
        
        title = @"Origin Country";
    }
    else if (section == 4)
    {
        
        title = @"Brewery";
    }
    else if (section == 5)
    {
        
        title = @"Components";
    }
    else if (section == 6)
    {
        
        title = @"Alcohol Percentage";
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
    if (indexPath.section == 2 && !self.switchBeerType.isOn)
    {
        if (indexPath.row == 0)
        {
            // Perform segue to beer detail
            [self performSegueWithIdentifier:@"beerTypeSelectionSegue" sender:tableView];
        }
    }
    else if (indexPath.section == 3 && !self.switchCountry.isOn)
    {
        if (indexPath.row == 0)
        {
            // Perform segue to beer detail
            [self performSegueWithIdentifier:@"originCountrySelectionSegue" sender:tableView];
        }
    }
    else if (indexPath.section == 4 && !self.switchNewBrewery.isOn)
    {
        if (indexPath.row == 0)
        {
            // Perform segue to beer detail
            [self performSegueWithIdentifier:@"brewerySelectionSegue" sender:tableView];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Virtual Methods

-(void)innerVisualSetup
{
    self.viewTitle = @"New Beer";
}

-(void)innerSetup
{
}

-(BOOL)formValidation
{
    BOOL isValid = ![NSString isNullOrEmpty:self.txtBeerName.text];
    
    isValid &= (self.selectedBeerType != nil && !self.switchBeerType.isOn) ||
    (self.switchBeerType.isOn && self.txtNewBeerType.text.length > 0);
    
    isValid &= !self.switchCountry.isOn || (self.switchCountry.isOn && self.txtNewCountry.text.length > 0);
    
    isValid &= !self.switchNewBrewery.isOn || (self.switchNewBrewery.isOn && self.txtNewBrewery.text.length > 0);
    
    [self.btnSave setEnabled:isValid];
    
    return isValid;
}

-(void)saveItem:(id)object
{
    self.createdBeer = [[BeerM alloc] init];
    self.createdBeer.name = self.txtBeerName.text;
    
    if (self.selectedIcon)
    {
        [[ComServices sharedComServices].fileManagementService uploadFile:self.selectedIcon ofEntity:ImageOfBeer onComplete:^(NSString *filePath, NSError *error)
         {
             if (error || [NSString isNullOrEmpty:filePath])
             {
                 [super showSaveResult:0 withMessage:@"Error while uploading the image"];
             }
             else
             {
                 self.createdBeer.beerIconUrl = filePath;
                 [self addBeerTypeToBeer];
             }
         }];
    }
    else
    {
        [self addBeerTypeToBeer];
    }
}

-(void)addBeerTypeToBeer
{
    if (self.switchBeerType.isOn && ![NSString isNullOrEmpty:self.txtNewBeerType.text])
    {
        BeerTypeM* beerType = [[BeerTypeM alloc] init];
        beerType.name = self.txtNewBeerType.text;
        
        [[ComServices sharedComServices].beerTypesService addBeerType:beerType onComplete:^(BeerTypeM *beerType, NSError *error)
         {
             if (error)
             {
                 [self deleteNewEntitiesUponFailure];
                 
                 [super showSaveResult:0 withMessage:@"An error occured while creating a beer type"];
             }
             else
             {
                 self.createdBeer.beerTypeId = beerType.id;
                 [self addCountryToBeer];
             }
         }];
    }
    else
    {
        self.createdBeer.beerTypeId = self.selectedBeerType.id;
        [self addCountryToBeer];
    }
}

-(void)addCountryToBeer
{
    if (self.switchCountry.isOn && ![NSString isNullOrEmpty:self.txtNewCountry.text])
    {
        CountryM* country = [[CountryM alloc] init];
        country.name = self.txtNewCountry.text;
        
        [[ComServices sharedComServices].originCountryService addOriginCountry:country onComplete:^(CountryM *country, NSError *error)
         {
             if (error)
             {
                 [self deleteNewEntitiesUponFailure];
                 
                 [super showSaveResult:0 withMessage:@"An error occured while creating origin country"];
             }
             else
             {
                 self.createdBeer.originCountryId = country.id;
                 [self addBreweryToBeer];
             }
         }];
    }
    else
    {
        if (self.selectedCountry)
        {
            self.createdBeer.originCountryId = self.selectedCountry.id;
        }
        
        [self addBreweryToBeer];
    }
}

-(void)addBreweryToBeer
{
    if (self.switchNewBrewery.isOn && ![NSString isNullOrEmpty:self.txtNewBrewery.text])
    {
        BreweryM* brewery = [[BreweryM alloc] init];
        brewery.name = self.txtNewBrewery.text;
        
        [[ComServices sharedComServices].breweryService addBrewery:brewery onComplete:^(BreweryM *brewery, NSError *error)
         {
             if (error)
             {
                 [self deleteNewEntitiesUponFailure];
                 
                 [super showSaveResult:0 withMessage:@"An error occured while creating a beer brewery"];
             }
             else
             {
                 self.createdBeer.breweryId = brewery.id;
                 [self addComponentsToBeer];
             }
         }];
    }
    else
    {
        if (self.selectedBrewery)
        {
            self.createdBeer.breweryId = self.selectedBrewery.id;
        }
        
        [self addComponentsToBeer];
    }
}

-(void)addComponentsToBeer
{
    if (![NSString isNullOrEmpty:self.txtComponents.text])
    {
        self.createdBeer.madeOf = self.txtComponents.text;
    }
    
    [self addAlcoholToBeer];
}

-(void)addAlcoholToBeer
{
    if (![NSString isNullOrEmpty:self.txtAlcohol.text])
    {
        self.createdBeer.alcoholPercent = [self.txtAlcohol.text doubleValue];
    }
    
    [[ComServices sharedComServices].beersService addBeer:self.createdBeer onComplete:^(BeerM *beer, NSError *error)
    {   
         NSString* msg;
         int result = 0;
         
         if (error)
         {
             [self deleteNewEntitiesUponFailure];
             
             msg = @"An error occured while adding a beer";
         }
         else
         {
             msg = @"Beer was added and awaits admin's approval";
             result = 666;
         }
        
        if (self.createdBeer)
        {
            self.createdBeer = nil;
            [super showSaveResult:result withMessage:msg];
        }
     }];
}

-(void)deleteNewEntitiesUponFailure
{
    // Brewery
    if (self.switchNewBrewery.isOn &&
        ![NSString isNullOrEmpty:self.txtNewBrewery.text] &&
        ![NSString isNullOrEmpty:self.createdBeer.breweryId])
    {
        [[ComServices sharedComServices].breweryService deleteBrewery:self.createdBeer.breweryId onComplete:^(NSError *error)
        {
        }];
    }
    
    // Country
    if (self.switchCountry.isOn &&
        ![NSString isNullOrEmpty:self.txtNewCountry.text] &&
        ![NSString isNullOrEmpty:self.createdBeer.originCountryId])
    {
        [[ComServices sharedComServices].originCountryService deleteOriginCountry:self.createdBeer.originCountryId onComplete:^(NSError *error)
         {
         }];
    }
    
    // Beer Type
    if (self.switchBeerType.isOn &&
        ![NSString isNullOrEmpty:self.txtNewBeerType.text] &&
        ![NSString isNullOrEmpty:self.createdBeer.beerTypeId])
    {
        [[ComServices sharedComServices].beerTypesService deleteBeerType:self.createdBeer.beerTypeId onComplete:^(NSError *error)
         {
         }];
    }
    
    self.createdBeer = nil;
}

@end
