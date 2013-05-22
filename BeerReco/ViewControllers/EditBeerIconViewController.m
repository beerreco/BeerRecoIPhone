//
//  EditBeerIconViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/22/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "EditBeerIconViewController.h"

@interface EditBeerIconViewController ()

@property (nonatomic, strong) UIImage* selectedImage;

@end

@implementation EditBeerIconViewController

@synthesize selectedImage = _selectedImage;

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
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setImgNewIcon:nil];
    [self setBtnCamera:nil];
    [self setBtnSelectIcon:nil];
    [super viewDidUnload];
}

#pragma mark - Virtual Methods

-(void)innerVisualSetup
{
    [self.imgNewIcon setImage:[UIImage imageNamed:@"picker_placeholder"]];
    
    self.viewTitle = @"Beer Icon";
    self.textFieldPlaceHolder = @"Beer Icon";
    
    if (self.editedItem)
    {
        self.previousValue = self.editedItem.beerIconUrl;
    }
    
    [self.btnCamera setEnabled:[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]];
}

-(void)innerSetup
{
    
}

-(BOOL)formValidation
{
    BOOL isValid = self.selectedImage != nil;
    
    [self.btnSave setEnabled:isValid];
    
    return isValid;
}

-(void)saveItem:(id)object
{
    if (self.editedItem)
    {
        [[ComServices sharedComServices].fileManagementService uploadFile:self.selectedImage ofEntity:ImageOfBeer onComplete:^(NSString *filePath, NSError *error)
        {   
            if (error || [NSString isNullOrEmpty:filePath])
            {
                [super showSaveResult:0 withMessage:@"Error while uploading the image"];
            }
            else
            {
                FieldUpdateDataM* fieldUpdateData = [[FieldUpdateDataM alloc] init];
                fieldUpdateData.originalObjectId = self.editedItem.id;
                fieldUpdateData.editedFieldName = @"beerIconUrl";
                fieldUpdateData.oldValue = self.editedItem.beerIconUrl;
                fieldUpdateData.suggestedValue = filePath;
                
                [[ComServices sharedComServices].beersService updateBeer:fieldUpdateData onComplete:^(NSError *error)
                 {
                     NSString* msg;
                     int result = 0;
                     
                     if (error)
                     {
                         msg = @"An error occured while updating a beer icon";
                     }
                     else
                     {
                         msg = @"Beer icon were updated and awaits admin's approval";
                         result = 666;
                     }
                     
                     [super showSaveResult:result withMessage:msg];
                 }];
            }
        }];
    }
}

#pragma mark - Action Handlers

- (IBAction)selectIconClicked:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)cameraClicked:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

#pragma mark - UIImagePickerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imgNewIcon setImage:self.selectedImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self formValidation];
    }];
}

@end
