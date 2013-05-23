//
//  EditAlcoholPercentViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/22/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "EditAlcoholPercentViewController.h"

@interface EditAlcoholPercentViewController ()

@end

@implementation EditAlcoholPercentViewController

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
    self.viewTitle = @"Alcohol Percentage";
    self.textFieldPlaceHolder = @"Alcohol Percentage";
    
    if (self.editedItem)
    {
        self.previousValue = [NSString stringWithFormat:@"%.1f", self.editedItem.alcoholPercent];
    }
    
    [self.txtFieldName setKeyboardType:UIKeyboardTypeDecimalPad];
}

-(void)innerSetup
{
    
}

-(BOOL)innerFormValidation
{
    double newValue = [self.txtFieldName.text doubleValue];
    
    return self.editedItem.alcoholPercent != newValue;
}

-(BOOL)innerValidateEditedTextField:(id)sender
{
    BOOL isValid = YES;
    NSArray* parts = [self.txtFieldName.text componentsSeparatedByString:@"."];
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
    
    return isValid;
}

-(void)saveItem:(id)object
{
    if (self.editedItem)
    {
        FieldUpdateDataM* fieldUpdateData = [[FieldUpdateDataM alloc] init];
        fieldUpdateData.originalObjectId = self.editedItem.id;
        fieldUpdateData.editedFieldName = @"alcoholPercent";
        fieldUpdateData.oldValue = [NSString stringWithFormat:@"%.1f", self.editedItem.alcoholPercent];
        fieldUpdateData.suggestedValue = object;
        
        [[ComServices sharedComServices].beersService updateBeer:fieldUpdateData onComplete:^(NSError *error)
         {
             NSString* msg;
             int result = 0;
             
             if (error)
             {
                 msg = @"An error occured while updating a beer alchohol precent";
             }
             else
             {
                 msg = @"Beer alchohol precent were updated and awaits admin's approval";
                 result = 666;
             }
             
             [super showSaveResult:result withMessage:msg];
         }];
    }
}

@end
