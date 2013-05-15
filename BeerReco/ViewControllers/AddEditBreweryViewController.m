//
//  AddEditBreweryViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "AddEditBreweryViewController.h"

@interface AddEditBreweryViewController ()

@end

@implementation AddEditBreweryViewController

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
    self.viewTitle = @"Beer Type";
    self.textFieldPlaceHolder = @"Beer Type";
    
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

-(void)saveItem:(id)object
{
    if (self.editedItem)
    {
        FieldUpdateDataM* fieldUpdateData = [[FieldUpdateDataM alloc] init];
        fieldUpdateData.originalObjectId = self.editedItem.id;
        fieldUpdateData.editedFieldName = @"name";
        fieldUpdateData.oldValue = self.editedItem.name;
        fieldUpdateData.suggestedValue = object;
        
        [[ComServices sharedComServices].breweryService updateBrewery:fieldUpdateData onComplete:^(NSError *error)
        {   
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while updating a brewery";
             }
             else
             {
                 msg = @"Brewery was updated and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
    else
    {
        BreweryM* item = [[BreweryM alloc] init];
        item.name = object;
        
        [[ComServices sharedComServices].breweryService addBrewery:item onComplete:^(BreweryM *brewery, NSError *error)
        {   
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while creating a brewery";
             }
             else
             {
                 msg = @"Brewery was created and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
}

@end
