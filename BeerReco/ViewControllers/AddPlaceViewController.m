//
//  AddEditPlaceViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "AddPlaceViewController.h"

@interface AddPlaceViewController ()

@property (nonatomic, strong) NSString* txtNewPlacePreviousValue;
@property (nonatomic, strong) NSString* txtNewPlaceTypePreviousValue;
@property (nonatomic, strong) NSString* txtAddressPreviousValue;

@property (nonatomic, weak) UILabel* lblSelectedPlaceType;
@property (nonatomic, weak) UILabel* lblNewPlaceType;
@property (nonatomic, weak) UILabel* lblSelectedArea;

@property (nonatomic, strong) UIImage* selectedIcon;

@property (nonatomic, strong) PlaceM* createdPlace;

@end

@implementation AddPlaceViewController

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
    [self setBtnGallery:nil];
    [self setBtnCamera:nil];
    [self setBtnClearArea:nil];
    [self setTxtAddress:nil];
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
        
        if (self.txtPlaceName.isFirstResponder)
        {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        else if (self.txtNewPlaceType.isFirstResponder)
        {
            indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
        }
        else if (self.txtAddress.isFirstResponder)
        {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
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

- (void)txtPlaceNameValueChanged:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= self.txtFieldName.text.length < 40;
    
    if (!isValid)
    {
        self.txtPlaceName.text = self.txtNewPlacePreviousValue;
    }
    else
    {
        self.txtNewPlacePreviousValue = self.txtPlaceName.text;
        
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

- (void)switchPlaceTypeValueChanged:(id)sender
{
    [self.lblSelectedPlaceType setEnabled:!self.switchPlaceType.on];
    
    [self.lblNewPlaceType setEnabled:self.switchPlaceType.on];
    [self.txtNewPlaceType setEnabled:self.switchPlaceType.on];
    
    [self formValidation];
    
    UITableViewCell* cell = [self.tbProperties cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    if (self.switchPlaceType.isOn)
    {
        [self.btnClearPlaceType setHidden:YES];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.txtNewPlaceType becomeFirstResponder];
    }
    else
    {
        [self.btnClearPlaceType setHidden:self.selectedPlaceType == nil];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        [self.txtNewPlaceType resignFirstResponder];
    }
}

- (void)txtNewPlaceTypeValueChanged:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= self.txtNewPlaceType.text.length < 40;
    
    if (!isValid)
    {
        self.txtNewPlaceType.text = self.txtNewPlaceTypePreviousValue;
    }
    else
    {
        self.txtNewPlaceTypePreviousValue = self.txtNewPlaceType.text;
        
        [self formValidation];
    }
}

- (void)clearAreaClicked:(id)sender
{
    [self selectedArea:nil];
}

- (void)clearPlaceTypeClicked:(id)sender
{
    [self selectedPlaceType:nil];
}

- (void)txtAddressValueChanged:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= self.txtAddress.text.length < 40;
    
    if (!isValid)
    {
        self.txtAddress.text = self.txtAddressPreviousValue;
    }
    else
    {
        self.txtAddressPreviousValue = self.txtAddress.text;
        
        [self formValidation];
    }
}

#pragma mark - PlaceTypeSelectionDelegate

-(void)selectedPlaceType:(PlaceTypeM *)placeType
{
    self.selectedPlaceType = placeType;
    
    [self.tbProperties reloadData];
    
    [self formValidation];
    
    [self.btnClearPlaceType setHidden:self.selectedPlaceType == nil];
}

#pragma mark - AreaSelectionDelegate

-(void)selectedArea:(AreaM *)area
{
    self.selectedArea = area;
    
    [self.tbProperties reloadData];
    
    [self formValidation];
    
    [self.btnClearArea setHidden:self.selectedArea == nil];
}

#pragma mark - UIImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage* resizedImge = [[ComServices sharedComServices].fileManagementService image:img ByScalingToSize:CGSizeMake(60, 60)];
    
    self.selectedIcon = resizedImge;
    
    [self.imgPlaceIcon setImage:self.selectedIcon];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self formValidation];
    }];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlaceTypeSelectionSegue"])
    {
        PlaceAreasViewController *placeAreasViewController = [segue destinationViewController];
        placeAreasViewController.placeTypeSelectionDelegate = self;
        placeAreasViewController.placeTypeSelectionMode = YES;
    }
    else if ([segue.identifier isEqualToString:@"AreaSelectionSegue"])
    {
        PlaceAreasViewController *placeAreasViewController = [segue destinationViewController];
        placeAreasViewController.areaSelectionDelegate = self;
        placeAreasViewController.areaSelectionMode = YES;
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
    return 5;
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
        return 1;
    }
    else if (section == 4)
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
            CellIdentifier = @"cell_place_type";
        }
        else if (indexPath.row == 1)
        {
            CellIdentifier = @"cell_place_type2";
        }
        else if (indexPath.row == 2)
        {
            CellIdentifier = @"cell_place_type3";
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            CellIdentifier = @"cell_area";
        }
    }
    else if (indexPath.section == 4)
    {
        if (indexPath.row == 0)
        {
            CellIdentifier = @"cell_address";
        }
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
        if (self.txtPlaceName == nil)
        {
            self.txtPlaceName = (UITextField*)[cell viewWithTag:666];
            self.txtPlaceName.delegate = self;
            [self.txtPlaceName addTarget:self action:@selector(txtPlaceNameValueChanged:) forControlEvents:UIControlEventEditingChanged];
        }
    }
    else if (indexPath.section == 1)
    {
        if (self.imgPlaceIcon == nil)
        {
            self.imgPlaceIcon = (UIImageView*)[cell viewWithTag:666];
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
            
            if (self.selectedPlaceType)
            {
                cell.textLabel.text = self.selectedPlaceType.name;
            }
            else
            {
                cell.textLabel.text = @"Select Place Type: ...";
            }
            
            if (self.btnClearPlaceType == nil)
            {
                UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(0, 0, 47, 25);
                [button setTitle:@"Clear" forState:UIControlStateNormal];
                
                self.btnClearPlaceType = button;
                [self.btnClearPlaceType setHidden:YES];
                [self.btnClearPlaceType addTarget:self action:@selector(clearPlaceTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell setAccessoryType:self.selectedPlaceType ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator];
            
            cell.accessoryView = self.selectedPlaceType ? self.btnClearPlaceType : nil;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            self.lblSelectedPlaceType = cell.textLabel;
        }
        else if (indexPath.row == 1)
        {
            if (self.switchPlaceType == nil)
            {
                self.switchPlaceType = (UISwitch*)[cell viewWithTag:666];
                [self.switchPlaceType addTarget:self action:@selector(switchPlaceTypeValueChanged:) forControlEvents:UIControlEventValueChanged];
            }
            
            cell.textLabel.text = @"Create New";
            [cell.textLabel setEnabled:NO];
            
            self.lblNewPlaceType = cell.textLabel;
        }
        else if (indexPath.row == 2)
        {
            if (self.txtNewPlaceType == nil)
            {
                self.txtNewPlaceType = (UITextField*)[cell viewWithTag:666];
                self.txtNewPlaceType.delegate = self;
                [self.txtNewPlaceType addTarget:self action:@selector(txtNewPlaceTypeValueChanged:) forControlEvents:UIControlEventEditingChanged];
            }
            
            [self.txtNewPlaceType setEnabled:self.switchPlaceType.on];
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
            
            if (self.selectedArea)
            {
                cell.textLabel.text = self.selectedArea.name;
            }
            else
            {
                cell.textLabel.text = @"Select Area: ...";
            }
            
            if (self.btnClearArea == nil)
            {
                UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(0, 0, 47, 25);
                [button setTitle:@"Clear" forState:UIControlStateNormal];
                
                self.btnClearArea = button;
                [self.btnClearArea setHidden:YES];
                [self.btnClearArea addTarget:self action:@selector(clearAreaClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell setAccessoryType:self.selectedArea ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator];
            
            cell.accessoryView = self.selectedArea ? self.btnClearArea : nil;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            self.lblSelectedArea = cell.textLabel;
        }
    }
    else if (indexPath.section == 4)
    {
        if (self.txtAddress == nil)
        {
            self.txtAddress = (UITextField*)[cell viewWithTag:666];
            self.txtAddress.delegate = self;
            [self.txtAddress addTarget:self action:@selector(txtAddressValueChanged:) forControlEvents:UIControlEventEditingChanged];
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
        
        title = @"Area";
    }
    else if (section == 4)
    {
        
        title = @"Address";
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
    if (indexPath.section == 2 && !self.switchPlaceType.isOn)
    {
        if (indexPath.row == 0)
        {
            // Perform segue to beer detail
            [self performSegueWithIdentifier:@"PlaceTypeSelectionSegue" sender:tableView];
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            // Perform segue to beer detail
            [self performSegueWithIdentifier:@"AreaSelectionSegue" sender:tableView];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Virtual Methods

-(void)innerVisualSetup
{
    self.viewTitle = @"New Place";
}

-(void)innerSetup
{
}

-(BOOL)formValidation
{
    BOOL isValid = ![NSString isNullOrEmpty:self.txtPlaceName.text];
    
    isValid &= (self.selectedPlaceType != nil && !self.switchPlaceType.isOn) ||
    (self.switchPlaceType.isOn && self.txtNewPlaceType.text.length > 0);
    
    isValid &= self.selectedArea != nil;
    
    [self.btnSave setEnabled:isValid];
    
    return isValid;
}

-(void)saveItem:(id)object
{
    self.createdPlace = [[PlaceM alloc] init];
    self.createdPlace.name = self.txtPlaceName.text;
    
    if (self.selectedIcon)
    {
        [[ComServices sharedComServices].fileManagementService uploadFile:self.selectedIcon ofEntity:ImageOfPlace onComplete:^(NSString *filePath, NSError *error)
         {
             if (error || [NSString isNullOrEmpty:filePath])
             {
                 [super showSaveResult:0 withMessage:@"Error while uploading the image"];
             }
             else
             {
                 self.createdPlace.placeIconUrl = filePath;
                 [self addPlaceTypeToPlace];
             }
         }];
    }
    else
    {
        [self addPlaceTypeToPlace];
    }
}

-(void)addPlaceTypeToPlace
{
    if (self.switchPlaceType.isOn && ![NSString isNullOrEmpty:self.txtNewPlaceType.text])
    {
        PlaceTypeM* placeType = [[PlaceTypeM alloc] init];
        placeType.name = self.txtNewPlaceType.text;
        
        [[ComServices sharedComServices].placeTypeService addPlaceType:placeType onComplete:^(PlaceTypeM *placeType, NSError *error)
        {   
             if (error)
             {
                 [self deleteNewEntitiesUponFailure];
                 
                 [super showSaveResult:0 withMessage:@"An error occured while creating a place type"];
             }
             else
             {
                 self.createdPlace.placeTypeId = placeType.id;
                 [self addAreaToPlace];
             }
         }];
    }
    else
    {
        self.createdPlace.placeTypeId = self.selectedPlaceType.id;
        [self addAreaToPlace];
    }
}

-(void)addAreaToPlace
{
    if (self.selectedArea)
    {
        self.createdPlace.areaId = self.selectedArea.id;
    }
    
    [self addAddressToBeer];
}

-(void)addAddressToBeer
{
    if (![NSString isNullOrEmpty:self.txtAddress.text])
    {
        self.createdPlace.address = self.txtAddress.text;
    }
    
    [[ComServices sharedComServices].placesService addPlace:self.createdPlace onComplete:^(PlaceM *place, NSError *error)
    {   
         NSString* msg;
         int result = 0;
         
         if (error)
         {
             [self deleteNewEntitiesUponFailure];
             
             msg = @"An error occured while adding a place";
         }
         else
         {
             msg = @"Place was added and awaits admin's approval";
             result = 666;
         }
         
         if (self.createdPlace)
         {
             self.createdPlace = nil;
             [super showSaveResult:result withMessage:msg];
         }
     }];
}

-(void)deleteNewEntitiesUponFailure
{
    // Place Type
    if (self.switchPlaceType.isOn &&
        ![NSString isNullOrEmpty:self.txtNewPlaceType.text] &&
        ![NSString isNullOrEmpty:self.createdPlace.placeTypeId])
    {
        [[ComServices sharedComServices].placeTypeService deletePlaceType:self.createdPlace.placeTypeId onComplete:^(NSError *error)
        {
        }];
    }
    
    self.createdPlace = nil;
}

@end
