//
//  EditBeerComponentsViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/22/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "EditBeerComponentsViewController.h"

@interface EditBeerComponentsViewController ()

@end

@implementation EditBeerComponentsViewController

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
    [super viewDidUnload];
}

#pragma mark - Virtual Methods

-(void)innerVisualSetup
{
    self.viewTitle = @"Beer Components";
    self.textFieldPlaceHolder = @"Beer Components";
    
    if (self.editedItem)
    {
        self.previousValue = self.editedItem.madeOf;
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
        fieldUpdateData.editedFieldName = @"madeOf";
        fieldUpdateData.oldValue = self.editedItem.madeOf;
        fieldUpdateData.suggestedValue = object;
        
        [[ComServices sharedComServices].beersService updateBeer:fieldUpdateData onComplete:^(NSError *error)
         {
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while updating a beer components";
             }
             else
             {
                 msg = @"Beer components were updated and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
}

@end
