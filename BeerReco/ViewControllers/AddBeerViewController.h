//
//  AddEditBeerViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAddEditViewController.h"
#import "BeerCategoriesViewController.h"

@interface AddBeerViewController : SimpleAddEditViewController <UITableViewDataSource, UITableViewDelegate, BeerTypeSelectionDelegate, OriginCountrySelectionDelegate, BrewerySelectionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) BeerTypeM* selectedBeerType;
@property (nonatomic, strong) CountryM* selectedCountry;
@property (nonatomic, strong) BreweryM* selectedBrewery;

@property (weak, nonatomic) IBOutlet UITableView *tbProperties;

@property (weak, nonatomic) UITextField *txtBeerName;
@property (weak, nonatomic) UIImageView *imgBeerIcon;
@property (weak, nonatomic) UIButton *btnGallery;
@property (weak, nonatomic) UIButton *btnCamera;
@property (strong, nonatomic) UIButton *btnClearBeerType;
@property (weak, nonatomic) UISwitch *switchBeerType;
@property (weak, nonatomic) UITextField *txtNewBeerType;
@property (strong, nonatomic) UIButton *btnClearCountry;
@property (weak, nonatomic) UISwitch *switchCountry;
@property (weak, nonatomic) UITextField *txtNewCountry;
@property (strong, nonatomic) UIButton *btnClearBrewery;
@property (weak, nonatomic) UISwitch *switchNewBrewery;
@property (weak, nonatomic) UITextField *txtNewBrewery;
@property (weak, nonatomic) UITextField *txtComponents;
@property (weak, nonatomic) UITextField *txtAlcohol;

- (void)txtBeerNameValueChanged:(id)sender;
- (void)galleryClicked:(id)sender;
- (void)cameraClicked:(id)sender;
- (void)clearBeerTypeClicked:(id)sender;
- (void)switchBeerTypeValueChanged:(id)sender;
- (void)txtNewBeerTypeValueChanged:(id)sender;
- (void)clearCountryClicked:(id)sender;
- (void)switchCountryValueChanged:(id)sender;
- (void)txtNewCountryValueChanged:(id)sender;
- (void)clearBreweryClicked:(id)sender;
- (void)switchNewBreweryValueChanged:(id)sender;
- (void)txtNewBreweryValueChanged:(id)sender;
- (void)txtComponentsValueChanged:(id)sender;
- (void)txtAlcoholValueChanged:(id)sender;

@end
