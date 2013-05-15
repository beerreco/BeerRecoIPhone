//
//  AddEditBeerTypeViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "AddEditBeerTypeViewController.h"

@interface AddEditBeerTypeViewController ()

@end

@implementation AddEditBeerTypeViewController

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
        
        [[ComServices sharedComServices].beerTypesService updateBeerType:fieldUpdateData onComplete:^(NSError *error)
        {
            NSString* msg;
            int result = 0;
             
            if (error)
            {
                msg = @"An error occured while updating a beer type";
            }
            else
            {
                msg = @"Beer type was updated and awaits admin's approval";
                result = 666;
            }
             
            [super showSaveResult:result withMessage:msg];
        }];
    }
    else
    {
        BeerTypeM* beerType = [[BeerTypeM alloc] init];
        beerType.name = object;
        
        [[ComServices sharedComServices].beerTypesService addBeerType:beerType onComplete:^(BeerTypeM *beerType, NSError *error)
         {
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while creating a beer type";
             }
             else
             {
                 msg = @"Beer type was created and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
}

@end
