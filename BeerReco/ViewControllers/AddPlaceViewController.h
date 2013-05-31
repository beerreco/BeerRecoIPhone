//
//  AddEditPlaceViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAddEditViewController.h"
#import "PlaceAreasViewController.h"

@interface AddPlaceViewController : SimpleAddEditViewController <UITableViewDataSource, UITableViewDelegate, PlaceTypeSelectionDelegate, AreaSelectionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) AreaM* selectedArea;
@property (nonatomic, strong) PlaceTypeM* selectedPlaceType;

@property (weak, nonatomic) IBOutlet UITableView *tbProperties;

@property (weak, nonatomic) UITextField *txtPlaceName;
@property (weak, nonatomic) UIImageView *imgPlaceIcon;
@property (weak, nonatomic) UIButton *btnGallery;
@property (weak, nonatomic) UIButton *btnCamera;
@property (strong, nonatomic) UIButton *btnClearPlaceType;
@property (weak, nonatomic) UISwitch *switchPlaceType;
@property (weak, nonatomic) UITextField *txtNewPlaceType;
@property (strong, nonatomic) UIButton *btnClearArea;
@property (weak, nonatomic) UITextField *txtAddress;

- (void)txtPlaceNameValueChanged:(id)sender;
- (void)galleryClicked:(id)sender;
- (void)cameraClicked:(id)sender;
- (void)clearPlaceTypeClicked:(id)sender;
- (void)switchPlaceTypeValueChanged:(id)sender;
- (void)txtNewPlaceTypeValueChanged:(id)sender;
- (void)clearAreaClicked:(id)sender;
- (void)txtAddressValueChanged:(id)sender;

@end
