//
//  aaViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SimpleAddEditViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString* viewTitle;
@property (nonatomic, strong) NSString* textFieldPlaceHolder;

@property (nonatomic, strong) NSString* previousValue;

@property (nonatomic, strong) NSString* textFieldPreviousValue;

@property (nonatomic, strong) MBProgressHUD* HUD;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldName;

- (IBAction)fieldNameValueChanged:(id)sender;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;

#pragma mark - Virtual Methods

-(void)innerVisualSetup;
-(void)innerSetup;
-(BOOL)innerFormValidation;
-(BOOL)formValidation;
-(void)saveItem:(id)object;

#pragma mark - Public Methods

-(void)showSaveResult:(int)result withMessage:(NSString*)msg;

@end
