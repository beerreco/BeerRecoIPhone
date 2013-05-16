//
//  aaViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "SimpleAddEditViewController.h"

@interface SimpleAddEditViewController ()

@end

@implementation SimpleAddEditViewController

@synthesize HUD = _HUD;

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
    
    [self visualSetup];
    
    [self setup];
}

- (void)viewDidUnload
{
    [self setBtnCancel:nil];
    [self setBtnSave:nil];
    [self setTxtFieldName:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Virtual Methods

-(void)innerVisualSetup
{
    
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
    return YES;
}

-(void)saveItem:(id)object
{
    
}

#pragma mark - Public Methods

-(void)showSaveResult:(int)result withMessage:(NSString*)msg
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:self.viewTitle message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = result;
    
    [self.HUD hide:YES];
    [alert show];
}

-(BOOL)formValidation
{
    BOOL isValid = ![NSString isNullOrEmpty:self.txtFieldName.text];
    
    isValid &= ![self.previousValue isEqualToString:self.txtFieldName.text];
    
    isValid &= [self innerFormValidation];
    
    [self.btnSave setEnabled:isValid];
    
    return isValid;
}

#pragma mark - Private Methods

-(void)visualSetup
{
    [self innerVisualSetup];
    
    self.navigationItem.title = self.viewTitle;
    
    self.txtFieldName.placeholder = self.textFieldPlaceHolder;
    
    if (![NSString isNullOrEmpty:self.previousValue])
    {
        self.txtFieldName.text = self.previousValue;
        self.textFieldPreviousValue = self.previousValue;
    }
    
    [self formValidation];
    
    [self.txtFieldName becomeFirstResponder];
}

-(void)setup
{
    [self innerSetup];
}

-(BOOL)validateEditedTextField:(id)sender
{
    BOOL isValid = YES;
    
    isValid &= [self innerValidateEditedTextField:sender];
    
    return isValid;
}

#pragma mark - Action Handlers

- (IBAction)fieldNameValueChanged:(id)sender
{
    if (![self validateEditedTextField:sender])
    {
        self.txtFieldName.text = self.textFieldPreviousValue;
    }
    else
    {
        self.textFieldPreviousValue = self.txtFieldName.text;
        
        [self formValidation];
    }
}

- (IBAction)cancelClicked:(id)sender
{
    [self.txtFieldName resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)saveClicked:(id)sender
{
    [self.txtFieldName resignFirstResponder];
    
    if (self.HUD == nil)
    {
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.dimBackground = YES;
    }
    
    [self saveItem:self.txtFieldName.text];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self formValidation];
}

#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	if (self.HUD == hud)
    {
        self.HUD = nil;
    }
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 666)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

@end
