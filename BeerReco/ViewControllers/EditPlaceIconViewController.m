//
//  EditPlaceIconViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/22/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "EditPlaceIconViewController.h"

@interface EditPlaceIconViewController ()

@property (nonatomic, strong) UIImage* selectedImage;

@end

@implementation EditPlaceIconViewController

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
    
    self.viewTitle = @"Place Icon";
    self.textFieldPlaceHolder = @"Place Icon";
    
    if (self.editedItem)
    {
        self.previousValue = self.editedItem.placeIconUrl;
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
        [[ComServices sharedComServices].fileManagementService uploadFile:self.selectedImage ofEntity:ImageOfPlace onComplete:^(NSString *filePath, NSError *error)
         {
             if (error || [NSString isNullOrEmpty:filePath])
             {
                 [super showSaveResult:0 withMessage:@"Error while uploading the image"];
             }
             else
             {
                 FieldUpdateDataM* fieldUpdateData = [[FieldUpdateDataM alloc] init];
                 fieldUpdateData.originalObjectId = self.editedItem.id;
                 fieldUpdateData.editedFieldName = @"placeIconUrl";
                 fieldUpdateData.oldValue = self.editedItem.placeIconUrl;
                 fieldUpdateData.suggestedValue = filePath;
                 
                 [[ComServices sharedComServices].placesService updatePlace:fieldUpdateData onComplete:^(NSError *error)
                 {   
                      NSString* msg;
                      int result = 0;
                      
                      if (error)
                      {
                          msg = @"An error occured while updating a place icon";
                      }
                      else
                      {
                          msg = @"Place icon were updated and awaits admin's approval";
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
