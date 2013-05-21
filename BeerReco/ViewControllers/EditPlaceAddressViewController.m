//
//  EditPlaceAddressViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/22/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "EditPlaceAddressViewController.h"

@interface EditPlaceAddressViewController ()

@end

@implementation EditPlaceAddressViewController

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

#pragma mark - Virtual Methods

-(void)innerVisualSetup
{
    self.viewTitle = @"Place Address";
    self.textFieldPlaceHolder = @"Place Address";
    
    if (self.editedItem)
    {
        self.previousValue = self.editedItem.address;
    }
}

-(void)innerSetup
{
    
}

-(BOOL)innerFormValidation
{
    return YES;
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
        FieldUpdateDataM* fieldUpdateData = [[FieldUpdateDataM alloc] init];
        fieldUpdateData.originalObjectId = self.editedItem.id;
        fieldUpdateData.editedFieldName = @"address";
        fieldUpdateData.oldValue = self.editedItem.address;
        fieldUpdateData.suggestedValue = object;
        
        [[ComServices sharedComServices].placesService updatePlace:fieldUpdateData onComplete:^(NSError *error)
         {
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while updating a place address";
             }
             else
             {
                 msg = @"Place address was updated and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
}

@end
