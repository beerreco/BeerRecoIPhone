//
//  EditPlaceIconViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/22/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAddEditViewController.h"

@interface EditPlaceIconViewController : SimpleAddEditViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) PlaceM* editedItem;

@property (weak, nonatomic) IBOutlet UIImageView *imgNewIcon;

@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectIcon;

- (IBAction)selectIconClicked:(id)sender;
- (IBAction)cameraClicked:(id)sender;

@end
