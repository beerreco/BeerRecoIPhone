//
//  AddEditBeerNameViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/22/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "EditBeerNameViewController.h"

@interface EditBeerNameViewController ()

@end

@implementation EditBeerNameViewController

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
    self.viewTitle = @"Beer Name";
    self.textFieldPlaceHolder = @"Beer Name";
    
    if (self.editedItem)
    {
        self.previousValue = self.editedItem.name;
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
        fieldUpdateData.editedFieldName = @"name";
        fieldUpdateData.oldValue = self.editedItem.name;
        fieldUpdateData.suggestedValue = object;
        
        [[ComServices sharedComServices].beersService updateBeer:fieldUpdateData onComplete:^(NSError *error)
        {   
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while updating a beer name";
             }
             else
             {
                 msg = @"Beer name was updated and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
}

@end
