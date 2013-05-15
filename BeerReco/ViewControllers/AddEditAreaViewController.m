//
//  AddEditAreaViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "AddEditAreaViewController.h"

@interface AddEditAreaViewController ()

@end

@implementation AddEditAreaViewController

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
    self.viewTitle = @"Area";
    self.textFieldPlaceHolder = @"Areae";
    
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
        
        [[ComServices sharedComServices].areasService updateArea:fieldUpdateData onComplete:^(NSError *error)
        {   
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while updating a area";
             }
             else
             {
                 msg = @"Area was updated and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
    else
    {
        AreaM* item = [[AreaM alloc] init];
        item.name = object;
        
        [[ComServices sharedComServices].areasService addArea:item onComplete:^(AreaM *area, NSError *error)
        {   
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while creating a area";
             }
             else
             {
                 msg = @"Area was created and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
}

@end
